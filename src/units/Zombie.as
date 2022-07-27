package units 
{
	import etc.Blood;
	import etc.Blood2;
	import etc.Bullet;
	import etc.Coin;
	import etc.Hit;
	import etc.Particle;
	import etc.SFX;
	import etc.TextEffect;
	import etc.WorldObject;
	import flash.geom.Point;
	import items.Shield;
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import etc.GFX;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Darksider
	 */
	public class Zombie extends Entity
	{
		// Характеристики
		private var walkSpeed:Number = 2;
		public static var canWalk:Boolean = true;
		public var currentHealth:int = 100;
		private var totalHealth:int = 100;
		private var attackSpeed:int = 0;
		private var cooldown:int = 10;
		private var damage:int = 5;
		
		private var isFlipped:Boolean = false;
		private var quake:Number = 0;
		public var isDeath:Boolean = false;
		public var isRised:Boolean = false;
		private var timerDeath:int = 60;
		
		private var body:Spritemap;
		private var head:Spritemap;
		private var legs:Spritemap;
		private var handL:Spritemap;
		private var handR:Spritemap;
		
		private var shadow:Spritemap = new Spritemap(GFX.SHADOW, 100, 100);
		private var healthBar:Spritemap = new Spritemap(GFX.HEALTHBAR, 82, 16);
		private var healthBarBg:Spritemap = new Spritemap(GFX.HEALTHBAR, 82, 16);
		
		private var target:Point;
		private var targetMiss:Point;
		
		private var dropChance:int = 30; // percent
		
		private var hitSfx:Sfx;
		private var dieSfx:Sfx;
		
		public var isBullet:Boolean = false;
		public var inRage:Boolean = false;
		
		public function Zombie(_x:int = 0, _y:int = 0, _id:int = 0) 
		{
			setHitbox(40, 80, 20, 50);
			type = "zombie";
			x = _x;
			y = _y;
			attackSpeed = cooldown;
			
			var k:int = 0;
			if (_id < 4)
			{
				body = new Spritemap(GFX.ZOMBIE1, 100, 100);
				head = new Spritemap(GFX.ZOMBIE1, 100, 100);
				legs = new Spritemap(GFX.ZOMBIE1, 100, 100);
				handL = new Spritemap(GFX.ZOMBIE1, 100, 100);
				handR = new Spritemap(GFX.ZOMBIE1, 100, 100);
				k = 0;
				totalHealth = 100;
			}
			else
			if ((_id >= 4) || (_id < 8))
			{
				body = new Spritemap(GFX.ZOMBIE3, 100, 100);
				head = new Spritemap(GFX.ZOMBIE3, 100, 100);
				legs = new Spritemap(GFX.ZOMBIE3, 100, 100);
				handL = new Spritemap(GFX.ZOMBIE3, 100, 100);
				handR = new Spritemap(GFX.ZOMBIE3, 100, 100);
				k = 4;
				totalHealth = 150 + _id * 3;
			}
			if (_id >= 8)
			{
				body = new Spritemap(GFX.ZOMBIE2, 100, 100);
				head = new Spritemap(GFX.ZOMBIE2, 100, 100);
				legs = new Spritemap(GFX.ZOMBIE2, 100, 100);
				handL = new Spritemap(GFX.ZOMBIE2, 100, 100);
				handR = new Spritemap(GFX.ZOMBIE2, 100, 100);
				k = 8;
				totalHealth = 200 + _id * 3;
			}
			currentHealth = totalHealth;
			
			head.frame = 0 + _id - k;
			body.frame = 4 + _id - k;
			handL.frame = 8 + _id - k;
			handR.frame = 8 + _id - k;
			
			shadow.y = 30;
			shadow.centerOrigin();
			shadow.smooth = true;
			shadow.scale = 0.6;
			shadow.alpha = 0.4;
			
			handL.scale = 0.8;
			handL.smooth = true;
			handL.centerOrigin();
			
			handR.scale = 0.8;
			handR.smooth = true;
			handR.centerOrigin();
			
			head.scale = 0.8;
			head.smooth = true;
			head.centerOrigin();
			head.originY = 70;
			
			body.scale = 0.8;
			body.smooth = true;
			body.centerOrigin();
			
			legs.scale = 0.9;
			legs.smooth = true;
			legs.centerOrigin();
			legs.add("stand", [[13]], 0, false);
			legs.play("stand");
			legs.add("play", [[16], [17], [18], [19], [20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31]], 20, true);
			
			legs.scaleY = 0;
			body.scaleY = 0;
			head.scaleY = 0;
			
			legs.y = 30;
			body.y = 30;
			head.y = 30;
			handL.y = 30;
			handR.y = 30;
			
			healthBar.frame = 1;
			healthBar.smooth = true;
			healthBarBg.smooth = true;
			healthBar.y = -90;
			healthBarBg.y = -90;
			healthBar.x = -40;
			healthBarBg.x = -40;
			healthBarBg.blend = "overlay";
			healthBarBg.alpha = 0;
			healthBar.alpha = 0;
			
			target = Player.pos;
			var rand:int = Math.random() * 2;
			rand == 0? targetMiss = new Point( -50, y): targetMiss = new Point( Player.playerBlock.x + 150, y);
		}
		
		override public function added():void
		{
			canWalk = true;
			
			addGraphic(shadow);
			addGraphic(handL);
			addGraphic(legs);
			addGraphic(body);
			addGraphic(head);
			addGraphic(handR);
			addGraphic(healthBarBg);
			addGraphic(healthBar);
			
			FP.world.add(new WorldObject(x, y, "risen"));
			FP.world.add(new Particle(x, y, true , "risen"));
			FP.world.add(new Particle(x, y, false , "risen2"));
			FP.world.add(new Particle(x, y, true , "risen2"));
			FP.world.add(new Particle(x, y, false , "risen"));
		}
		
		override public function update():void
		{
			super.update();
			this.layer = -y;
			
			// кидаемся зомби
			if(isBullet)
			{
				bulletMode();
				return
			}
			
			if (inRage)
			{
				walkSpeed = 3;
				legs.rate = 1.5;
				head.color = 0xD21414;
				body.color = 0xD21414;
				handL.color = 0xD21414;
				handR.color = 0xD21414;
				legs.color = 0xD21414;
			}
			
			if ((!isDeath)&&(isRised)&&(canWalk))
			{
				flipped();
				control();
				shake();
			}
			
			animation();
		}
		
		private function bulletMode():void
		{
			if (currentHealth <= 0) FP.world.remove(this);
			
			head.angle += 20;
			head.centerOrigin();
			handL.visible = handR.visible = body.visible = legs.visible = false;
			
			FP.world.add(new Particle(x, y, isFlipped, "blood"));
			
			var shield:Shield = collide("shield", x, y) as Shield
			if (shield)
			{
				FP.world.add(new Particle(x, y, isFlipped, "brain"));
				FP.world.add(new Particle(x, y, false, "meat"));
				FP.world.add(new Particle(x, y, true, "meat"));
				FP.world.add(new Particle(x, y, true, "blood"));
				FP.world.add(new Particle(x, y, false, "blood"));
				FP.world.add(new Particle(x, y, true, "blood"));
				FP.world.add(new Blood(x, y - 15));
				shield.hurt(damage * 2);
				FP.world.remove(this);
			}
			
			var player:Player = collide("player", x, y) as Player
			if (player)
			{
				FP.world.add(new Particle(x, y, isFlipped, "brain"));
				FP.world.add(new Particle(x, y, false, "meat"));
				FP.world.add(new Particle(x, y, true, "meat"));
				FP.world.add(new Particle(x, y, true, "blood"));
				FP.world.add(new Particle(x, y, false, "blood"));
				FP.world.add(new Particle(x, y, true, "blood"));
				FP.world.add(new Blood(x, y - 15));
				player.hurt(damage * 2);
				FP.world.remove(this);
			}
			
			moveTowards(Player.pos.x, Player.pos.y, 15)
		}
		
		override public function render():void
		{
			super.render();
			if (!canWalk) legs.play("stand");
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
				
				Player.getExp(totalHealth);
			}
		}
		
		private function attack():void
		{
			var Dy:int = -Math.cos(quake / 10) * 3;
			handL.angle = -Dy * 10;
			handR.angle = Dy * 10;
			head.angle = Dy * 10;
			quake > 1000? quake = 0: quake += walkSpeed + 1;
			
			var shield:Shield = collide("shield", x, y) as Shield
			if (shield)
			{
				if (shield.x > this.x) this.x -= 2;
				if (shield.x < this.x) this.x += 2;
				if (shield.y > this.y) this.y -= 2;
				if (shield.y < this.y) this.y += 2;
				
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
		
		private function animation():void
		{
			healthBar.alpha -= 0.01;
			healthBarBg.alpha -= 0.01;
			if (!isRised)
			{
				
				flipped();
				
				legs.play("stand");
				legs.scaleY < 1? legs.scaleY += 0.08:legs.scaleY = 1;
				body.scaleY < 1? body.scaleY += 0.12:body.scaleY = 1;
				head.scaleY < 1? head.scaleY += 0.16:head.scaleY = 1;
				
				legs.y > 18? legs.y -= 1.4:legs.y = 18;
				body.y > -5? body.y -= 4:body.y = -5;
				head.y > -30? head.y -= 6:head.y = -30;
				handR.y > -14? handR.y -= 5:handR.y = -14;
				handL.y > -14? handL.y -= 5:handL.y = -14;
				
				if (body.scaleY == 1) isRised = true;
			}
			
			if (isDeath)
			{
				head.visible = false;
				timerDeath > 0?timerDeath -= 1:timerDeath = 0;
				if (timerDeath <= 0) head.alpha <= 0?FP.world.remove(this):head.alpha = body.alpha = legs.alpha = handL.alpha = handR.alpha -= 0.1;
				if (isFlipped)
				{
					body.angle < 90? body.angle+= 8:body.angle = 90;
					body.x > -70? body.x -= 7: body.x = -70;
					body.y < 30? body.y += 2.5: body.y = 30;
					legs.x = body.x + 20;
					legs.y = body.y;
					body.angle == 90?legs.frame = 13:legs.frame = 12;
					body.angle == 90?legs.angle = 90:legs.angle = body.angle+30;
					handL.x = handR.x = body.x - 15;
					handL.y = handR.y = body.y + 15;
					shadow.x = body.x + 10;
					shadow.y = 25;
					shadow.scale < 1? shadow.scale += 0.1: shadow.scale = 1;
				}
				else
				{
					body.angle > -90? body.angle-= 8:body.angle = -90;
					body.x < 70? body.x += 7: body.x = 70;
					body.y < 30? body.y += 2.5: body.y = 30;
					legs.x = body.x - 20;
					legs.y = body.y;
					body.angle == -90?legs.frame = 13:legs.frame = 12;
					body.angle == -90?legs.angle = -90:legs.angle = body.angle-30;
					handL.x = handR.x = body.x + 15;
					handL.y = handR.y = body.y + 15;
					shadow.x = body.x - 10;
					shadow.y = 25;
					shadow.scale < 1? shadow.scale += 0.1: shadow.scale = 1;
				}
			}
		}
		
		private function flipped():void
		{
			target.x > x? isFlipped = true:isFlipped = false;
			if (isFlipped)
			{
				head.flipped = true;
				body.flipped = true;
				legs.flipped = true;
				handL.flipped = true;
				handR.flipped = true;
				
				handR.x = -12;
				handL.x = 0;
				head.x = -3;
				handR.angle = -30;
				head.angle = 10;
			}
			else
			{
				head.flipped = false;
				body.flipped = false;
				legs.flipped = false;
				handL.flipped = false;
				handR.flipped = false;
				
				handR.x = 12;
				handL.x = 0;
				head.x = 3;
				handR.angle = 30;
				head.angle = -10;
			}
		}
		
		private function control():void
		{
			// если игрок мертв
			if (Player.isDeath)
			{
				target = targetMiss;
				moveTowards( target.x, target.y, walkSpeed);
				shake();
				legs.play("play");
				return
			}
			
			// если столкнулся с игроком
			if (!collide("player", x, y))
			{
				moveTowards(target.x, target.y, walkSpeed);
				legs.play("play");
			}
			else
			{
				legs.play("stand");
				head.angle = 0;
				attack();
				shake();
			}
			
			// если столкнулся со щитом
			if (collide("shield", x , y))
			{
				legs.play("stand");
				head.angle = 0;
				attack();
				shake();
			}
			
			// если столкнулся с другим зомби
			var zomb:Zombie = collide("zombie", x, y) as Zombie
			if (zomb)
			{
				if (zomb.x > this.x) this.x -= 2;
				if (zomb.x < this.x) this.x += 2;
				if (zomb.y > this.y) this.y -= 2;
				if (zomb.y < this.y) this.y += 2;
			}
			
			// Ограничения зомби
			if (x < 40) x = 40;
			if (y < 160) y = 160;
			if (x > Player.playerBlock.x) x = Player.playerBlock.x;
			if (y > Player.playerBlock.y - 50) y = Player.playerBlock.y - 50;
		}
		
		private function shake():void
		{
			var Dy:int = -Math.cos(quake / 10) * 3;
			body.y = Dy - 5;
			head.y = Dy - 30;
			handL.y = Dy - 14;
			handR.y = Dy - 14;
			quake > 1000? quake = 0: quake += walkSpeed + 1;
		}
		
	}

}