package etc 
{
	import items.Bonus;
	import items.Droid;
	import items.Turret;
	import items.WalkerD;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Darksider
	 */
	public class ItemsStreet extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.ITEMSSTREET, 100, 100);
		private var healthBar:Spritemap = new Spritemap(GFX.HEALTHBAR, 82, 16);
		private var healthBarBg:Spritemap = new Spritemap(GFX.HEALTHBAR, 82, 16);
		
		public var health:int = 100;
		private var totalHealth:int = 0;
		private var id:int = 0;
		
		private var damage:int = 50;
		
		private var hitSfx:Sfx = new Sfx(SFX.itemHit);
		
		private var dropChance:int = 10; // percent
		private var hitTimer:Number = 0;
		
		public function ItemsStreet(_id:int = 0, _x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y;
			id = _id;
			
			addGraphic(image);
			image.centerOrigin();
			image.smooth = true;
			image.frame = _id;
			setHitbox(60, 60, 30, 30);
			type = "itemsStreet";
			
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
			healthBarBg.alpha = 0;
			healthBar.alpha = 0;
			totalHealth = health;
		}
		
		override public function update():void
		{
			super.update()
			this.layer = -y;
			healthBar.alpha -= 0.01;
			healthBarBg.alpha -= 0.01;
			
			hitTimer += 1;
			if (hitTimer >= 1)
			{
				hitTimer = 0;
				this.collidable = true
			}
		}
		
		public function hurt(_damage:int = 0):void
		{
			hitSfx = new Sfx(SFX.itemHit);
			hitSfx.play(Settings.sound * 0.5);
			
			this.collidable = false;
			
			health -= _damage;
			if (health <= 0) destroy();
			
			
			healthBar.scaleX = health / totalHealth;
			healthBar.alpha = 1;
			healthBarBg.alpha = 1;
		}
		
		private function destroy():void
		{
			FP.world.remove(this);
			if (id < 2)
			{
				FP.world.add(new Explosion(x, y, "explos"));
				FP.world.add(new Explode(x, y, damage));
			}
			else
			{
				FP.world.add(new Explosion(x, y, "smoke"));
				
				FP.world.add(new Particle(x, y, true, "chip"));
				FP.world.add(new Particle(x, y, true, "chip"));
				FP.world.add(new Particle(x, y, true, "chip"));
				FP.world.add(new Particle(x, y, false, "chip"));
				
				var rand:int = Math.round(Math.random() * 100);
				if (id == 7)
				{
					if (rand < 30)
					{
						FP.world.add(new Turret(x, y));
					}
					else
					if (rand < 60)
					{
						FP.world.add(new WalkerD(x, y));
					}
					else
					{
						FP.world.add(new Droid(x, y));
					}
					return
				}
				
				if (rand < dropChance) 
				{
					FP.world.add(new Bonus(Math.random() * 6, x, y));
				}
				else
				{
					FP.world.add(new Coin(x, y));
				}
			}
		}
		
	}

}