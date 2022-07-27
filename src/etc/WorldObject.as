package etc 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Darksider
	 */
	public class WorldObject extends Entity
	{
		private var timer:int = 0;
		private static var risen:Spritemap = new Spritemap(GFX.SHADOW, 100, 100);
		public function WorldObject(_x:int = 0, _y:int = 0, _id:String = "risen") 
		{
			x = _x;
			y = _y;
			
			risen.smooth = true;
			risen.centerOrigin();
			risen.frame = 1;
			
			if (_id == "risen") 
			{
				graphic = risen;
				risen.y = 20;
				this.layer = -y-10;
			}
		}
		
		override public function update():void
		{
			super.update();
			if (graphic == risen) timer > 60? FP.world.remove(this):timer ++;
		}
		
	}

}