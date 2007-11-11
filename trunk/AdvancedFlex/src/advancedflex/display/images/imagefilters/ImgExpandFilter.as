package advancedflex.display.images.imagefilters {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import advancedflex.display.images.ImageBufferManager;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.display.BlendMode;

	public class ImgExpandFilter implements IImageFilter {
		
		private static const dilate:BlurFilter = new BlurFilter( 4, 4, 3 );
		
		public function generateFilterRect(sourceBitmapData:BitmapData):Rectangle {
			return sourceBitmapData.rect;
		}
		
		public function apply(
			inputBitmapData:BitmapData, 
			outputBitmapData:BitmapData, 
			sourceRect:Rectangle, 
			destPoint:Point):void 
		{
			var tmp:BitmapData = ImageBufferManager.offerBuffer(inputBitmapData.width, inputBitmapData.height);
			tmp.applyFilter(inputBitmapData, sourceRect, destPoint, dilate);
			tmp.threshold( tmp, sourceRect, destPoint, ">", 0x000000C0, 0xFFFFFFFF, 0x000000FF );
			if(inputBitmapData != outputBitmapData) {
				outputBitmapData.copyPixels(inputBitmapData, sourceRect, destPoint);
			}
			outputBitmapData.draw(tmp, null, null,  BlendMode.ADD);
		}
		
		public function clone():IImageFilter {
			return new ImgExpandFilter();
		}
		
	}
}