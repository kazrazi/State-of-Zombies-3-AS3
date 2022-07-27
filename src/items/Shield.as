package items 
{
	import etc.GFX;
	import etc.SFX;
	import etc.TextEffect;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import units.Player;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Shield extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.SHIELD, 200, 200);
		private var shadowImage:Spritemap = new Spritemap(GFX.SHIELD, 200, 200);
		public static var totalHealth:int = 250;
		public static var power:int = 0;
		private var destroyShield:Boolean = false;
		private var shadow:Entity = new Entity();
		
		private var shieldSfx:Sfx = new Sfx(SFX.shield);
		public function Shield() 
		{
			addGraphic(image);
			image.smooth = true;
			image.frame = 1;
			image.add("play", [[1], [2], [3], [2], [1]], 20, true);
			image.centerOrigin();
			image.scaleX = image.scaleY = 0;
			image.originY = 130;
			
			setHitbox(120, 120, 60, 70);
			type = "shield";
		}
		
		override public function added():void
		{
			power = totalHealth;
			shadow.graphic = shadowImage;
			shadowImage.centerOrigin();
			FP.world.add(shadow);
			shieldSfx.play(Settings.sound);
			
			FP.world.add(new TextEffect(2, Player.pos.x, Player.pos.y, "SHIELD"));
		}
		
		override public function update():void
		{
			super.update();
			this.layer = -y - 30;
			
			x = Player.pos.x;
			y = Player.pos.y;
			image.scaleX < 1? image.scaleX += 0.2: image.scaleX = 1;
			if (image.scaleX > 0.6) image.scaleY < 1? image.scaleY += 0.2:image.scaleY = 1;
			
			if (destroyShield) image.alpha -= 0.2;
			if (image.alpha <= 0) FP.world.remove(this);
			if (image.alpha <= 0) FP.world.remove(shadow);
			
			shadow.x = x;
			shadow.y = y - 30;
			shadowImage.scaleX = image.scaleX;
			shadowImage.scaleY = image.scaleY;
			shadow.layer = -y + 60;
			
			image.play("play");
			
			if (image.frame == 2) hurt(1);
		}
		
		public function hurt(_damage:int = 0):void
		{
			power - _damage > 0? power -= _damage: destroyShield = true;
			
		}
		
	}

}