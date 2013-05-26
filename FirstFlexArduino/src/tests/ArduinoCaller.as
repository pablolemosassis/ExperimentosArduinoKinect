package tests
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.quetwo.Arduino.ArduinoConnector;
	import com.quetwo.Arduino.ArduinoConnectorEvent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import org.osflash.signals.Signal;
	
		
	public class ArduinoCaller
	{	
		public var keyboardSignal:Signal = new Signal(int);
		//
		public var arduino:ArduinoConnector;
		
		public function ArduinoCaller(){
			
		}
		public function init():void{
			arduino = new ArduinoConnector();
			trace("onlyRegular Arduino Ports: " + arduino.getComPorts());
			//trace("All Ports: " + arduino.getComPorts(true, true));
			trace("All Ports length: " + arduino.getComPorts(true, true).length);
			var port:String = arduino.getComPorts()[0];
			//var port:String = arduino.getComPorts(true,true)[(arduino.getComPorts(true,true).length)-1];
			trace("Choosen port: " + port);
			arduino.connect(port, 57600);
			arduino.addEventListener("socketData", fnc_dataArduino);
			//
			keyboardSignal.add(facaSeALuz);
		}
		private function fnc_dataArduino(e: ArduinoConnectorEvent): void{
			trace("From Arduino: " + arduino.readBytesAsString());
		}
		protected function closeApp(event:Event):void{
			arduino.dispose();
		}
		////////
		private function writeAndTrace(l:String):void{
			trace('arduino.writeString("' + l + '"): ' + arduino.writeString(l));
			//arduino.flush();
			
		}
		private function facaSeALuz(canal:int):void{
			trace("canal: "+ canal);
		
			switch(canal){
				//acendendo
				case 1:
					writeAndTrace("A");
					break;
				case 2:
					writeAndTrace("B");
					break;
				case 3:
					writeAndTrace("C");
					break;
				case 4:
					writeAndTrace("D");
					break;
				case 5:
					writeAndTrace("E");
					break;
				case 6:
					writeAndTrace("F");
					break;
				case 7:
					writeAndTrace("G");
					break;
				case 8:
					writeAndTrace("H");
					break;
				//apagando
				case -1:
					writeAndTrace("I");
					break;
				case -2:
					writeAndTrace("J");
					break;
				case -3:
					writeAndTrace("L");
					break;
				case -4:
					writeAndTrace("M");
					break
				case -5:
					writeAndTrace("N");
					break;
				case -6:
					writeAndTrace("O");
					break;
				case -7:
					writeAndTrace("P");
					break;
				case -8:
					writeAndTrace("Q");
					break;
				//apagando todas
				case 0:
					writeAndTrace("I");
					writeAndTrace("J");
					writeAndTrace("L");
					writeAndTrace("M");
					writeAndTrace("N");
					writeAndTrace("O");
					writeAndTrace("P");
					writeAndTrace("Q");
					break;
				////////
				/*case 2:
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
				case 8:
					a.writeDigitalPin(8,1);
					tweensDict[3].kill();
					tweensDict[3] = new TweenLite(apagaEssaLuz, 0, {onComplete:apagaEssaLuz, onCompleteParams:[8], delay:tempoPraApagar});
					break;
				case 7:
					a.writeDigitalPin(7,1);
					tweensDict[4].kill();
					tweensDict[4] = new TweenLite(apagaEssaLuz, 0, {onComplete:apagaEssaLuz, onCompleteParams:[7], delay:tempoPraApagar});
					break;*/
				
			//fim do switch
			}
		}
	
	//end of class
	}
	
//end of package
}

/////old non-native as3glue

/*package tests
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
		private var apaga8 : TweenLite = new TweenLite(apagaEssaLuz, 0, {});
		private var apaga7 : TweenLite = new TweenLite(apagaEssaLuz, 0, {});
		private var tweensDict:Vector.<TweenLite> = new <TweenLite> [apaga2, apaga6, apaga9, apaga8, apaga7];
		private var tempoPraApagar:Number = 0.32;
		
		public function ArduinoCaller()
		{
		
		}
		public function init():void{
			trace("init arduino");
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
			
			//ARDUINO CODE
			// The EL channels are on pins 2 through 9
			// Initialize the pins as outputs
			
			//pinMode(2, OUTPUT);  // channel A  
			//pinMode(3, OUTPUT);  // channel B   
			//pinMode(4, OUTPUT);  // channel C
			//pinMode(5, OUTPUT);  // channel D    
			//pinMode(6, OUTPUT);  // channel E
			//pinMode(7, OUTPUT);  // channel F
			//pinMode(8, OUTPUT);  // channel G
			//pinMode(9, OUTPUT);  // channel H
			// We also have two status LEDs, pin 10 on the Escudo, 
			// and pin 13 on the Arduino itself
			
			//pinMode(10, OUTPUT);     
			//pinMode(13, OUTPUT);
			///
			
			a.setPinMode(2, Arduino.OUTPUT);
			a.setPinMode(6, Arduino.OUTPUT);
			a.setPinMode(9, Arduino.OUTPUT);
			a.setPinMode(8, Arduino.OUTPUT);
			a.setPinMode(7, Arduino.OUTPUT);
			//
			a.setPinMode(13, Arduino.OUTPUT);
			
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
			case 8:
			a.writeDigitalPin(8,1);
			tweensDict[3].kill();
			tweensDict[3] = new TweenLite(apagaEssaLuz, 0, {onComplete:apagaEssaLuz, onCompleteParams:[8], delay:tempoPraApagar});
			break;
			case 7:
			a.writeDigitalPin(7,1);
			tweensDict[4].kill();
			tweensDict[4] = new TweenLite(apagaEssaLuz, 0, {onComplete:apagaEssaLuz, onCompleteParams:[7], delay:tempoPraApagar});
			break;
		}
		
		
		}
		private function apagaEssaLuz(canal:uint):void{
			if(canal){
			a.writeDigitalPin(canal,0);
		}
		}
	}
}*/
