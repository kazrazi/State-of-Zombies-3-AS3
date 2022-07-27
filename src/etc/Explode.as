package etc 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Explode extends Entity
	{
		private var explodeTimer:int = 0;
		private var damage:int = 0;
		public function Explode(_x:int = 0, _y:int = 0, _damage:int = 0) 
		{
			x = _x;
			y = _y;
			damage = _damage;
		}
		
		override public function update():void
		{
			super.update();
			
			explodeTimer++;
			if (explodeTimer % 1 == 0)
			{
				FP.world.add(new Bullet(x, y, 36 * explodeTimer, damage, "explos"));
				if (explodeTimer > 36) FP.world.remove(this);
			}
		}
		
	}

}