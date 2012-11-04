package utils.bitmap {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.display.PixelSnapping;
	
	public final class resizeBitmap {
		
		/**
		 * Specifies that the image be visible in the specified area without distortion while maintaining the original aspect ratio of it.
		 */
		public static const SHOW_ALL:String = "showAll";
		
		/**
		 * Specifies that the image be visible in the specified area without distortion but possibly with some cropping, while maintaining the original aspect ratio of the application.
		 */
		public static const NO_BORDER:String = "noBorder";
		
		/**
		 * Specifies that the image be visible in the specified area without trying to preserve the original aspect ratio.
		 */
		public static const EXACT_FIT:String = "exactFit";
		
		
		public static function resize(image_:Bitmap, width_:int, height_:int, type_:String = resizeBitmap.EXACT_FIT):Bitmap {
			var outBitmap:Bitmap;
			
			var bitmapData:BitmapData = new BitmapData(image_.width, image_.height, false);
			bitmapData.draw(image_);
			switch (type_ ) {
				case EXACT_FIT:
					bitmapData = resizeBitmapData(bitmapData, width_, height_);
					outBitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
					break;
				case SHOW_ALL:
					if ((image_.width < 2) || (image_.height < 2)) {
						return null;
					}
					if ((image_.width <= width_) && (image_.height <= height_)) {
						outBitmap = image_;
					} else {
						var propToHeight:Number = height_ / image_.height;
						var propToWidth:Number = width_ / image_.width;
						var beW:int;
						var beH:int;
						
						if (propToWidth  > propToHeight) {
							beW = image_.width * propToHeight;
							beH = image_.height * propToHeight;
						} else {
							beW = image_.width * propToWidth;
							beH = image_.height * propToWidth;
						}
						bitmapData = resizeBitmapData(bitmapData, beW, beH);
						outBitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
					}
					break;
				case NO_BORDER:
					var nbpropToHeight:Number = height_ / image_.height;
					var nbpropToWidth:Number = width_ / image_.width;
					var nbbeW:int;
					var nbbeH:int;
					
					if (nbpropToWidth  < nbpropToHeight) {
						nbbeW = image_.width * nbpropToHeight;
						nbbeH = image_.height * nbpropToHeight;
					} else {
						nbbeW = image_.width * nbpropToWidth;
						nbbeH = image_.height * nbpropToWidth;
					}
					bitmapData = resizeBitmapData(bitmapData, nbbeW, nbbeH);
					outBitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
					break;
			}
			return outBitmap;
		}
		
		private static function resizeBitmapData(bmpSource:BitmapData, setWidth:Number, setHeight:Number):BitmapData {
			var scaleWidth:Number = setWidth / bmpSource.width;
			var scaleHeight:Number = setHeight / bmpSource.height;
			var bmp:BitmapData = new BitmapData (setWidth, setHeight, true, 0);
			var matrix:Matrix = new Matrix ();
			matrix.scale(scaleWidth, scaleHeight);
			bmp.draw(bmpSource, matrix);
			return bmp;
		}
		
	}
	
}