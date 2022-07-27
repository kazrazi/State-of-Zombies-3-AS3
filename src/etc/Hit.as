package etc 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Hit extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.HIT, 100, 100);
		
		public function Hit(_x:int = 0, _y:int = 0, _angle:int = 0) 
		{
			x = _x + Math.random() * 80 - 40;
			y = _y + Math.random() * 80 - 40;
			this.layer = -y - 100;
			graphic = image;
			image.centerOrigin();
			image.scale = 1;
			image.smooth = true;
			image.add("play", [[0], [1], [2], [3], [4], [5]], 30, false);
			image.play("play");
			image.angle = _angle;
		}
		
		override public function update():void
		{
			super.update();
			if (image.complete) FP.world.remove(this);
		}
		
	}

}