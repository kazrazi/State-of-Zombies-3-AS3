package items 
{
	import etc.Bullet;
	import etc.Explode;
	import etc.Explosion;
	import etc.GFX;
	import etc.SFX;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import units.Player;
	import units.Zombie;
	import units.ZombieBoss;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Droid extends Entity
	{
		private var droid:Spritemap = new Spritemap(GFX.DROID, 200, 100);
		private var shadow:Spritemap = new Spritemap(GFX.SHADOW, 100, 100);
		private var healthBar:Spritemap = new Spritemap(GFX.POWERBAR, 82, 16);
		private var healthBarBg:Spritemap = new Spritemap(GFX.POWERBAR, 82, 16);
		public var health:int = 1000;
		private var totalHealth:int = 0;
		
		private var isFlipped:Boolean = true;
		
		private var fireSpeed:int = 5;
		private var fireTimer:int = 0;
		private var damage:int = 20;
		
		private var randPos:Point = new Point(0, 0);
		private var prewPos:Point = new Point(0, 0);
		private var randTimer:int = 0;
		
		private var bulletAngle:int = 0;
		private var target:Point = new Point(0, 0);
		
		private var ready:Boolean = false;
		private var fireSfx:Sfx = new Sfx(SFX.plasma);
		
		public function Droid(_x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y - 80;
			
			addGraphic(shadow);
			addGraphic(droid);
			
			droid.centerOrigin();
			droid.smooth = true;
			droid.add("fire", [[1], [2], [3], [0]], 30, false);
			
			shadow.centerOrigin();
			shadow.smooth = true;
			shadow.scale = 0.8;
			shadow.alpha = 0.4;
			shadow.y = 100;
			
			setHitbox(800, 400, 400, 200);
			
			target.x = x;
			target.y = y;
			
			droid.y = 100;
		}
		
		override public function added():void
		{
			addGraphic(healthBarBg);
			addGraphic(healthBar);
			healthBar.frame = 1;
			healthBar.smooth = true;
			healthBarBg.smooth = true;
			healthBar.y = -50;
			healthBarBg.y = -50;
			healthBar.x = -40;
			healthBarBg.x = -40;
			healthBarBg.blend = "overlay";
			totalHealth = health;
		}
		
		override public function update():void
		{
			super.update();
			this.layer = -y - 100;
			
			health > 0? health -= 1: destroy();
			healthBar.scaleX = health / totalHealth;
			
			if (ready)
			{
				findTarget();
				control();
				animation();
			}
			else
			{
				droid.y > 0? droid.y -= 4:ready = true;
			}
		}
		
		private function destroy():void
		{
			FP.world.remove(this);
			FP.world.add(new Explosion(x, y+100, "explos"));
			FP.world.add(new Explode(x, y+100, damage));
		}
		
		private function findTarget():void
		{
			var zombBoss:ZombieBoss = collide("zombie", x, y) as ZombieBoss
			if (zombBoss)
			{
				target.x = zombBoss.x;
				target.y = zombBoss.y;
				
				if (fireTimer > fireSpeed)
				{
					openFire();
				}
				
				zombBoss.x > x? isFlipped  = true:isFlipped = false;
			}
			
			var zomb:Zombie = collide("zombie", x, y) as Zombie
			if (zomb)
			{
				target.x = zomb.x;
				target.y = zomb.y;
				
				if (fireTimer > fireSpeed)
				{
					openFire();
				}
				
				zomb.x > x? isFlipped  = true:isFlipped = false;
			}
			
			fireTimer++;
		}
		
		private function openFire():void
		{
			droid.play("fire", true);
			fireTimer = 0;
			bulletAngle = -int(Math.atan2(target.y - y + 20, target.x - x + 20) * 180 / Math.PI);
			FP.world.add(new Bullet(x, y, bulletAngle, damage, "plasma"));
			
			fireSfx = new Sfx(SFX.plasma);
			fireSfx.play(Settings.sound * 0.1);
		}
		
		private function animation():void
		{
			if (isFlipped)
			{
				droid.flipped = false;
			}
			else
			{
				droid.flipped = true;
			}
		}
		
		private function control():void
		{
			moveTowards(Player.pos.x + randPos.x, Player.pos.y + randPos.y - 100, 3);
			
			if (y < 60) y = 60;
			if (y > 360) y = 360;
			
			randTimer > 0? randTimer--:randTimer = 0;
			if (randTimer == 0)
			{
				randTimer = 200;
				randPos.x = int(Math.random() * 200 - 100);
				randPos.y = int(Math.random() * 200 - 100);
			}
		}
		
	}

}