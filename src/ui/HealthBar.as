package ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import etc.GFX;
	import units.Player;
	/**
	 * ...
	 * @author Darksider
	 */
	public class HealthBar extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.HEALTHBAR, 202, 40);
		private var image2:Spritemap = new Spritemap(GFX.HEALTHBAR, 202, 40);
		
		public function HealthBar(_x:int = 0, _y:int = 0) 
		{
			this.layer = -1900;
			x = _x;
			y = _y;
			addGraphic(image);
			addGraphic(image2);
			image2.frame = 1;
			image.scrollX = image.scrollY = image2.scrollY = image2.scrollX = 0;
		}
		
		override public function update():void
		{
			super.update();
			image2.scaleX = Player.currentHealth / Player.totalHealth;
		}
		
	}

}