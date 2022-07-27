package items 
{
	import etc.Bullet;
	import etc.Explode;
	import etc.Explosion;
	import etc.GFX;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Grenade extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.GRENADE, 100, 100);
		private var target:Point = new Point();
		
		private var flipped:int = 0;
		
		private var moved:Number = 0;
		private var stopSin:Boolean = false;
		private var distance:Number = 0;
		
		private var speed:Number = 10;
		private var amplit:Number = 100;
		private var dx:Number = 2;
		
		private var damage:int = 50;
		
		public function Grenade(_x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y - 20;
			
			addGraphic(image);
			image.add("ready", [[1], [2], [3], [4]], 4, false);
			image.centerOrigin();
			image.y = 20;
		}
		
		override public function added():void
		{
			target.x = FP.world.mouseX;
			target.y = FP.world.mouseY;
			
			if (target.y < 150) target.y = 150;
			if (target.y > 450) target.y = 450;
			
			target.x > x? flipped = -1: flipped = 1;
			
		}
		
		override public function update():void
		{
			super.update();
			
			if ((x == target.x) && (y == target.y))
			{
				image.play("ready");
				if (image.frame == 4)
				{
					FP.world.remove(this);
					FP.world.add(new Explode(x, y, damage));
					FP.world.add(new Explosion(x, y, "explos"));
				}
				if (image.y > 20) 
				{
					image.y -= 20;
				}
				
				if (image.y < 20) 
				{
					image.y += 20;
				}
				else
				{
					image.y = 20;
				}
			}
			else
			{
				moveTowards(target.x, target.y, speed);
				image.angle += 15 * flipped;
				
				distance = distanceToPoint(target.x, target.y);
				
				var Dy:int = -Math.sin(amplit / dx) * 50 * dx;
				if (Dy > 0) 
				{
					Dy = 0;
					amplit = 0;
					dx -= 0.4;
					if (distance < 150) dx = 0;
				}
				amplit > 200? amplit = 0: amplit = amplit + 0.3;
				image.y = Dy + 20;
			}
		}
		
	}

}