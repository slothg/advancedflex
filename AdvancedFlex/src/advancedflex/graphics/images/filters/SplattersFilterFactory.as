////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2007 Advanced Flex Project http://code.google.com/p/advancedflex/. 
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package advancedflex.graphics.images.filters {
	
	import advancedflex.graphics.images.ImageBufferManager;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.errors.IllegalOperationError;
	import flash.filters.BitmapFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;

	/**
	 * 扩散滤镜工厂。
	 * <p><strong>它是AFGL(Advanced Flex Graphics Library)的一部分。</strong></p>
	 */
	public class SplattersFilterFactory implements IBitmapFilterFactory {
		
		/* Min BitmapData Width */
		private var $bitmapDataWidth:int;
		/* Min BitmapData Height */
		private var $bitmapDataHeight:int;
		/* Random Seed */
		private var $randomSeed:int;
		
		/**
		 * x 方向的强度。
		 */
		public var levelX:int;
		
		/**
		 * y 方向的强度。
		 */
		public var levelY:int;
		
		/**
		 * 图像的宽度，被运用的滤镜的大小必须<strong>小于等于</strong>该大小。
		 */
		public function get bitmapDataWidth():int {
			return $bitmapDataWidth;
		}
		public function set bitmapDataWidth(v:int):void {
			$bitmapDataWidth = v;
			$bitmapChanged = true;
		}
		
		/**
		 * 图像的高度，被运用的滤镜的大小必须<strong>小于等于</strong>该大小。
		 */
		public function get bitmapDataHeight():int {
			return $bitmapDataHeight;
		}
		public function set bitmapDataHeight(v:int):void {
			$bitmapDataHeight = v;
			$bitmapChanged = true;
		}
		/* If BitmapData Buffer need to change. */
		private var $bitmapChanged:Boolean = true;
		/* BitmapData Buffer. */
		private var $bitmapData:BitmapData;
		/* If this instance doesn't disposed. */
		private var $alive:Boolean = true;
		
		
		/**
		 * 创建一个 SplattersFilterFactory。
		 * @param bitmapDataWidth 
		 * 		图像的宽度，被运用的滤镜的大小必须<strong>小于等于</strong>该大小。
		 * @param bitmapDataHeight 
		 * 		图像的高度，被运用的滤镜的大小必须<strong>小于等于</strong>该大小。
		 * @param levelX x 方向的强度。
		 * @param levelY y 方向的强度。
		 * @param randomSeed 随机种子。
		 */
		public function SplattersFilterFactory(
			bitmapDataWidth:int, 
			bitmapDataHeight:int, 
			levelX:int, 
			levelY:int,
			randomSeed:int) 
		{
			$bitmapDataWidth = bitmapDataWidth;
			$bitmapDataHeight = bitmapDataHeight;
			$randomSeed = randomSeed;
			this.levelX = levelX;
			this.levelY = levelY;
		}
		
		/**
		 * 创建滤镜。
		 * @return 滤镜。
		 */
		public function create():BitmapFilter {
			if($alive) {
				if($bitmapChanged) {
					if($bitmapData) {
						ImageBufferManager.recycle($bitmapData);
					}
					var buf:BitmapData = ImageBufferManager.offerBuffer(
						$bitmapDataWidth, 
						$bitmapDataHeight
					);
					buf.noise($randomSeed, 0, 255, 3);
					$bitmapData = buf;
					$bitmapChanged = false;
				}
				return new DisplacementMapFilter(
					$bitmapData, 
					POINT_ZERO, 
					BitmapDataChannel.RED, 
					BitmapDataChannel.GREEN, 
					levelX, 
					levelY, 
					DisplacementMapFilterMode.IGNORE
				);
			}
			throw new IllegalOperationError("This FilterFactory is Disposed.");
		}
		
		/**
		 * 释放滤镜工厂占用的大内存。
		 * 对 BitmapFilterFactory 调用 dispose() 方法时，
		 * 对此 BitmapFilterFactory 实例的方法或属性的所有后续调用都将失败，并引发异常。
		 */
		public function dispose():void {
			ImageBufferManager.recycle($bitmapData);
			$bitmapData = null;
			$alive = false;
		}
		
		/**
		 * 返回 ClothFilterFactory 对象，
		 * 它是与原始 ClothFilterFactory 对象完全相同的副本。
		 * @return ClothFilterFactory 对象。
		 */
		public function clone():IBitmapFilterFactory {
			return new ClothFilterFactory(
				$bitmapDataWidth, 
				$bitmapDataHeight, 
				levelX, 
				levelY,
				$randomSeed
			);
		}
	}
}