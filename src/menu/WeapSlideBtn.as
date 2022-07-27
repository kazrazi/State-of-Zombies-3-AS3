package menu 
{
	import etc.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Darksider
	 */
	public class WeapSlideBtn extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.MENUSLIDEBTN, 40, 45);
		private var vect:Number;
		public var callback:Function = null;
		public function WeapSlideBtn(_x:int = 0, _y:int = 0, _vect:Number = 0, _callback:Function = null) 
		{
			this.callback = _callback;
			x = _x;
			y = _y;
			vect = _vect;
			addGraphic(image);
			setHitbox(40, 40, 20, 20);
			image.centerOrigin()
			image.smooth = true;
			vect < 0? image.flipped = true: image.flipped = false;
		}
		
		override public function added():void
		{
			image.alpha = 0;
		}
		
		override public function update():void
		{
			super.update();
			action();
			
			if (GameMenu.menuPanelReady)
			{
				image.alpha < 1? image.alpha += 0.2:image.alpha = 1;
			}
		}
		
		private function action():void
		{
			if (collide("cursor", x, y))
			{
				image.frame = 1;
				image.scale = 0.8;
				image.originX = image.width / 2 - vect * 10;
				if (Input.mouseDown)
				{
					callback();
				}
			}
			else
			{
				image.centerOrigin();
				image.frame = 0;
				image.scale = 0.5;
			}
		}
		
	}

}