/**
 * VERSION: 12.0
 * DATE: 2012-01-12
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.plugins {
	import com.greensock.TweenLite;
/**
 * [AS3/AS2 only] If you'd like to tween something to a destination value that may change at any time,
 * DynamicPropsPlugin allows you to simply associate a function with a property so that
 * every time the tween is rendered, it calls that function to get the new destination value 
 * for the associated property. For example, if you want a MovieClip to tween to wherever the
 * mouse happens to be, you could do:<br /><br /><code>
 * 	
 * 	TweenLite.to(mc, 3, {dynamicProps:{x:getMouseX, y:getMouseY}}); <br />
 * 	function getMouseX():Number {<br />
 * 		return this.mouseX;<br />
 * 	}<br />
 * 	function getMouseY():Number {<br />
 * 		return this.mouseY;<br />
 * 	}<br /><br /></code>
 * 	
 * Of course you can get as complex as you want inside your custom function, as long as
 * it returns the destination value, TweenLite/Max will take care of adjusting things 
 * on the fly.<br /><br />
 * 
 * You can optionally pass any number of parameters to functions using the "params" 
 * special property like so:<br /><br /><code>
 * 
 * TweenLite.to(mc, 3, {dynamicProps:{x:myFunction, y:myFunction, params:{x:[mc2, "x"], y:[mc2, "y"]}}}); <br />
 * 	function myFunction(object:MovieClip, propName:String):Number {<br />
 * 		return object[propName];<br />
 * 	}<br /><br /></code>
 * 
 * DynamicPropsPlugin is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
 * You must have a valid membership to use this class without violating the terms of use. 
 * Visit <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> to sign up or get 
 * more details. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.~~; <br />
 * 		TweenPlugin.activate([DynamicPropsPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(my_mc, 3, {dynamicProps:{x:getMouseX, y:getMouseY}}); <br /><br />
 * 			
 * 		function getMouseX():Number {<br />
 * 			return this.mouseX;<br />
 * 		}<br />
 * 		function getMouseY():Number {<br />
 * 			return this.mouseY;<br />
 * 		} <br /><br />
 * </code>
 * 
 * <p><strong>Copyright 2008-2012, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class DynamicPropsPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		protected var _tween:TweenLite;
		/** @private **/
		protected var _target:Object;
		/** @private **/
		protected var _props:Array;
		/** @private **/
		protected var _prevFactor:Number;
		/** @private **/
		protected var _prevTime:Number;
		
		/** @private **/
		public function DynamicPropsPlugin() {
			super("dynamicProps");
			_overwriteProps.pop();
			_props = [];
		}
		
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			_target = tween.target;
			_tween = tween;
			var params:Object = value.params || {};
			_prevFactor = _prevTime = 0;
			for (var p:String in value) {
				if (p != "params") {
					_props[_props.length] = new DynamicProperty(_target, p, value[p] as Function, params[p]);
					_overwriteProps[_overwriteProps.length] = p;
				}
			}
			return true;
		}
		
		/** @private **/
		override public function _kill(lookup:Object):Boolean {
			var i:int = _props.length;
			while (--i > -1) {
				if (_props[i].p in lookup) {
					_props.splice(i, 1);
				}
			}
			return super._kill(lookup);
		}
		
		/** @private **/
		override public function _roundProps(lookup:Object, value:Boolean=true):void {
			var i:int = _props.length;
			while (--i > -1) {
				if (("dynamicProps" in lookup) || (_props[i].p in lookup)) {
					_props[i].r = value;
				}
			}
		}
		
		/** @private **/
		override public function setRatio(v:Number):void {
			if (v != _prevFactor) {
				var i:int = _props.length, pt:DynamicProperty, cur:Number, end:Number, ratio:Number, val:Number;
				
				//going forwards towards the end
				if (_tween._time > _prevTime) {
					ratio = (v == 1 || _prevFactor == 1) ? 0 : 1 - ((v - _prevFactor) / (1 - _prevFactor));
					while (--i > -1) {
						pt = _props[i];
						end = (pt.params) ? pt.getter.apply(null, pt.params) : pt.getter();
						cur = (!pt.f) ? _target[pt.getProp] : _target[pt.getProp]();
						val = end - ((end - cur) * ratio);
						if (pt.r) {
							val = (val > 0) ? (val + 0.5) >> 0 : (val - 0.5) >> 0; //about 4x faster than Math.round()
						}
						if (pt.f) {
							_target[pt.p](val);
						} else {
							_target[pt.p] = val;
						}
					}
					
				//going backwards towards the start
				} else {
					ratio = (v == 0 || _prevFactor == 0) ? 0 : 1 - ((v - _prevFactor) / -_prevFactor);
					while (--i > -1) {
						pt = _props[i];
						cur = (!pt.f) ? _target[pt.getProp] : _target[pt.getProp]();
						val = (!pt.r) ? pt.s + ((cur - pt.s) * ratio) : ((val = pt.s + ((cur - pt.s) * ratio)) > 0) ? (val + 0.5) >> 0 : (val - 0.5) >> 0; //about 4x faster than Math.round()
						if (pt.f) {
							_target[pt.p](val);
						} else {
							_target[pt.p] = val;
						}
					}
				}
				
				_prevFactor = v;
			}
			_prevTime = _tween._time;
		}
		
	}
}

internal class DynamicProperty {
	public var s:Number;
	public var p:String;
	public var f:Boolean;
	public var r:Boolean;
	public var getProp:String;
	public var getter:Function;
	public var params:Array;
	
	public function DynamicProperty(target:Object, p:String, getter:Function, params:Array) {
		this.p = p;
		this.f = (target[p] is Function);
		this.getProp = (!f || p.indexOf("set") || !("get" + p.substr(3) in target)) ? p : "get" + p.substr(3);
		this.s = (f) ? target[getProp]() : target[getProp];
		this.getter = getter;
		this.params = params;
	}
}