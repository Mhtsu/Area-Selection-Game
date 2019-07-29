package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author mhtsu
	 */
	public class Lamp extends Sprite
	{
		[Embed(source = "../lib/lamp0.png")] private static const img0:Class;
		[Embed(source = "../lib/lamp1.png")] private static const img1:Class;
		private var lamp0:Bitmap = new img0;
		private var lamp1:Bitmap = new img1;
		
		public function Lamp(flag:Boolean = false )
		{
			lamp0.visible = !flag;
			lamp1.visible = flag;
			this.addChild(lamp0);
			this.addChild(lamp1);
			this.width = 40;
			this.height = 40;
		}
		
		public function OK(flag:Boolean):void {
			lamp0.visible = !flag;
			lamp1.visible = flag;
		}
		
	}

}