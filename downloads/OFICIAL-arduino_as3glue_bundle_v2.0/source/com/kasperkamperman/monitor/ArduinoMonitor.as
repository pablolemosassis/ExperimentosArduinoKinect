package  com.kasperkamperman.monitor
       Problem switch servo - pwm doens't work without restarting. 
	*/
	
	
	import flash.display.*;
	import net.eriksjodin.arduino.ArduinoWithServo;
	
	import com.kasperkamperman.monitor.PinConfigObj;
	import com.kasperkamperman.monitor.PinMonitorObj;
	
	import fl.controls.Button; 
	
  		
		private var _a:ArduinoWithServo;
		
		private var _configObject:PinConfigObj;
		
			  _monitorObjectsArray[i] = _monitorObject;			  
				
			  // no config object needed for the analog pins
			  // they cannot be changed	
			  if(i<14) 
			  {	
				  _configObject = new PinConfigObj(_a, i, _defaultCfg, _monitorObject);
				  _configObjectsArray[i] = _configObject;
				  _configObject.x = 10;
				  _configObject.y = 10+(35*(i-2));
				  addChild(_configObject);
			  }
			 			   			  
			
			_a.addEventListener(ArduinoEvent.ANALOG_DATA, onReceiveAnalogData); 
		}			