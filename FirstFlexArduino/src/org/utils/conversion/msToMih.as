package utils.conversion
{

	/**
	   Converts m/s to miles/h.

	   @param vel: Velocity in m/s.
	   @return Returns the velocity in miles/h.
	 */
	public function msToMih(vel:Number):Number
	{
		var mph:Number = (vel/1609) * 3600;
		
		return mph;
	}
}