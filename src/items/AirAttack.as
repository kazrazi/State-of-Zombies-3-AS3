package items 
{
	import etc.Bullet;
	import etc.Explode;
	import etc.Explosion;
	import etc.GFX;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Darksider
	 */
	public class AirAttack extends Entity
	{
		private var bombArray:Array = [];
		private var timer:int = 0;
		private var count:int = 0;
		private var damage:int = 50;
		public function AirAttack(_x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y;
		}
		
		override public function added():void
		{
			for (var i:int = 0; i < 10; i++)
			{
				bombArray[i] = [];
				var time:int = i * 10;
				var bombImage:Spritemap = new Spritemap(GFX.BOMB, 200, 100);
				var bomb:Entity = new Entity(FP.camera.x, -100, bombImage);
				bombImage.centerOrigin();
				bombImage.scale = 0.6;
				bombImage.smooth = true;
				
				var bombTimer:int = Math.random() * 50;
				var target:Point = new Point();
				target.x = int(x + (Math.random() * 9) * 100 - 400);
				target.y = int(y + (Math.random() * 5) * 100 - 200);
				bomb.x = target.x - 300;
				if (target.y < 170) target.y = 170;
				if (target.y > 400) target.y = 400;
				bombImage.angle = -int(Math.atan2(target.y - bomb.y, target.x - bomb.x) * 180 / Math.PI);
				bombArray[i].push(bomb);
				bombArray[i].push(target);
				bombArray[i].push(time);
				
				FP.world.add(bombArray[i][0]);
				count++;
			}
		}
		
		override public function update():void
		{
			super.update();
			timer++;
			
			for (var i:int = 0; i < bombArray.length; i++)
			{
				if (timer > bombArray[i][2])
				{
					bombArray[i][0].layer = -bombArray[i][1].y;
					bombArray[i][0].moveTowards(int(bombArray[i][1].x), int(bombArray[i][1].y), 30)
					if ((int(bombArray[i][0].x) == int(bombArray[i][1].x)) && (int(bombArray[i][0].y) == int(bombArray[i][1].y)))
					{
						FP.world.remove(bombArray[i][0]);
						FP.world.add(new Explosion(bombArray[i][0].x, bombArray[i][0].y, "explos"));
						FP.world.add(new Explode(bombArray[i][0].x, bombArray[i][0].y, damage));
						
						bombArray.splice(i, 1);
						count--;
					}
				}
			}
			
			if (count <= 0) FP.world.remove(this);
		}
		
	}

}