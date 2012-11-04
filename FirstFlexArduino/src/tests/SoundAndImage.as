package tests
{
    import com.greensock.*;
    import com.greensock.easing.*;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;
    import flash.utils.Dictionary;
    
    import org.osflash.signals.Signal;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.extensions.PDParticleSystem;
    import starling.extensions.ParticleSystem;
    import starling.textures.RenderTexture;
    import starling.textures.Texture;
    import starling.utils.deg2rad;
    
    public class SoundAndImage extends Sprite
    {
		public var keyboardSignal:Signal = new Signal(int);
		
		private var tuSom:TuSom = new TuSom();
		private var tchiSom:TchiSom = new TchiSom();
		private var piiSom:PiiSom = new PiiSom();
		private var silencioSound:Sound = new Sound();
		private var soundsArray:Vector.<Sound> = new <Sound> [silencioSound, tuSom, tchiSom, piiSom];
				
		[Embed(source="assets/batidasImagens/silencio.jpg")]
		protected static const SilencioImagem:Class;
		private var silencioImagemBMP:Bitmap = new SilencioImagem();
		private var silencioImagemTexture:Texture;
		private var silencioImagemImage:Image;
		
		[Embed(source="assets/batidasImagens/tu.jpg")]
		protected static const TuImagem:Class;
		private var tuImagemBMP:Bitmap = new TuImagem();
		private var tuImagemTexture:Texture;
		private var tuImagemImage:Image;
		
		[Embed(source="assets/batidasImagens/tchi.jpg")]
		protected static const TchiImagem:Class;
		private var tchiImagemBMP:Bitmap = new TchiImagem();
		private var tchiImagemTexture:Texture;
		private var tchiImagemImage:Image;
		
		[Embed(source="assets/batidasImagens/pii.jpg")]
		protected static const PiiImagem:Class;
		private var piiImagemBMP:Bitmap = new PiiImagem();
		private var piiImagemTexture:Texture;
		private var piiImagemImage:Image;
			
		private var bmpsArray:Vector.<Bitmap> = new <Bitmap> [silencioImagemBMP, tuImagemBMP, tchiImagemBMP, piiImagemBMP];
		private var texturesArray:Vector.<Texture> = new <Texture> [silencioImagemTexture, tuImagemTexture, tchiImagemTexture, piiImagemTexture];
		private var imagesArray:Vector.<Image> = new <Image> [silencioImagemImage, tuImagemImage, tchiImagemImage, piiImagemImage];
		
		private var chamaSilencio : TweenLite = new TweenLite(silencioNoApp, 0, {onComplete:silencioNoApp, delay:.25});
		        
        public function SoundAndImage()
        {
          
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
		
        private function onAddedToStage(event:Event):void
        {
			for(var i:int = 0; i < bmpsArray.length; i++)
			{
				texturesArray[i] = Texture.fromBitmap(bmpsArray[i]);
				imagesArray[i] = new Image(texturesArray[i]);			
				imagesArray[i].pivotX = imagesArray[i].width >> 1; 
				imagesArray[i].pivotY = imagesArray[i].height >> 1;
				imagesArray[i].x = stage.stageWidth/2;
				imagesArray[i].y = stage.stageHeight/2;
				addChild(imagesArray[i]);
			}
			addChild(imagesArray[0]);
			
			keyboardSignal.add(showAndPlay);
        }
		
		private function showAndPlay(canal:uint):void{
			switch(canal){
				case 2:
					addChild(imagesArray[1]);
					soundsArray[1].play();
					break;
				case 6:
					addChild(imagesArray[2]);
					soundsArray[2].play();
					break;
				case 9:
					addChild(imagesArray[3]);
					soundsArray[3].play();
					break;
				//
				
			}
			chamaSilencio.kill();
			chamaSilencio = new TweenLite(silencioNoApp, 0, {onComplete:silencioNoApp, delay:.32});
		}
		
		private function silencioNoApp():void{
			addChild(imagesArray[0]);
		}
		
        private function onRemovedFromStage(event:Event):void
        {
            
        }
        
		public static function get current():SoundAndImage {
			if (Starling.current == null || Starling.current.stage == null ||
				Starling.current.stage.numChildren == 0) return null;
			return Starling.current.stage.getChildAt(0) as SoundAndImage;
		}
		
    }
}