package tests
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.si.sion.*;
	import org.osflash.signals.Signal;
	
	public class SionSound extends Sprite
	{
		public var driver:SiONDriver = new SiONDriver();
		
		private var _pitchRatios      :Object  ;
		public var keyboardSignal:Signal = new Signal(int);
		
		public function SionSound()
		{
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		protected function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			keyboardSignal.add(playSounds);
			//
			_pitchRatios = {49:1, 50:1.059, 51:1.122, 52:1.189, 53:1.259, 54:1.334, 55:1.414, 56:1.498, 57:1.587};
			
			//driver.play("t100 l8 [ccggaag4 ffeeddc4 | [ggffeed4]2 ]2");
			
			//"fgab<cdef;"
		}
		//
		private function playSounds(canal:int):void{
			trace("canal: "+ canal);
			
			//"fgab<cdef;"
			switch(canal){
				//acendendo
				case 1:
					driver.play("f");
					break;
				case 2:
					driver.play("g");
					break;
				case 3:
					driver.play("a");
					break;
				case 4:
					driver.play("b");
					break;
				case 5:
					driver.play("<c");
					break;
				case 6:
					driver.play("<d");
					break;
				case 7:
					driver.play("<e");
					break;
				case 8:
					driver.play("<f");
					break;
				
				
			}
		}
		
	}
}