package tests
{
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import net.eriksjodin.arduino.Arduino;
	import net.eriksjodin.arduino.ArduinoWithServo;
	import net.eriksjodin.arduino.events.ArduinoEvent;
	import net.eriksjodin.arduino.events.ArduinoSysExEvent;
	
	public class ArduinoCaller
	{
		public var keyboardSignal:Signal = new Signal(int);
		
		private var a:ArduinoWithServo;
		
		private var apaga2 : TweenLite = new TweenLite(apagaEssaLuz, 0, {});
		private var apaga6 : TweenLite = new TweenLite(apagaEssaLuz, 0, {});
		private var apaga9 : TweenLite = new TweenLite(apagaEssaLuz, 0, {});
		private var tweensDict:Vector.<TweenLite> = new <TweenLite> [apaga2, apaga6, apaga9];
		private var tempoPraApagar:Number = 0.32;
		
		public function ArduinoCaller()
		{
			
		}
		public function init():void{
			// connect to a serial proxy on port 5331
			a = new ArduinoWithServo("127.0.0.1", 5331);
			
			// listen for connection 
			a.addEventListener(Event.CONNECT,onSocketConnect); 
			a.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			
			// listen for firmware (sent on startup)
			a.addEventListener(ArduinoEvent.FIRMWARE_VERSION, onReceiveFirmwareVersion);
			
		}
		//
		// == SETUP AND INITIALIZE CONNECTION ( don't modify ) ==================================
		
		// triggered when there is an IO Error
		private function errorHandler(errorEvent:IOErrorEvent):void 
		{   trace("- "+errorEvent.text);
			trace("- Did you start the Serproxy program ?");
		}
		
		// triggered when a serial socket connection has been established
		private function onSocketConnect(e:Object):void 
		{	trace("- Connection with Serproxy established. Wait one moment.");
			
			// request the firmware version
			a.requestFirmwareVersion();	
		}
		
		private function onReceiveFirmwareVersion(e:ArduinoEvent):void 
		{   trace("- Connection with Arduino - Firmata version: " + String(e.value)); 		
			trace("- Set default pin configuration.");
			
			a.setPinMode(2, Arduino.OUTPUT);
			a.setPinMode(6, Arduino.OUTPUT);
			a.setPinMode(9, Arduino.OUTPUT);
			
			// for digital pins its only one setting
			a.enableDigitalPinReporting();	
			
			startProgram();	
		}
		//
		private function startProgram():void{
			//
			keyboardSignal.add(facaSeALuz);
			a.writeDigitalPin(10, 0);
		}
		private function facaSeALuz(canal:uint):void{
			switch(canal){
				case 2:
					a.writeDigitalPin(2,1);
					tweensDict[0].kill();
					tweensDict[0] = new TweenLite(apagaEssaLuz, 0, {onComplete:apagaEssaLuz, onCompleteParams:[2], delay:tempoPraApagar});
					break;
				case 6:
					a.writeDigitalPin(6,1);
					tweensDict[1].kill();
					tweensDict[1] = new TweenLite(apagaEssaLuz, 0, {onComplete:apagaEssaLuz, onCompleteParams:[6], delay:tempoPraApagar});
					break;
				case 9:
					a.writeDigitalPin(9,1);
					tweensDict[2].kill();
					tweensDict[2] = new TweenLite(apagaEssaLuz, 0, {onComplete:apagaEssaLuz, onCompleteParams:[9], delay:tempoPraApagar});
					break;
				
			}
			
			
		}
		private function apagaEssaLuz(canal:uint):void{
			if(canal){
				a.writeDigitalPin(canal,0);
			}
		}
	}
}