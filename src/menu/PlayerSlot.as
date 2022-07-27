package menu 
{
	import etc.GFX;
	import etc.SFX;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXText;
	/**
	 * ...
	 * @author Darksider
	 */
	public class PlayerSlot extends Entity
	{
		private var back:Spritemap = new Spritemap(GFX.MENUPLAYERSLOT, 140, 220);
		private var image:Spritemap = new Spritemap(GFX.PLAYERMENU, 200, 200);
		private var nameText:FXText = new FXText("", -60, -104);
		private var outlineFX:GlowFX = new GlowFX(5, 0x3B080F, 10, 1);
		
		private var weapBtn:WeapBtn;
		private var id:int = 1;
		
		private var clickSfx:Sfx = new Sfx(SFX.tone5);
		
		public function PlayerSlot(_x:int = 0, _y:int = 0, _id:int = 1, _name:String= "None") 
		{
			id = _id;
			x = _x;
			y = _y;
			
			addGraphic(back);
			addGraphic(image);
			addGraphic(nameText);
			
			nameText.size = 20;
			nameText.font = 'My Font'
			nameText.align = "left";
			nameText.color = 0xFFCC00;
			nameText.effects.add(outlineFX);
			nameText.text = _name;
			
			image.frame = _id - 1;
			image.smooth = true;
			image.centerOrigin();
			
			back.smooth = true;
			back.centerOrigin();
		}
		
		override public function added():void
		{
			weapBtn = new WeapBtn(click);
			FP.world.add(weapBtn);
			weapBtn.x = x;
			weapBtn.y = y + 130;
			back.alpha = image.alpha = nameText.alpha = 0;
			
			reset();
			if (Settings.playerID == id) click(true);
		}
		
		public function reset():void
		{
			weapBtn.statusText.text = "select";
			weapBtn.image.frame = 0;
			back.frame = 0;
		}
		
		override public function update():void
		{
			super.update();
			
			back.alpha = nameText.alpha = image.alpha;
			if (GameMenu.menuPanelReady)
			{
				image.alpha < 1? image.alpha += 0.2:image.alpha = 1;
			}
		}
		
		private function click(nosound:Boolean = false):void
		{
			var resetArray:Array = [];
			FP.world.getClass(PlayerSlot, resetArray);
			for (var i:int = 0; i < resetArray.length; i++)
			{
				resetArray[i].reset();
			}
			
			Settings.playerID = id;
			GameMenu.playerLab.frame = id - 1;
			weapBtn.statusText.text = "ready";
			weapBtn.image.frame = 2;
			back.frame = 1;
			
			if (!nosound) clickSfx.play(Settings.sound);
		}
		
	}

}