package menu 
{
	import etc.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXText;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Darksider
	 */
	public class WeapBtn extends Entity
	{
		public var image:Spritemap = new Spritemap(GFX.MENUWEAPBTN, 145, 45);
		public var statusText:FXText = new FXText("none", -20, -10);
		public var outlineFX:GlowFX;
		public var callback:Function = null;
		public function WeapBtn(_callback:Function = null) 
		{
			setHitbox(image.width-20, image.height, image.width/2-10, image.height/2);
			this.callback = _callback;
			
			addGraphic(image);
			addGraphic(statusText);
			
			image.centerOrigin()
			image.smooth = true;
			
			statusText.centerOrigin();
			statusText.size = 25;
			statusText.font = 'My Font';
			statusText.color = 0xFFCC00;
			outlineFX = new GlowFX(5, 0x3B080F, 10, 1);
			statusText.effects.add(outlineFX);
			statusText.smooth = true;
			
			layer = -1990;
		}
		
		override public function update():void
		{
			super.update();
			action();
			
			statusText.alpha = image.alpha;
			if (GameMenu.menuPanelReady)
			{
				image.alpha < 1? image.alpha += 0.2:image.alpha = 1;
			}
			
			
		}
		
		override public function added():void
		{
			image.alpha = statusText.alpha = 0;
		}
		
		private function action():void
		{
			if ((collide("cursor", x, y)) && (x > 200))
			{
				if (statusText.text != "ready")
				{
					image.scale = 1.1;
					statusText.scale = 1.1;
				}
				if (Input.mouseReleased)
				{
					callback();
				}
				
			}
			else
			{
				image.scale = 1;
				statusText.scale = 1;
				
			}
		}
		
	}

}