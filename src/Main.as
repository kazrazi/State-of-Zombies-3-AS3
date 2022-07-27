package
{
	import adobe.utils.ProductManager;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.*;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.display.StageAlign;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author Darksider
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Engine
	{

		[SWF(width = "720", height = "480", frameRate = "30")]
		[Embed(source = 'AGintro.swf', mimeType = 'application/octet-stream')]
		private var FlixelGameByteArray:Class;
		private var flxLoader:Loader = new Loader();
		private var container:Sprite = new Sprite();
		private var timer:int = 0;
		private var start:Boolean = false;
		
		public function Main() 
		{
			super(720, 480, 30, false);
			
			Mouse.hide();
			//FP.console.enable();
			FP.console.visible = false
		}

		override public function update():void
		{
			super.update();
			
			timer++;
			if ((timer > 150) && (!start))
			{
				start = true;
				removeChild(container);
				FP.world = new StartMenu();
			}
			
			//Fullscreen
			/*var scaleFactorX:Number = stage.stageWidth / FP.screen.width;
            var scaleFactorY:Number = stage.stageHeight / FP.screen.height;
            FP.screen.scaleX = scaleFactorX;
            FP.screen.scaleY = scaleFactorY;*/
		}
		
		override public function init():void
		{
			//FP.world = new StartMenu();
			addChild(container);
			container.addChild(flxLoader);
			flxLoader.loadBytes(new FlixelGameByteArray());
		}
		
		public override function setStageProperties(): void
        {
            //super.setStageProperties();
			//stage.align = StageAlign.BOTTOM;
			//stage.align = StageAlign.TOP;
            //stage.quality = StageQuality.BEST;
			
			stage.frameRate = 30;
			stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
        }
		
		private function onRightClick(e:MouseEvent):void 
		{
            
        } 

	}

}