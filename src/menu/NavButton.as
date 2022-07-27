package menu 
{
	import etc.GFX;
	import etc.SFX;
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Darksider
	 */
	public class NavButton extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.MENUBTN, 90, 70);
		private var image2:Spritemap = new Spritemap(GFX.MENUBTN, 90, 70);
		public var callback:Function = null;
		
		private var clickSfx:Sfx = new Sfx(SFX.tone4);
		
		public var id:int = 0;
		
		public function NavButton(_callback:Function = null, _id:int = 0, _x:int = 0, _y:int = 0) 
		{
			this.callback = _callback;
			
			x = _x;
			y = _y;
			
			addGraphic(image);
			addGraphic(image2);
			
			image.centerOrigin()
			image2.centerOrigin();
			
			image.frame = image2.frame = _id;
			setHitbox(image.width, image.height, image.width/2, image.height/2);
			image.smooth = true;
			image2.smooth = true;
			image2.blend = "add";
			image2.alpha = 0.5;
			this.layer = -1990;
			
			type = "navBtn";
			id = _id;
		}
		
		override public function update():void
		{
			super.update();
			action()
		}
		
		private function action():void
		{
			if (collide("cursor", x, y))
			{
				image2.visible = true;
				if (Input.mouseReleased)
				{
					callback();
					clickSfx.play(Settings.sound);
				}
			}
			else
			{
				image2.visible = false;
			}
		}
		
	}

}