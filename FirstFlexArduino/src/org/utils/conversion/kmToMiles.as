package utils.conversion
{

	/**
	   Converts m/s to miles/h.

	   @param vel: Velocity in m/s.
	   @return Returns the velocity in miles/h.
	 */
	public function kmToMiles(km:Number):Number
	{
		var miles:Number = km/1.609;
		
		return miles;
	}
}