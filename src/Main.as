
package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GraphicsGradientFill;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author mhtsu
	 */
	public class Main extends Sprite 
	{
		private var game:int = 0; //ゲームフラグ
		/* ゲームフラグ
		 * 0 = メニュー画面
		 * 1 = ステージ選択画面
		 * 2 = ゲーム画面
		 * 3 = ポーズ ゲームクリア　ゲームオーバー
		 * 4 = サブステージ選択
		 */
		private var key:Vector.<Boolean> = new Vector.<Boolean>(255);	//キー判定
		private var debug:TextField = new TextField;	//デバッグテキスト
		private var menuText:TextField = new TextField;	//メニューテキスト
		private var menuTextF:TextFormat = new TextFormat;	//メニューテキストフォーマット
		private var startButton:SimpleButton = new SimpleButton(50, 20, 1, 0, "Start!"); //スタートボタン
		private var stages:Array = new Array;	//ステージデータ
		private var stageThumb:Array = new Array;	//ステージサムネイル
		private var stageButtons:Vector.<SimpleButton> = new Vector.<SimpleButton>;	//ステージ選択のボタン
		private var subStageButtons:Vector.<SimpleButton> = new Vector.<SimpleButton>(100, true);
		private const stageNum:int = 3;	//ステージの数
		private var playStNum:int = -1;	//現在プレイしているステージ番号
		private var playSubStNum:int = -1; //現在プレイしているサブステージ番号
		[Embed(source = "../lib/ryouiki1.png")] private static const stage0:Class;	//ステージ画像
		[Embed(source = "../lib/ryouiki1.png")] private static const stageSys0:Class;	//ステージシステム画像
		[Embed(source = "../lib/ryouiki2.png")] private static const stage1:Class;	//ステージ画像
		[Embed(source = "../lib/ryouiki2.png")] private static const stageSys1:Class;	//ステージシステム画像
		[Embed(source = "../lib/ryouiki3.png")] private static const stage2:Class;	//ステージ画像
		[Embed(source = "../lib/ryouiki3.png")] private static const stageSys2:Class;	//ステージシステム画像
		private var test:Bitmap = new Bitmap;
		private var lamps:Vector.<Lamp> = new Vector.<Lamp>(255);
		private var backButton:SimpleButton = new SimpleButton(30, 20, 1, -1, "Back");
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			stage.addEventListener(MouseEvent.CLICK, click);
			startButton.addEventListener(MouseEvent.CLICK, stButCl);
			backButton.addEventListener(MouseEvent.CLICK, backCl);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			debug.height = 50;
			debug.width = 100;
			debug.x = 0;
			debug.y = 0;
			debug.selectable = false;
			debug.visible = true;
			debug.alpha = 0.5;
			debug.textColor = 0x555555;
			
			
			
			startButton.x = 100;
			startButton.y = 100;
			
			/*
			startButton.graphics.beginFill(0x000000);
			startButton.graphics.drawRect(0, 0, 10, 10);
			startButton.graphics.endFill();
			*/
			startButton.buttonMode = true;
			menuTextF.bold = true;
			menuTextF.font = "_ゴシック";
			menuTextF.size = 18;
			startButton.text.x = 0;
			startButton.text.y = 0;
			startButton.text.width = 80;
			startButton.text.height = 20;
			startButton.text.selectable = false;
			startButton.text.textColor = 0xAAAA00;
			startButton.text.defaultTextFormat = menuTextF;
			startButton.init();
			stage.addChild(startButton);
			

			
			//ステージ画像格納
			var i:int = new int;
			stageImgSet();
			for (i = 0; i < stageNum; i++) {
				stageLoad(i);
			}
			for (i = 0; i < lamps.length; i++) {
				lamps[i] = new Lamp;
				lamps[i].visible = false;
				stage.addChild(lamps[i]);
			}
			
			//塗りつぶし判断テスト
			test = new Bitmap(stages[0].systemData);
			test.visible = false;
			stage.addChild(test);
			
			//backボタン
			backButton.x = 10;
			backButton.y = 270;
			backButton.visible = false;
			backButton.init();
			stage.addChild(backButton);
			
			
			//subStageButtons設定
			for (i = 0; i < 100; i++) {
				subStageButtons[i] = new SimpleButton(20, 20, 1, i, "" + i);
				subStageButtons[i].x = ((i % 3) * 50) + 80;
				subStageButtons[i].y = (int)(i / 3) * 50 + 80;
				subStageButtons[i].visible = false;
				subStageButtons[i].text.border = true;
				stage.addChild(subStageButtons[i]);
				subStageButtons[i].init();
			}
			
			//メニューセット
			menuSet();
			
			stage.quality = "best";
			
			stage.addChild(debug);
		}
		
		private function keyDown(e:KeyboardEvent):void
		{
			key[e.keyCode] = true;
		}
		
		private function keyUp(e:KeyboardEvent):void
		{
			key[e.keyCode] = false;
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (game == 0) {	//メニュー画面
				menuSel();	//メニューセレクト処理
			}else if (game == 1) { //ステージ選択
				selStage();
			}else if (game == 2) { //ゲーム画面
				gameRun();	//ゲーム処理
			}else if (game == 3) { //クリア画面
				debug.text = "clear!";
			}else if (game == 4) {	//サブステージ選択(仮)
				selSubStage();
			}
		}
		
		private function menuSet():void {	//メニューセット
		
			
		}
		
		private function menuSel():void {	//メニュー中の処理
		
			debug.text = "メニュー画面";
		}
		
		private function resetMenu(GAME:int):void {	//メニュー片付け
			//メニュー終了処理
			startButton.visible = false;
			game = GAME;
		}
		
		private function stButCl(e:MouseEvent):void	{	//ステージ選択への切り替え
			//ステージセレクトへ
			resetMenu(1);
			selStageSet();
		}
		
		private function selStageSet():void {	//ステージ選択画面への初期処理
			var i:int = new int;
			for (i = 0; i < stageNum; i++) {	//ステージのボタンを表示
				stageButtons[i].visible = true;
			}
			SelStage.sel = -1;
			game = 1;
		}
		
		private function selStage():void {	//ステージ選択画面中の処理
			debug.text = "ステージ選択";
			
			if (SelStage.sel != -1) {	//選択されたら
				resetSelStage(4);	//ステージ選択片付け
				playStNum = SelStage.sel;	//ステージ番号格納
				selSubStageSet();	//サブステージ選択のセット
				SelStage.sel = -1;
			}
		}
		
		private function resetSelStage(GAME:int):void {	//ステージ選択片付け
			var i:int = 0;
			for (i = 0; i < stageNum; i++) {
				stageButtons[i].visible = false;
			}
			game = GAME;
		}
		
		private function selSubStageSet():void {	//サブステージ選択画面への初期処理
			var i:int = new int;
			for (i = 0; i < StageData.subStages[playStNum]; i++) {
				subStageButtons[i].visible = true;
			}
			game = 4;
			backButton.visible = true;	//バックボタン表示
		}
		
		private function selSubStage():void {
			debug.text = "サブステージ選択";
			
			if (SelStage.sel != -1) {
				resetSelSubStage();
				playSubStNum = SelStage.sel;
				gameRunSet(playStNum);	//ゲーム画面セットへ
				SelStage.sel = -1;
			}
		}
		
		private function resetSelSubStage():void {	//サブステージ選択画面片付け
			var i:int = new int;
			for (i = 0; i < StageData.subStages[playStNum]; i++) {
				subStageButtons[i].visible = false;
			}
			backButton.visible = false;	//backボタン片付け
		}
		
		private function stageImgSet():void { 	//ステージ画像格納処理	およびステージボタン作成
			var i:int = new int
			var t:int = 1;
			for (i = 0; i < stageNum; i++) {
				stageThumb[i] = new Main["stage" + i];
				
				stageButtons[i] = new SimpleButton(50, 50, 2, i);	//大きさはとりあえず50x50
				stageButtons[i].button = stageThumb[i];
				stageButtons[i].x = (80 * i + 80) % 400;
				if (80 * i + 80 > t * 400) {	//一段下に
					t++;
				}
				stageButtons[i].y = 80 * t;
				stageButtons[i].visible = false;
				stageButtons[i].init();
				stage.addChild(stageButtons[i]);
				
				stages[i] = new StageSet;
				stages[i].stageImage = new Main["stage" + i];
				stages[i].stageImage.visible = false;
				stages[i].stageSysImage = new Main["stageSys" + i];
				stage.addChild(stages[i].stageImage);
				
				stages[i].systemData.draw(stages[i].stageSysImage);	//システムデータにコピー
			}
		}
		
		private function stageLoad(n:int):void {	//画像からステージデータ読み込み、StageSet全般作
			var i:int = new int;
			var j:int = new int;
			var color:int = new uint;
			
			//systemData作成
			var x:int = new int;
			var y:int = new int;
			var w:int = stages[n].stageImage.width;
			var h:int = stages[n].stageImage.height;
			var fillcolor:uint = 0x000001;
			
			for (x = 0; x < w; x++) {	//横列
				for (y = 0; y < h; y++) {	//縦列
					if (stages[n].systemData.getPixel(x, y) == 0xFFFFFF) {	//白の領域があったら
						fill(n, x, y, fillcolor);	//塗潰す
						stages[n].colorNum[fillcolor] = new Array;
						fillcolor += 1;	//色を変える
					}else if (stages[n].systemData.getPixel(x, y) == 0xFF0000) {	//赤があったら結び目追加
						stages[n].dot[stages[n].dotL] = new Point(x, y);
						stages[n].dotf[stages[n].dotL] = false;
						lamps[stages[n].dotL] 
						stages[n].dotL++;
					}
				}
			}
			
			//結び目の関係設定 結び目中心の20x20の四角の中を捜索
			for (i = 0; i < stages[n].dotL; i++) {
				x = stages[n].dot[i].x - 10;
				
				w = stages[n].dot[i].x + 10;
				h = stages[n].dot[i].y + 10;
				for (x; x < w; x++) {
					y = stages[n].dot[i].y - 10;
					for (y; y < h; y++) {
						color = stages[n].systemData.getPixel(x, y);
						if (color != 0x000000 && color < 256) {	//範囲内の色の場合
							for (j = 0; j < stages[n].colorNum[color].length; j++) {	//同じ結び目番号がないかどうか
								if (stages[n].colorNum[color][j] == i) {
									color = 0;	//フラグ代わり
									break;
								}
							}
							if (color != 0) {	//フラグ確認
								stages[n].colorNum[color].push(i);
							}
						}
					}
				}
			}
			
			
		}
		
		private function gameRunSet(n:int):void {	//ゲーム画面への準備
			var i:int = new int;
			for (i = 0; i < stages[n].dotL; i++) {	//ランプ設定
				stages[n].dotf[i] = StageData.lampF[n][playSubStNum][i];
				lamps[i].x = stages[n].dot[i].x-10;
				lamps[i].y = stages[n].dot[i].y-10;
				lamps[i].OK(stages[n].dotf[i]);
				lamps[i].visible = true;
				//大きさテスト
				lamps[i].scaleX = 0.5;
				lamps[i].scaleY = 0.5;
			}
			stages[n].stageImage.visible = true;	//ステージ画像表示
			//test.visible = true;	//システムデータ表示
			backButton.visible = true;	//バックボタン表示
			game = 2;	//ゲーム画面へ
		}
		
		private function gameRun():void {	//ゲーム画面中
			debug.text = "" + stages[playStNum].systemData.getPixel(mouseX, mouseY) + "\n" +
						 "dotf[0]=" + stages[playStNum].dotf[0] +
						 "\ndotf[1]=" + stages[playStNum].dotf[1];
			var i:int = new int;
			for (i = 0; i < stages[playStNum].dotL; i++) {
				lamps[i].OK(stages[playStNum].dotf[i]);	//ランプの状態を常に更新
			}
			
			//clear判定
			for (i = 0; i < stages[playStNum].dotL; i++) {
				if (!stages[playStNum].dotf[i]) {
					return;
				}
			}
			game = 3;
		}
		
		private function ResetGameRun(GAME:int):void {
			stages[playStNum].stageImage.visible = false;	//ステージ画像非表示
			var i:int = new int;
			for (i = 0; i < stages[playStNum].dotL; i++) {	//ランプ設定
				lamps[i].visible = false;
				stages[playStNum].dotf[i] = false;
			}
			backButton.visible = false;	//バックボタン非表示
			game = GAME;
		}
		
		private function fill(n:int, sx:int, sy:int, color:uint ):void {	//スキャンライン法で(sx, sy)から始めてcolorで塗りつぶし
			//領域裏データを作成
			
			var buffer:Array = new Array;
			buffer.push(new Point(sx, sy));
			
			var sColor:int = stages[n].systemData.getPixel(sx, sy);
			
			while (buffer.length > 0) {	//バッファーがある限り
				var point:Point = buffer.shift();
				var left:int = new int;
				var right:int = new int;
				
				//左端
				for (left = point.x; left >= 0; left--) {
					//次のピクセル違う色がみつかったら出る
					if (stages[n].systemData.getPixel(left-1, point.y) != sColor) {
						break;
					}
				}
				
				//右端
				for (right = point.x; right < stages[n].stageImage.width - 1; right++) {
					if (stages[n].systemData.getPixel(right + 1, point.y) != sColor) {
						break;
					}
				}
				
				//一行塗りつぶす
				stages[n].systemData.fillRect(new Rectangle(left, point.y, right - left, 1), color);
				
				if (point.y - 1 >= 0) {	//上の行へ
					scanLine(n, right, left, point.y - 1, sColor, buffer);
				}
				if (point.y + 1 < stages[n].stageImage.height) {	//下の行へ
					scanLine(n, right, left, point.y + 1, sColor, buffer);
				}
				
			}
		}
		
		private function scanLine(n:int, r:int, l:int, y:int, color:uint, buffer:Array):void {
			
			while (l <= r) {
				for (; l <= r; l++) {
					if (stages[n].systemData.getPixel(l, y) == color) {	//最初の色があったら
						break;
					}
				}
				
				if (l > r) {
					break;
				}
				
				for (; l <= r; l++) {
					if (stages[n].systemData.getPixel(l, y) != color) {	//ちがう色があったら
						break;
					}
				}
				
				buffer.push(new Point(l, y));
				
			}
		}
		
		private function click(e:MouseEvent):void {
			if (game == 2) {	//ゲーム画面中クリック処理
				//そのマウス位置の色で反転
				var color:uint = new uint;
				var i:int = new int;
				color = stages[playStNum].systemData.getPixel(mouseX, mouseY);
				if (color != 0 && color < 255){
					for (i = 0; i < stages[playStNum].colorNum[color].length; i++) {	//該当する色の関係した結び目を反転
						stages[playStNum].dotf[stages[playStNum].colorNum[color][i]] = !stages[playStNum].dotf[stages[playStNum].colorNum[color][i]];
					}
				}
			}else if (game == 3) {	//クリア画面中
				ResetGameRun(1);
				selStageSet();
			}
		}
		
		private function backCl(e:MouseEvent):void {	//backボタンクリック
			if (game == 2) {	//ゲーム時はサブステージ選択画面へ
				ResetGameRun(4);
				selSubStageSet();
			}else if (game == 4) {	//サブステージ選択画面の場合はステージ選択画面へ
				resetSelSubStage();
				selStageSet();
			}
		}
	}
	
}