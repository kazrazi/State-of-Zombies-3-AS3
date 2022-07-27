package etc 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import units.Player;
	/**
	 * ...
	 * @author Darksider
	 */
	public class LevelUP extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.LEVELUP, 200, 200);
		private var levelSfx:Sfx = new Sfx(SFX.levelup);
		
		public function LevelUP() 
		{
			graphic = image;
			image.centerOrigin();
			image.originY = 150;
			image.scale = 1.3;
			image.smooth = true;
			image.blend = "add";
			image.add("play", [[0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10]], 20, false);
			image.play("play");
		}
		
		override public function added():void
		{
			levelSfx.play(Settings.sound);
		}
		
		override public function update():void
		{
			super.update();
			x = Player.pos.x;
			y = Player.pos.y;
			this.layer = -y - 100;
			if (image.complete) FP.world.remove(this);
		}
	}

}