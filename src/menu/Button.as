package menu 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import etc.GFX;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Button extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.PLAY_BTN, 0, 0);
		public var callback:Function = null;
		
		public function Button(_callback:Function = null,  _x:int = 0, _y:int = 0) 
		{
			this.callback = _callback;
			graphic = image;
			image.centerOrigin();
			image.scale = 0.5;
			setHitbox(image.width, image.height, image.width/2, image.height/2);
			x = _x;
			y = _y;
			image.smooth = true;
			this.layer = -1990;
		}
		
		public function setImage(_image:Class = undefined, _width:int = 0, _height:int = 0,_scale:Number = 1):void
		{
			image = new Spritemap(_image, _width, _height);
			image.centerOrigin();
			image.scale = _scale;
			graphic = image;
			setHitbox(_width*_scale, _height*_scale, (_width/2)*_scale, (_height/2)*_scale);
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
				image.frame = 1;
				if (Input.mouseReleased)
				{
					callback();
				}
			}
			else
			{
				image.frame = 0;
			}
		}
		
	}

}