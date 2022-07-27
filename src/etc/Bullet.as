package etc 
{
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import units.Zombie;
	import etc.Particle;
	import units.ZombieBoss;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Bullet extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.BULLET, 200, 200);
		private var speed:int = 30;
		private var damage:int = 0;
		private var collidedZombie:Zombie;
		private var collidedZombieBoss:ZombieBoss;
		private var collidedItem:ItemsStreet;
		
		private var radius:int = 800;
		private var startPoint:Point = new Point();
		private var isPlasma:Boolean = false;
		
		private var health:int = 0;
		public function Bullet(_x:int = 0, _y:int = 0, _angle:int = 0, _damage:int = 0, _type:String = "pistol")
		{
			x = _x;
			y = _y;
			damage = _damage;
			health = _damage;
			startPoint.x = x;
			startPoint.y = y;
			speed = Math.random() * 10 + 40;
			
			image.scale = 0.5;
			
			if (_type == "plasma") 
			{
				image.frame = 2;
				image.blend = "add";
			}
			if (_type == "melee") 
			{
				radius = 20;
				image.visible = false;
			}
			if (_type == "arbalet") 
			{
				image.frame = 1;
			}
			if (_type == "explos") 
			{
				radius = 60;
				image.visible = false;
			}
			if (_type == "napalm")
			{
				image.visible = false;
				radius = 120;
			}
			if (_type == "rail")
			{
				image.visible = false;
			}
			
			setHitbox(20, 20, 10, 10);
			graphic = image;
			image.centerOrigin();
			image.smooth = true;
			image.angle = _angle;
			type = "bullet";
			
		}
		
		override public function update():void
		{
			super.update();
			this.layer = -y;
			
			
			if (distanceToPoint(startPoint.x, startPoint.y) > radius) FP.world.remove(this);
			
			if (x < FP.camera.x) destroy();
			if (x > FP.camera.x + FP.width) destroy();
			// угол поворота в радианах
			var radians:Number = -image.angle*Math.PI/180;
			// вычисляем направление по X и Y
			var vectorX:Number = Math.cos(radians);
			var vectorY:Number = Math.sin(radians);
			x += speed * vectorX;
			y += speed * vectorY;
			
			
			// попадание в зомби
			var zomb:Zombie = collide("zombie", x, y) as Zombie
			if ((zomb) && (collidedZombie != zomb))
			{
				if (zomb.currentHealth > 0) health -= zomb.currentHealth;
				zomb.hurt(damage);
				collidedZombie = zomb;
				FP.world.add(new Hit(x, y, image.angle));
			}
			
			var zombBoss:ZombieBoss = collide("zombie", x, y) as ZombieBoss
			if ((zombBoss) && (collidedZombieBoss != zombBoss))
			{
				if (zombBoss.currentHealth > 0) health -= zombBoss.currentHealth;
				zombBoss.hurt(damage);
				collidedZombieBoss = zombBoss;
				FP.world.add(new Hit(x, y, image.angle));
			}
			
			var item:ItemsStreet = collide("itemsStreet", x, y) as ItemsStreet
			if ((item) && (collidedItem!=item))
			{
				if (item.health > 0) health -= item.health;
				item.hurt(damage);
				collidedItem = item;
			}
			
			if (health <= 0) destroy();
		}
		
		private function destroy():void
		{
			FP.world.remove(this);
		}
		
	}

}