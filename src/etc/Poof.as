package etc 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Poof extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.POOF, 200, 200);
		
		public function Poof(_x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y;
			this.layer = -y - 100;
			graphic = image;
			image.centerOrigin();
			image.scale = 0.4;
			image.smooth = true;
			image.add("play", [[0], [0], [1], [2], [3], [3]], 20, false);
			image.play("play");
		}
		
		override public function update():void
		{
			super.update();
			image.scale < 0.8? image.scale += 0.05: image.scale = 0.8;
			if (image.complete) FP.world.remove(this);
		}
		
	}

}