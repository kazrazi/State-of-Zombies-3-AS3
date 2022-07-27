package etc 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import ui.GameStatusBar;
	import ui.GameUI;
	import units.Player;
	/**
	 * ...
	 * @author Darksider
	 */
	public class HeliWave extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.HELIWAVE, 200, 200);
		public function HeliWave(_x:int = 0, _y:int=0) 
		{
			x = _x;
			y = _y;
			addGraphic(image);
			image.centerOrigin();
			image.scale = 0.3;
			image.smooth = true;
		}
		
		override public function update():void
		{
			super.update();
			
			image.scale += 0.1
			if (image.scale >= 1.5)
			{
				image.alpha -= 0.2;
			}
			
			if (image.alpha <= 0)
			{
				FP.world.remove(this);
			}
		}
		
		private function destroy():void
		{
			FP.world.remove(this);
		}
	}

}