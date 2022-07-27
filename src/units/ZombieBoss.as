package units 
{
	import etc.Blood;
	import etc.Blood2;
	import etc.Bullet;
	import etc.Coin;
	import etc.Explode;
	import etc.Explosion;
	import etc.Hit;
	import etc.Particle;
	import etc.SFX;
	import etc.WorldObject;
	import etc.ZombieBullet;
	import flash.geom.Point;
	import items.Shield;
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import etc.GFX;
	import net.flashpunk.FP;
	import ui.GameUI;
	
	/**
	 * ...
	 * @author Darksider
	 */
	public class ZombieBoss extends Entity
	{
		// Характеристики
		private var walkSpeed:Number = 1;
		public static var canWalk:Boolean = true;
		public var currentHealth:int = 700;
		private var totalHealth:int = 700;
		
		private var attackSpeed:int = 0;
		private var cooldown:int = 20;
		private var damage:int = 20;
		
		private var specAttackSpeed:int = 0;
		private var specCooldown:int = 200;
		private var specDamage:int = 20;
		
		private var isFlipped:Boolean = false;
		private var isDeath:Boolean = false;
		private var isRised:Boolean = true;
		private var timerDeath:int = 60;
		
		private var body:Spritemap;
		
		private var shadow:Spritemap = new Spritemap(GFX.SHADOW, 100, 100);
		private var healthBar:Spritemap = new Spritemap(GFX.HEALTHBAR, 82, 16);
		private var healthBarBg:Spritemap = new Spritemap(GFX.HEALTHBAR, 82, 16);
		
		private var id:int = 1;
		private var target:Point;
		private var targetMiss:Point = new Point( -400, 300);
		private var dropChance:int = 100; // percent
		
		private var hitSfx:Sfx;
		private var dieSfx:Sfx;
		public function ZombieBoss (_x:int = 0, _y:int = 0, _id:int = 1) 
		{
			setHitbox(40, 110, 20, 80);
			type = "zombie";
			id = _id;
			x = _x;
			y = _y;
			attackSpeed = cooldown;
			
			switch(_id)
			{
				case 1:
					body = new Spritemap(GFX.ZOMBIE_BOSS1, 250, 250);
					totalHealth = 800;
				break;
				case 2:
					body = new Spritemap(GFX.ZOMBIE_BOSS2, 250, 250);
					totalHealth = 1000;
				break;
				case 3:
					body = new Spritemap(GFX.ZOMBIE_BOSS3, 250, 250);
					totalHealth = 1300;
				break;
				case 4:
					body = new Spritemap(GFX.ZOMBIE_BOSS4, 250, 250);
					totalHealth = 1500;
				break;
			}
			
			currentHealth = totalHealth;
			
			shadow.y = 20;
			shadow.centerOrigin();
			shadow.smooth = true;
			shadow.scale = 0.8;
			shadow.alpha = 0.4;
			
			body.scale = 0.8;
			body.smooth = true;
			body.centerOrigin();
			body.y = - 40;
			
			healthBar.frame = 1;
			healthBar.smooth = true;
			healthBarBg.smooth = true;
			healthBar.y = -130;
			healthBarBg.y = -130;
			healthBar.x = -40;
			healthBarBg.x = -40;
			healthBarBg.blend = "overlay";
			healthBarBg.alpha = 0;
			healthBar.alpha = 0;
			
			body.add("walk", [[0], [1], [2], [3]], 5, true)
			body.add("stand", [[3]], 1, true);
			body.add("attack", [[4], [5], [6], [7]], 9, true);
			body.add("spec", [[12], [13], [14], [15]], 9, false);
			body.add("die", [[8], [9], [10], [11]], 7, false);
			
			target = Player.pos;
		}
		
		override public function added():void
		{
			canWalk = true;
			addGraphic(shadow);
			addGraphic(body);
			addGraphic(healthBarBg);
			addGraphic(healthBar);
			body.play("stand");
		}
		
		override public function update():void
		{
			super.update();
			
			this.layer = -y;
			healthBar.alpha -= 0.01;
			healthBarBg.alpha -= 0.01;
			
			if ((!isDeath) && (canWalk))
			{
				action();
				control();
				flipped();
			}
			
			if (isDeath)
			{
				body.play("die");
				timerDeath > 0?timerDeath -= 1:timerDeath = 0;
				if (timerDeath <= 0) body.alpha <= 0?FP.world.remove(this):body.alpha -= 0.1;
			}
		}
		
		private function control():void
		{
			// если игрок мертв
			if (Player.isDeath)
			{
				target = targetMiss;
				moveTowards( target.x, target.y, walkSpeed)
				body.play("walk");
				return
			}
			else
			{
				target = Player.pos;
			}
			
			// если столкнулся со щитом
			var shield:Shield = collide("shield", x, y) as Shield
			if (shield)
			{
				body.play("attack");
				if (attackSpeed >= cooldown) 
				{
					attackSpeed = 0;
					shield.hurt(damage);
				}
				else
				{
					attackSpeed++;
				}
				return
			}
			
			// если столкнулся с игроком
			if (collide("player", x, y))
			{
				attack();
			}
			else
			{
				if (body.frame == 7) body.play("walk");
				if ((body.currentAnim == "spec") && (body.complete)) body.play("walk");
				if (body.currentAnim == "stand") body.play("walk");
				if(body.currentAnim=="walk") moveTowards(target.x, target.y, walkSpeed);
			}
			
			
			// если столкнулся с зомби
			var zomb:Zombie = collide("zombie", x, y) as Zombie
			if (zomb)
			{
				if (zomb.x > this.x) zomb.x += 1;
				if (zomb.x < this.x) zomb.x -= 1;
				if (zomb.y > this.y) zomb.y += 1;
				if (zomb.y < this.y) zomb.y -= 1;
			}
			
			// Ограничения зомби
			if (x < 40) x = 40;
			if (y < 160) y = 160;
			if (x > Player.playerBlock.x) x = Player.playerBlock.x;
			if (y > Player.playerBlock.y - 50) y = Player.playerBlock.y - 50;
		}
		
		private function action():void
		{
			if (specAttackSpeed >= specCooldown) 
			{
				switch(id)
				{
					case 1:
						var zomb:Zombie = collide("zombie", x, y) as Zombie
						if ((zomb)&&(zomb.isRised)&&(!zomb.isDeath))
						{
							FP.world.add(new Particle(zomb.x, zomb.y, isFlipped, "brain"));
							FP.world.add(new Particle(zomb.x, zomb.y, false, "meat"));
							FP.world.add(new Particle(zomb.x, zomb.y, true, "meat"));
							FP.world.add(new Particle(zomb.x, zomb.y, true, "blood"));
							FP.world.add(new Particle(zomb.x, zomb.y, false, "blood"));
							FP.world.add(new Particle(zomb.x, zomb.y, true, "blood"));
							FP.world.add(new Blood(zomb.x, zomb.y - 15));
							body.play("spec");
							specAttackSpeed = 0;
							zomb.isBullet = true;
							zomb.y = y - 70;
						}
					break;
					case 2:
						body.play("spec");
						specAttackSpeed = 0;
						var zombArray:Array = [];
						FP.world.getClass(Zombie, zombArray);
						for (var i:int = 0; i < zombArray.length; i++)
						{
							zombArray[i].inRage = true;
						}
					break;
					case 3:
						body.play("spec");
						specAttackSpeed = 0;
						var ang:int = -int(Math.atan2(target.y - y + 60, target.x - x) * 180 / Math.PI);
						FP.world.add(new ZombieBullet(x, y - 60, ang, specDamage, "aid"));
					break;
					case 4:
						var zomb2:Zombie = collide("zombie", x, y) as Zombie
						if ((zomb2)&&(zomb2.isRised)&&(!zomb2.isDeath))
						{
							FP.world.add(new Particle(zomb2.x, zomb2.y, isFlipped, "brain"));
							FP.world.add(new Particle(zomb2.x, zomb2.y, false, "meat"));
							FP.world.add(new Particle(zomb2.x, zomb2.y, true, "meat"));
							FP.world.add(new Particle(zomb2.x, zomb2.y, true, "blood"));
							FP.world.add(new Particle(zomb2.x, zomb2.y, false, "blood"));
							FP.world.add(new Particle(zomb2.x, zomb2.y, true, "blood"));
							FP.world.add(new Blood(zomb2.x, zomb2.y - 15));
							body.play("spec");
							specAttackSpeed = 0;
							zomb2.isBullet = true;
							zomb2.y = y;
						}
					break;
				}
			}
			else
			{
				specAttackSpeed++;
			}
		}
		
		private function attack():void
		{
			body.play("attack");
			var player:Player = collide("player", x, y) as Player
			if (player)
			{
				if (attackSpeed >= cooldown) 
				{
					attackSpeed = 0;
					player.hurt(damage);
					FP.world.add(new Blood2(player.x, player.y, isFlipped));
				}
				else
				{
					attackSpeed++;
				}
			}
		}
		
		override public function render():void
		{
			super.render();
			if (!canWalk) body.play("stand");
		}
		
		public function hurt(_damage:int = 0):void
		{
			var randHit:int = Math.random() * 3;
			switch(randHit)
			{
				case 0:
					hitSfx = new Sfx(SFX.zombHit1);
					dieSfx = new Sfx(SFX.zombDie1);
				break;
				case 1:
					hitSfx = new Sfx(SFX.zombHit2);
					dieSfx = new Sfx(SFX.zombDie2);
				break;
				case 2:
					hitSfx = new Sfx(SFX.zombHit3);
					dieSfx = new Sfx(SFX.zombDie3);
				break;
			}
			
			hitSfx.play(Settings.sound*0.3);
			
			currentHealth -= _damage;
			healthBar.scaleX = currentHealth / totalHealth;
			healthBar.alpha = 1;
			healthBarBg.alpha = 1;
			if (currentHealth <= 0) 
			{
				if (id == 3) 
				{
					FP.world.add(new Explosion(x, y, "gas"));
					FP.world.add(new Explode(x, y, specDamage));
				}
				
				dieSfx.play(Settings.sound*0.3);
				isDeath = true;
				FP.world.add(new Particle(x, y, isFlipped, "brain"));
				FP.world.add(new Particle(x, y, false, "meat"));
				FP.world.add(new Particle(x, y, true, "meat"));
				FP.world.add(new Particle(x, y, true, "blood"));
				FP.world.add(new Particle(x, y, false, "blood"));
				FP.world.add(new Particle(x, y, true, "blood"));
				FP.world.add(new Blood(x, y - 15));
				collidable = false;
				
				healthBar.visible = false;
				healthBarBg.visible = false;
				currentHealth = 0;
				
				var rand:int = Math.round(Math.random() * 100);
				if (rand < dropChance) 
				{
					FP.world.add(new Coin(x, y));
				}
				
				Player.getExp(totalHealth / 10);
			}
		}
		
		private function flipped():void
		{
			target.x < x? isFlipped = true:isFlipped = false;
			body.flipped = isFlipped;
		}
		
	}

}