package utils.geolocation
{
	
	
	public function improveSpeed(_speed:Number):Number
	{
		if(_speed < 0){
			_speed = 0;
		}else if(_speed > 1 && _speed < 3){
			//_speed +=1;
		}else if(_speed >= 3 && _speed < 15){
			
		}else if(_speed >= 15 && _speed < 40){
			//_speed +=3;
		}else if(_speed >= 40 && _speed < 80){
			//_speed +=4;
		}else if(_speed >= 80 && _speed < 120){
			//_speed +=5;
		}else if(_speed >= 120 && _speed < 160){
			//_speed +=6;
		}else if(_speed >= 160){
			//_speed +=7;
		};
		
		return _speed;
	}
}