package menu 
{
	import adobe.utils.CustomActions;
	import etc.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Darksider
	 */
	public class WeapSlider extends Entity
	{
		private var back:Spritemap = new Spritemap(GFX.MENUSLIDER, 510, 50);
		private var slider:Spritemap = new Spritemap(GFX.MENUSLIDER, 65, 50);
		private var startX:int = 0;
		public static var delta:Number = 0;
		
		public function WeapSlider(_x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y;
			startX = x;
			
			setHitbox(35, 30, -15, -10);
			back.smooth = true;
			slider.smooth = true;
			slider.frame = 8;
			
			addGraphic(back);
			addGraphic(slider);
			
		}
		
		override public function added():void
		{
			back.alpha = slider.alpha = 0;
		}
		
		override public function update():void
		{
			super.update();
			action();
			if (x < startX) x = startX;
			if (x > 588) x = 588;
			setWeapPos();
			back.x = startX - x - 35;
			
			back.alpha = slider.alpha;
			if (GameMenu.menuPanelReady)
			{
				slider.alpha < 1? slider.alpha += 0.2:slider.alpha = 1;
			}
		}
		
		private function action():void
		{
			if (collide("cursor", x, y))
			{
				slider.scaleY = 0.9;
				slider.y = 3;
				if (Input.mouseDown)
				{
					x = Input.mouseX - 35;
				}
			}
			else
			{
				slider.scaleY = 0.7;
				slider.y = 8.5;
			}
		}
		
		private function setWeapPos():void
		{
			for (var i:int = 0; i < GameMenu.weaponsArray.length; i++)
			{
				var fn:Number = (((GameMenu.weaponsArray.length) * 150 * (x - startX)) / 420);
				GameMenu.weaponsArray[i].x = (250 + i * 150) - fn;
			}
		}
		
	}

}