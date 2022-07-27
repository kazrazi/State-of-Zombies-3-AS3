package items 
{
	import etc.Bullet;
	import etc.GFX;
	import etc.Particle;
	import etc.SFX;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import units.Player;
	import etc.Explode;
	import etc.Explosion;
	/**
	 * ...
	 * @author Darksider
	 */
	public class WalkerD extends Entity
	{
		private var turret:Spritemap = new Spritemap(GFX.WALKER, 200, 100);
		private var weapon:Spritemap = new Spritemap(GFX.WALKER, 200, 100);
		private var shadow:Spritemap = new Spritemap(GFX.SHADOW, 100, 100);
		private var muzzle:Spritemap = new Spritemap(GFX.MUZZ, 200, 200);
		private var healthBar:Spritemap = new Spritemap(GFX.POWERBAR, 82, 16);
		private var healthBarBg:Spritemap = new Spritemap(GFX.POWERBAR, 82, 16);
		public var health:int = 1000;
		private var totalHealth:int = 0;
		
		private var isFlipped:Boolean = false;
		
		private var fireSpeed:int = 5;
		private var fireTimer:int = 0;
		private var damage:int = 30;
		
		private var randPos:Point = new Point(0, 0);
		private var prewPos:Point = new Point(0, 0);
		private var randTimer:int = 0;
		
		private var fireSfx:Sfx = new Sfx(SFX.riffle_3);
		
		public function WalkerD(_x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y + 10;
			
			addGraphic(shadow);
			addGraphic(turret);
			addGraphic(weapon);
			addGraphic(muzzle);
			muzzle.add("pistol", [[0], [1], [2], [3], [0]], 40, false);
			
			weapon.centerOrigin();
			weapon.smooth = true;
			weapon.frame = 4;
			weapon.originY = 50;
			weapon.y = - 40;
			
			turret.centerOrigin();
			turret.smooth = true;
			turret.add("walk", [[1], [2], [3]], 30, true);
			
			shadow.y = 10;
			shadow.centerOrigin();
			shadow.smooth = true;
			shadow.scale = 1.2;
			shadow.alpha = 0.4;
		}
		
		override public function added():void
		{
			addGraphic(healthBarBg);
			addGraphic(healthBar);
			healthBar.frame = 1;
			healthBar.smooth = true;
			healthBarBg.smooth = true;
			healthBar.y = -70;
			healthBarBg.y = -70;
			healthBar.x = -40;
			healthBarBg.x = -40;
			healthBarBg.blend = "overlay";
			totalHealth = health;
		}
		
		override public function update():void
		{
			super.update();
			this.layer = -y;
			
			health > 0? health -= 1: destroy();
			healthBar.scaleX = health / totalHealth;
			
			animation();
			if (fireTimer < fireSpeed)
			{
				fireTimer ++;
			}
			else
			{
				openFire();
			}
			control();
			
		}
		
		private function destroy():void
		{
			FP.world.remove(this);
			FP.world.add(new Explosion(x, y, "explos"));
			FP.world.add(new Explode(x, y, damage));
		}
		
		private function openFire():void
		{
			fireTimer = 0;
			var x1:int = x + weapon.x + 40 * (Math.cos(weapon.angle *  Math.PI / 180));
			var y1:int = y + weapon.y - 30 * (Math.sin(weapon.angle *  Math.PI / 180));
			FP.world.add(new Particle(x, y - 20, isFlipped, "riffle"));
			
			var muzzleangle:int = 0;
			isFlipped? muzzleangle = weapon.angle: muzzleangle = weapon.angle + 180;
			var muzzlex:int = weapon.x + 80 * Math.cos(muzzleangle *  Math.PI / 180);
			var muzzley:int = weapon.y - 80 * Math.sin(muzzleangle *  Math.PI / 180);
			FP.world.add(new Bullet(x + muzzlex, y + muzzley, muzzleangle, damage));
			
			muzzle.centerOrigin();
			muzzle.scale = 0.5;
			muzzle.smooth = true;
			
			muzzle.angle = muzzleangle;
			muzzle.x = weapon.x + 80 * Math.cos(muzzleangle *  Math.PI / 180);
			muzzle.y = weapon.y - 80 * Math.sin(muzzleangle *  Math.PI / 180);
			muzzle.play("pistol", true);
			
			fireSfx = new Sfx(SFX.riffle_4);
			fireSfx.play(Settings.sound * 0.1);
		}
		
		private function animation():void
		{
			if (isFlipped)
			{
				weapon.angle = -int(Math.atan2(FP.world.mouseY - y+20, FP.world.mouseX - x+20) * 180 / Math.PI);
				weapon.flipped = false;
				weapon.originX = 70
			}
			else
			{
				weapon.angle = -int(Math.atan2(FP.world.mouseY - y+20, FP.world.mouseX - x+20) * 180 / Math.PI + 180);
				weapon.flipped = true;
				weapon.originX = 130;
			}
		}
		
		private function control():void
		{
			moveTowards(Player.pos.x + randPos.x, Player.pos.y + randPos.y, 2);
			FP.world.mouseX > x? isFlipped = true:isFlipped = false;
			turret.play("walk");
			if ((x == Player.pos.x + randPos.x) && (Player.pos.y + randPos.y))
			{
				turret.rate = 0
			}
			else
			{
				turret.rate = 30;
			}
			
			if (y < 160) y = 160;
			if (y > 460) y = 460;
			
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