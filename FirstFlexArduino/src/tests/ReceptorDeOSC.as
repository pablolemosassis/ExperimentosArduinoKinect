package tests
{
	import flash.display.Sprite;
	
	import org.tuio.connectors.UDPConnector;
	import org.tuio.osc.IOSCListener;
	import org.tuio.osc.OSCManager;
	import org.tuio.osc.OSCMessage;
	
	public class ReceptorDeOSC extends Sprite implements IOSCListener
	{
		private var manager:OSCManager;
		public var despachaGeral:Function;
				
		public function ReceptorDeOSC()
		{
		}
		public function init(_despachaGeral:Function):void{
			
			//conectando com o bikinect - vamos tentar unir os dois no mesmo IP?
			//manager = new OSCManager(new UDPConnector("127.0.0.1", 4444));
			
			//conectando com o TOUCHOSC
			//Using the UDPConnector (which is highly recommended due to better performance) 
			//In TUIOPad or TOUCHOSC you have to set the IP field to your PCs IP 
			//In your as3 project you have to init the UDPConnector with the IP “0.0.0.0” and the port given in the TUIOPad app 
			manager = new OSCManager(new UDPConnector("0.0.0.0", 3333));
			manager.addMsgListener(this);
			//
			despachaGeral = _despachaGeral;
		}
		public function acceptOSCMessage(msg:OSCMessage):void
		{
			if(msg.arguments[0]!="0"){
				trace("Message received : "+ msg.address+", "+ msg.arguments.length + " arguments");
				trace(msg.arguments.join(", "));
				
				if (msg.address == "/mappInect/canal2" || msg.address == "/7/push1") {
					despachaGeral(2);
				}
				if (msg.address == "/mappInect/canal6" || msg.address == "/7/push5") {
					despachaGeral(6);
				}
				if (msg.address == "/mappInect/canal9" || msg.address == "/7/push9") {
					despachaGeral(9);
				}
				
			}
			
			
			
			
		}
	}
}