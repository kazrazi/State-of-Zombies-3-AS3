package etc 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import ui.GameStatusBar;
	import ui.GameUI;
	import units.Player;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Helicopter extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.HELICOPTER, 720, 480);
		private var waveTimer:int = 0;
		private var quake:Number = 0;
		public static var heliSfx:Sfx = new Sfx(SFX.helicopter);
		public function Helicopter(_x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y;
			addGraphic(image);
			this.layer = -1940;
			type = "heli";
			
			setHitbox(40, 40, -380, -280);
		}
		
		override public function added():void
		{
			heliSfx.loop(Settings.sound);
		}
		
		override public function update():void
		{
			FP.camera.x < x - 500? heliSfx.volume = 0:heliSfx.volume = Settings.sound;
			
			super.update();
			waveTimer++;
			if (waveTimer > 7)
			{
				FP.world.add(new HeliWave(x + 400, 300));
				waveTimer = 0;
			}
			
			var Dy:int = -Math.cos(quake / 10) * 3;
			image.y = Dy - 5;
			quake > 1000? quake = 0: quake += 2;
			
			var player:Player = collide("player", x, y) as Player
			if (player)
			{
				destroy();
				FP.world.add(new GameStatusBar("victory"));
			}
		}
		
		private function destroy():void 
		{
			heliSfx.stop();
		}
		
	}

}