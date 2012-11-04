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
			manager = new OSCManager(new UDPConnector("127.0.0.1", 4444));
			manager.addMsgListener(this);
			//
			despachaGeral = _despachaGeral;
		}
		public function acceptOSCMessage(msg:OSCMessage):void
		{
			if(msg.arguments[0]!="0"){
				trace("Message received : "+ msg.address+", "+ msg.arguments.length + " arguments");
				trace(msg.arguments.join(", "));
				
				if (msg.address == "/mappInect/canal2") {
					despachaGeral(2);
				}
				if (msg.address == "/mappInect/canal6") {
					despachaGeral(6);
				}
				if (msg.address == "/mappInect/canal9") {
					despachaGeral(9);
				}
			
			}
			
			
			
			
		}
	}
}