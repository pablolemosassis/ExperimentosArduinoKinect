/**
 * VERSION: 12.0
 * DATE: 2012-01-14
 * AS3 
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.plugins {
	import com.greensock.TweenLite;
	import com.greensock.core.Animation;
	import com.greensock.core.SimpleTimeline;
/**
 * [AS3/AS2 only] Sometimes you want to tween a property (or several) but you don't have a specific end value in mind - instead,
 * you'd rather describe the movement in terms of physics concepts, like velocity, acceleration, 
 * and/or friction. PhysicsPropsPlugin allows you to tween any numeric property of any object based
 * on these concepts. Keep in mind that any easing equation you define for your tween will be completely
 * ignored for these properties. Instead, the physics parameters will determine the movement/easing.
 * These parameters, by the way, are not intended to be dynamically updateable, but one unique convenience 
 * is that everything is reverseable. So if you create several physics-based tweens, for example, and 
 * throw them into a TimelineLite, you could simply call reverse() on the timeline to watch the objects 
 * retrace their steps right back to the beginning. Here are the parameters you can define (note that 
 * friction and acceleration are both completely optional):
 * 	<ul>
 * 		<li><b>velocity : Number</b> - the initial velocity of the object measured in units per time 
 * 								unit (usually seconds, but for tweens where useFrames is true, it would 
 * 								be measured in frames). The default is zero.</li>
 * 		<li><b>acceleration : Number</b> [optional] - the amount of acceleration applied to the object, measured
 * 								in units per time unit (usually seconds, but for tweens where useFrames 
 * 								is true, it would be measured in frames). The default is zero.</li>
 * 		<li><b>friction : Number</b> [optional] - a value between 0 and 1 where 0 is no friction, 0.08 is a small amount of
 * 								friction, and 1 will completely prevent any movement. This is not meant to be precise or 
 * 								scientific in any way, but rather serves as an easy way to apply a friction-like
 * 								physics effect to your tween. Generally it is best to experiment with this number a bit.
 * 								Also note that friction requires more processing than physics tweens without any friction.</li>
 * 	</ul><br />
 * 
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.PhysicsPropsPlugin; <br />
 * 		TweenPlugin.activate([PhysicsPropsPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 2, {physicsProps:{<br />
 * 										x:{velocity:100, acceleration:200},<br />
 * 										y:{velocity:-200, friction:0.1}<br />
 * 										}<br />
 * 							}); <br /><br />
 *  </code>
 * 
 * PhysicsPropsPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
 * without violating the terms of use. Visit http://www.greensock.com/club/ to sign up or get more details.<br /><br />
 * 
 * <p><strong>Copyright 2008-2012, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class PhysicsPropsPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		protected var _tween:TweenLite;
		/** @private **/
		protected var _target:Object;
		/** @private **/
		protected var _props:Array;
		/** @private **/
		protected var _hasFriction:Boolean;
		/** @private **/
		protected var _runBackwards:Boolean;
		/** @private **/
		protected var _step:uint; 
		/** @private for tweens with friction, we need to iterate through steps. frames-based tweens will iterate once per frame, and seconds-based tweens will iterate 30 times per second. **/
		protected var _stepsPerTimeUnit:uint = 30;
		
		
		/** @private **/
		public function PhysicsPropsPlugin() {
			super("physicsProps");
			_overwriteProps.pop();
		}
		
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			_target = target;
			_tween = tween;
			_runBackwards = Boolean(_tween.vars.runBackwards == true);
			_step = 0;
			var tl:SimpleTimeline = _tween._timeline;
			while (tl._timeline) {
				tl = tl._timeline;
			}
			if (tl == Animation._rootFramesTimeline) { //indicates the tween uses frames instead of seconds.
				_stepsPerTimeUnit = 1;
			}
			_props = [];
			var p:String, curProp:Object, cnt:uint = 0;
			for (p in value) {
				curProp = value[p];
				if (curProp.velocity || curProp.acceleration) {
					_props[cnt++] = new PhysicsProp(target, p, curProp.velocity, curProp.acceleration, curProp.friction, _stepsPerTimeUnit);
					_overwriteProps[cnt] = p;
					if (curProp.friction) {
						_hasFriction = true;
					}
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
				if (("physicsProps" in lookup) || (_props[i].p in lookup)) {
					_props[i].r = value;
				}
			}
		}
		
		/** @private **/
		override public function setRatio(v:Number):void {
			var i:int = _props.length, time:Number = _tween._time, values:Array = [], curProp:PhysicsProp, val:Number;
			if (_runBackwards) {
				time = _tween._duration - time;
			}
			if (_hasFriction) {
				var steps:int = int(time * _stepsPerTimeUnit) - _step;
				var remainder:Number = ((time * _stepsPerTimeUnit) % 1);
				var j:int;
				if (steps >= 0) { 	//going forward
					while (--i > -1) {
						curProp = _props[i];
						j = steps;
						while (--j > -1) {
							curProp.v += curProp.a;
							curProp.v *= curProp.friction;
							curProp.value += curProp.v;
						}
						values[i] = curProp.value + (curProp.v * remainder);
					}					
					
				} else { 			//going backwards
					while (--i > -1) {
						curProp = _props[i];
						j = -steps;
						while (--j > -1) {
							curProp.value -= curProp.v;
							curProp.v /= curProp.friction;
							curProp.v -= curProp.a;
						}
						values[i] = curProp.value + (curProp.v * remainder);
					}
				}
				_step += steps;
				
			} else {
				var tt:Number = time * time * 0.5;
				while (--i > -1) {
					curProp = _props[i];
					values[i] = curProp.start + ((curProp.velocity * time) + (curProp.acceleration * tt));
				}
			}
			
			i = _props.length;
			while (--i > -1) {
				val = (PhysicsProp((curProp = _props[i])).r == false) ? values[i] : ((val = values[i]) > 0) ? (val + 0.5) >> 0 : (val - 0.5) >> 0;
				if (curProp.f) {
					_target[curProp.p](val);
				} else {
					_target[curProp.p] = val;
				}
			}
			
		}
		
	}
}

internal class PhysicsProp {
	public var p:String;
	public var f:Boolean;
	public var r:Boolean;
	public var start:Number;
	public var velocity:Number;
	public var acceleration:Number;
	public var friction:Number;
	public var v:Number; //used to track the current velocity as we iterate through friction-based tween algorithms
	public var a:Number; //only used in friction-based tweens
	public var value:Number; //used to track the current property value in friction-based tweens
	
	public function PhysicsProp(target:Object, p:String, velocity:Number, acceleration:Number, friction:Number, stepsPerTimeUnit:uint) {
		this.p = p;
		this.f = (target[p] is Function);
		this.start = this.value = (!this.f) ? Number(target[p]) : target[ ((p.indexOf("set") || !("get" + p.substr(3) in target)) ? p : "get" + p.substr(3)) ]();;
		this.velocity = velocity || 0;
		this.v = this.velocity / stepsPerTimeUnit;
		if (acceleration || acceleration == 0) {
			this.acceleration = acceleration;
			this.a = this.acceleration / (stepsPerTimeUnit * stepsPerTimeUnit);
		} else {
			this.acceleration = this.a = 0;
		}
		this.friction = (friction || friction == 0) ? 1 - friction : 1;
	}	

}