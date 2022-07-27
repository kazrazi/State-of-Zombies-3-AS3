package etc 
{
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import items.Shield;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import units.Player;
	import units.Zombie;
	import etc.Particle;
	import units.ZombieBoss;
	/**
	 * ...
	 * @author Darksider
	 */
	public class ZombieBullet extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.BULLETZOMBIE, 200, 200);
		private var speed:int = 10;
		private var damage:int = 0;
		
		private var health:int = 0;
		
		public function ZombieBullet(_x:int = 0, _y:int = 0, _angle:int = 0, _damage:int = 0, _type:String = "aid")
		{
			x = _x;
			y = _y;
			damage = _damage;
			image.scale = 0.8;
			
			setHitbox(20, 20, 10, 10);
			graphic = image;
			image.centerOrigin();
			image.smooth = true;
			image.angle = _angle;
			type = "bullet";
			image.add("play", [[0], [1], [2]], 10, true);
			image.play("play");
		}
		
		override public function update():void
		{
			super.update();
			this.layer = -y - 150;
			
			if (x < FP.camera.x) destroy();
			if (x > FP.camera.x + FP.width) destroy();
			// угол поворота в радианах
			var radians:Number = -image.angle*Math.PI/180;
			// вычисляем направление по X и Y
			var vectorX:Number = Math.cos(radians);
			var vectorY:Number = Math.sin(radians);
			x += speed * vectorX;
			y += speed * vectorY;
			
			
			// попадание в игрока
			var player:Player = collide("player", x, y) as Player
			if (player)
			{
				player.hurt(damage);
				FP.world.add(new Hit(x, y, image.angle));
				destroy();
			}
			
			// попадание в щит
			var shield:Shield = collide("shield", x, y) as Shield
			if (shield)
			{
				shield.hurt(damage);
				destroy();
			}
		}
		
		private function destroy():void
		{
			FP.world.remove(this);
		}
		
	}

}