package etc 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Blood2 extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.BLOOD2, 200, 200);
		
		public function Blood2 (_x:int = 0, _y:int = 0, _flipped:Boolean = false) 
		{
			x = _x + Math.random() * 40 - 20;
			y = _y + Math.random() * 80 - 40;
			this.layer = -y - 100;
			graphic = image;
			image.centerOrigin();
			image.scale = 0.6;
			image.smooth = true;
			image.add("play", [[0], [1], [2], [3], [4], [5], [6]], 20, false);
			image.play("play");
			_flipped? image.flipped = false:image.flipped = true;
		}
		
		override public function update():void
		{
			super.update();
			if (image.complete) FP.world.remove(this);
		}
		
	}

}