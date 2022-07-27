package menu 
{
	import etc.GFX;
	import etc.SFX;
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXText;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import net.flashpunk.utils.*;
	/**
	 * ...
	 * @author Darksider
	 */
	public class ButtonCheck extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.SFXBTN, 55, 50);
		private var nameBtn:String = "sound";
		private var posY:int = 0;
		
		public static var soundOn:Boolean = true;
		public static var musicOn:Boolean = true;
		
		private var clickSfx:Sfx = new Sfx(SFX.tone4);
		
		public function ButtonCheck(_x:int = 0, _y:int = 0, _name:String = "sound") 
		{
			x = _x;
			y = _y;
			image.scale = 0.9;
			image.smooth = true;
			image.centerOrigin();
			setHitbox(image.width * image.scale, image.height * image.scale, image.width / 2 * image.scale, image.height / 2 * image.scale);
			graphic = image;
			nameBtn = _name;
			
			this.layer = -1999;
			posY = _y;
			type = "button";
		}
		
		override public function update():void
		{
			super.update();
			image.scrollY = 0;
			this.originY = posY - FP.camera.y;
			
			switch(nameBtn)
			{
				case "sound":
					soundOn?image.frame = 3: image.frame = 0;
				break;
				case "music":
					musicOn?image.frame = 4: image.frame = 1;
				break;
			}
			
			if (collide("cursor", x, y))
			{
				if (Input.mouseReleased) change(nameBtn);
			}
		}
		
		private function change(_name:String = "sound"):void
		{
			var volume:Number = 0;
			soundOn? volume = 0:volume = 1;
			clickSfx.play(volume);
			switch(_name)
			{
				case "sound":
					soundOn?Settings.sound = 0:Settings.sound = 1;
					soundOn?soundOn = false:soundOn = true;
				break;
				case "music":
				    musicOn?Settings.music = 0:Settings.music = 1;
					musicOn?musicOn = false:musicOn = true;
				break;
			}
		}
		
	}

}