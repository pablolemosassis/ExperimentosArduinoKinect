package utils.conversion
{

	/**
	   Converts m/s to km/h.

	   @param vel: Velocity in m/s.
	   @return Returns the velocity in km/h.
	 */
	public function msToKmh(vel:Number):Number
	{
		var kmh:Number = (vel/1000) * 3600;
		
		return kmh;
	}
}