package etc 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Flash extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.FLASH, 200, 200);
		
		public function Flash(_x:int = 0, _y:int = 0, _id:int = 0) 
		{
			x = _x;
			y = _y;
			this.layer = -y - 100;
			
			graphic = image;
			image.frame = _id;
			image.centerOrigin();
			image.scale = 0.8;
			image.smooth = true;
			image.blend = "add";
			
			if (_id == 1) 
			{
				image.scale = 0;
				image.blend = "add";
			}
		}
		
		override public function update():void
		{
			super.update();
			switch(image.frame)
			{
				case 0:
					image.alpha > 0? image.alpha -= 0.5:FP.world.remove(this);
				break;
				case 1:
					image.scale < 0.6? image.scale += 0.2:FP.world.remove(this);
				break;
			}
		}
		
	}

}