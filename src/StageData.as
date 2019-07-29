package  
{
	/**
	 * ...
	 * @author mhtsu
	 */
	public class StageData 	//サブステージのランプ状態など
	{
		public static var subStages:Array = [2, 3, 3];	//各ステージのサブステージ数
		public static var lampF:Array = [[[false, true], [true, false]],	//各サブステージのランプの状態
		[[false, false, true, true], [true, false, false, true], [false, true, false, true]],
		[[false, false, true], [true, false, false], [false, true, false]]];
	}

}