package utils.geolocation
{
	import utils.math.roundToDecimal;
	import utils.conversion.kmToMiles;
	import utils.conversion.msToKmh;
	import utils.conversion.msToMih;
	
	public function calculateAverageVelocity(time:Number, distance:Number, measure:String = "km/h"):Number{
		var vel:Number = (distance*1000)/time;
		if(measure == "km/h")vel = roundToDecimal(msToKmh(vel));
		if(measure == "miles/h")vel = roundToDecimal(msToMih(vel));
		if(measure == "m/s")vel = roundToDecimal(vel);
		
		return vel;
		
	}
}