package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author mhtsu
	 */
	public class StageSet 
	{
		public var systemData:BitmapData = new BitmapData(400, 300, false, 0xFFFFFF); //領域データ
		public var stageSysImage:Bitmap;	//ステージシステム画像
		public var stageImage:Bitmap;//ステージ表示画像
		public var dotL:int = 0;	//結び目の数
		public var dotf:Vector.<Boolean> = new Vector.<Boolean>(255); //結び目の状態
		public var dot:Vector.<Point> = new Vector.<Point>(255); //結び目座標
		public var colorNum:Array = new Array; //領域ごとの結び目設定(2次)s
		
		/*
		 * 例：
		 * {0}	//0x000000は使えない色なので無視
		 * {0, 1, 2}	//0x000001の関係した結び目番号
		 * {1, 2}	//0x000002の関係した結び目番号
		 * 
		 */
		
		
		public function StageSet() 
		{
			stageImage = new Bitmap;
		}
		
	}

}