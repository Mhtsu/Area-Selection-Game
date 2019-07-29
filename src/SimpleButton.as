package  
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.MouseCursor;
	/**
	 * ...
	 * @author mhtsu
	 */
	public class SimpleButton extends Sprite
	{
		public var button:Bitmap = new Bitmap;	//画像
		public var text:TextField = new TextField;
		public var type:uint = new uint;	//1 = テキスト, 2 = 画像
		private var h:Number = new Number;
		private var w:Number = new Number;
		private var t:String = new String;
		private var m:Boolean = false;	//マウスの状態
		private var id:int = new int;
		
		
		public function SimpleButton(WIDTH:Number, HEIGHT:Number, TYPE:uint, ID:int, TEXT:String = "")
		{
			
			type = TYPE;
			
			h = HEIGHT;
			w = WIDTH;
			t = TEXT;
			id = ID;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			this.addEventListener(MouseEvent.CLICK, click);
		}
		
		public function init():void {
			this.width = w;
			this.height = h;
			this.buttonMode = true;
			text.selectable = false;
			button.width = w;
			button.height = h;
			button.smoothing = true;
			
			text.width = w;
			text.height = h;
			text.text = t;
			
			
			this.scaleX = 1;
			this.scaleY = 1;
			
			if (type == 1) {	//テキストボタン
				text.visible = true;
				button.visible = false;
			}else if (type == 2) {	//画像ボタン
				text.visible = false;
				button.visible = true;
			}
			
			this.addChild(button);
			this.addChild(text);
		}
		
		private function mouseOver(e:MouseEvent):void {	//マウスオーバーイベント
			this.scaleX = 1.5;
			this.scaleY = 1.5;
			this.x -= (1.5 * w - w) / 2;
			this.y -= (1.5 * h - h) / 2;
		}
		
		private function mouseOut(e:MouseEvent):void {	//マウスアウトイベント
			this.scaleX = 1;
			this.scaleY = 1;
			this.x += (1.5 * w - w) / 2;
			this.y += (1.5 * h - h) / 2;
		}
		
		private function mouseDown(e:MouseEvent):void {
			/*
			this.scaleX = 1;
			this.scaleY = 1;
			this.x += (1.5 * w - w) / 2;
			this.y += (1.5 * h - h) / 2;
			*/
		}
		
		private function mouseUp(e:MouseEvent):void {
			/*
			this.scaleX = 1;
			this.scaleY = 1;
			this.x -= (1.5 * w - w) / 2;
			this.y -= (1.5 * h - h) / 2;
			*/
		}
		
		private function click(e:MouseEvent):void {
			if (id >= 0){
				SelStage.sel = id;
			}
		}
	}

}