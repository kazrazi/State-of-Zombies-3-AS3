package items 
{
	import etc.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import ui.PlayerBonus;
	import units.Player;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Bonus extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.ITEMICONS, 170, 170);
		private var focus:Spritemap = new Spritemap(GFX.ITEMFOCUS, 170, 170);
		private var id:int = 0;
		
		private var timer:int = 0;
		private var show:Boolean = true;
		
		private var collected:Boolean = false;
		
		public function Bonus(_id:int = 0, _x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y;
			id = _id;
			
			addGraphic(image);
			image.centerOrigin();
			image.smooth = true;
			image.frame = 6 + id;
			image.scale = 0.6;
			
			addGraphic(focus);
			focus.centerOrigin();
			focus.smooth = true;
			focus.scale = 0.6;
			
			setHitbox(50, 50, 25, 25);
		}
		
		override public function update():void
		{
			super.update();
			this.layer = -y;
			timer++;
			
			var player:Player = collide("player", x, y) as Player
			if (player)
			{
				collected = true;
			}
			
			if (timer > 500) image.alpha -= 0.2;
			if (image.alpha <= 0) 
			{
				if (collected) player.getBonus(id);
				FP.world.remove(this);
			}
			
			if (collected)
			{
				moveTowards(player.x, player.y, 10);
				if ((x == player.x) && (y == player.y))
				{
					image.alpha -= 0.2;
				}
			}
			
			if (timer > 400)
			{
				if (show)
				{
					image.alpha -= 0.1;
					if (image.alpha <= 0.2) show = false;
				}
				if (!show)
				{
					image.alpha += 0.1;
					if (image.alpha >= 1) show = true;
				}
			}
			else
			{
				if (show)
				{
					focus.scale -= 0.01;
					if (focus.scale <= 0.5) show = false;
				}
				if (!show)
				{
					focus.scale += 0.01;
					if (focus.scale >= 0.6) show = true;
				}
			}
			
		}
		
	}

}