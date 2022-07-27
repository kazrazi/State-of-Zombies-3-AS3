package ui 
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
	public class GameStatusBtn extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.GAMESTATUSBTN, 70, 70);
		public var callback:Function = null;
		private var id:int = 0;
		
		private var clickSfx:Sfx = new Sfx(SFX.tone4);
		public function GameStatusBtn(_callback:Function = null, _id:int = 0)
		{
			id = _id;
			this.callback = _callback;
			graphic = image;
			image.centerOrigin();
			image.scale = 1;
			setHitbox(image.width, image.height, image.width/2, image.height/2);
			image.smooth = true;
			this.layer = -1999;
		}
		
		override public function update():void
		{
			super.update();
			action();
			
		}
		
		private function action():void
		{
			if (collide("cursor", x, y))
			{
				image.frame = id + 1;
				if (Input.mouseReleased)
				{
					clickSfx.play(Settings.sound);
					callback();
				}
			}
			else
			{
				image.frame = id;
			}
		}
		
	}

}