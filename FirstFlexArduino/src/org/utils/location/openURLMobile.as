package utils.location {
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 
	 */
	public function openURLMobile(request:*, window:String = "_blank"):void {
		var r:* = request;

		if(r is String) {
			r = new URLRequest(r);
		} else if(!(r is URLRequest)) {
			throw new Error("request");
		}

	

		navigateToURL(r, window);
	}
}
