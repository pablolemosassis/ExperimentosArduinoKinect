package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	
	import tests.*;
	
	[SWF(frameRate="60", width="640", height="480", backgroundColor="#000000")]
	public class FlashArduino1 extends Sprite
	{
		private var DEBUG:Boolean = true;
		//private var DEBUG:Boolean = false;
		
		private var mStarling:Starling;
		private var arduinoCaller:ArduinoCaller = new ArduinoCaller();
		private var receptorDeOSC:ReceptorDeOSC = new ReceptorDeOSC();
		private var soundGeneration:SoundGeneration;
		private var sionSound:SionSound;
		
		private var signalsArray:Vector.<Signal>;
		
		public function FlashArduino1()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		//
		protected function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			//
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			//
			/*soundGeneration = new SoundGeneration(stage);
			addChild(soundGeneration);*/
			//
			sionSound = new SionSound();
			addChild(sionSound);
			//
			startStarling();
			arduinoCaller.init();
			addChild(receptorDeOSC);
			receptorDeOSC.init(despachaGeral);			
			//
			
			
		}
		
		private  function keyDownListener(e:KeyboardEvent):void {
			//trace("keyDownListener: " + e.keyCode);
			switch(e.keyCode){
				case 49:
				//tecla 1
					despachaGeral(1);
					break;
				case 50:
				//tecla 2
					despachaGeral(2);
					break;
				case 51:
				//tecla 3
					despachaGeral(3);
					break;
				//
				case 52:
					//tecla 4
					despachaGeral(4);
					break;
				//
				case 53:
					//tecla 5
					despachaGeral(5);
					break;
				case 54:
					//tecla 6
					despachaGeral(6);
					break;
				case 55:
					//tecla 7
					despachaGeral(7);
					break;
				case 56:
					//tecla 8
					despachaGeral(8);
					break;
				case 57:
					//tecla 9
					despachaGeral(9);
					break;
				case 48:
					//tecla 0
					despachaGeral(0);
					break;
				
			}
		}
		//
		private  function keyUpListener(e:KeyboardEvent):void {
			//trace("keyUpListener: " + e.keyCode);
			switch(e.keyCode){
				case 49:
					//tecla 1
					despachaGeral(-1);
					break;
				case 50:
					//tecla 2
					despachaGeral(-2);
					break;
				case 51:
					//tecla 3
					despachaGeral(-3);
					break;
				//
				case 52:
					//tecla 4
					despachaGeral(-4);
					break;
				//
				case 53:
					//tecla 5
					despachaGeral(-5);
					break;
				case 54:
					//tecla 6
					despachaGeral(-6);
					break;
				case 55:
					//tecla 7
					despachaGeral(-7);
					break;
				case 56:
					//tecla 8
					despachaGeral(-8);
					break;
			}
		}
		
		private function startStarling():void{
			mStarling = new Starling(SoundAndImage, stage);
			mStarling.enableErrorChecking = false;
			if(DEBUG)mStarling.showStats = true;
			mStarling.start(); 	
			mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, todoMundoPronto);
		}
		private function todoMundoPronto(e:Event):void{
			signalsArray = new <Signal> [SoundAndImage.current.keyboardSignal, arduinoCaller.keyboardSignal, sionSound.keyboardSignal];
			//
		}
		public function despachaGeral(canal:int):void{
			for(var i:int = 0; i < signalsArray.length; i++)
			{
				signalsArray[i].dispatch(canal);
			}
		}
		
	}
}