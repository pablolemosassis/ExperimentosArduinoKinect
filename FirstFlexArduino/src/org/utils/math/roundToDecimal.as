package utils.math
{

	/**
	   rounds a number to especif number of decimals
	 */
	public function roundToDecimal(number:Number, decimals:int = 2):Number
	{
		var zeros:int = Math.pow(10, decimals)
		
		var rounded:Number = int((number)*zeros)/zeros;
		
		return rounded;
	}
}