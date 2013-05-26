package tests
{

		import flash.display.Sprite;
		import flash.display.Stage;
		import flash.events.Event;
		import flash.events.KeyboardEvent;
		import flash.events.SampleDataEvent;
		import flash.events.TimerEvent;
		import flash.media.Sound;
		import flash.media.SoundChannel;
		import flash.media.SoundMixer;
		import flash.utils.Timer;
		
		public class SoundGeneration extends Sprite
		{
			private var _sound            :Sound                = null;
			private var _channel          :SoundChannel     = null;
			private var _pitchRatios      :Object              = null;
			private const BASE_PTICH  :Number              = 440;
			private var _pitch             :Number             = 1;
			private var _timer             :Timer                = null;
			//
			public var flashStage:Stage;
			
			public function SoundGeneration(_flashStage:Stage)
			{
				flashStage = _flashStage;
				addEventListener(Event.ADDED_TO_STAGE, init);
				
			}
			protected function init(e:Event = null):void
			{
				removeEventListener(Event.ADDED_TO_STAGE, init);
				//
				_pitchRatios = {49:1, 50:1.059, 51:1.122, 52:1.189, 53:1.259, 54:1.334, 55:1.414, 56:1.498, 57:1.587};
				_timer = new Timer(100);
				_timer.addEventListener(TimerEvent.TIMER, TimerStop,false, 0, true);
				flashStage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
				flashStage.focus = this;
				
			}
			
			private function KeyDown($e:KeyboardEvent):void
			{
				if(_pitchRatios[$e.charCode]){
					if(_timer.running == false) _timer.start();
					PlaySound(_pitchRatios[$e.charCode]);
					trace(_pitchRatios[$e.charCode]);
				}
			}
			
			private function PlaySound($pitchRatio:Number):void
			{
				StopSound();
				_pitch = BASE_PTICH * $pitchRatio;
				_sound = new Sound();
				_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, WaveGenerator, false, 0, true);
				_channel = _sound.play();
			}
			
			private function WaveGenerator($e:SampleDataEvent):void
			{
				var $lev:Number;
				for (var i:uint = 0; i < 8192; i++)
				{
					$lev = 0;
					$lev += Math.sin((i + $e.position) * Math.PI / (44100 / _pitch ));
					$lev /= 2;
					$e.data.writeFloat($lev);
					$e.data.writeFloat($lev);
				}
			}
			
			private function TimerStop($e:TimerEvent):void
			{
				if(_timer.running) _timer.stop();
				StopSound();
			}
			
			private function StopSound():void
			{
				if (_channel)
				{
					_channel.stop();
					_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA,WaveGenerator);
				}
			}
			
		}
		
}