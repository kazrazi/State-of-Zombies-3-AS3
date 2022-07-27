package etc 
{
	import flash.ui.ContextMenuClipboardItems;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import ui.PlayerBonus;
	import units.Player;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Coin extends Entity
	{
		private var coin:Spritemap = new Spritemap(GFX.COIN, 40, 40);
		private var baks:Spritemap = new Spritemap(GFX.BAKS, 60, 60);
		private var shadow:Spritemap = new Spritemap(GFX.SHADOW, 100, 100);
		private var reward:int = 100;
		private var collected:Boolean = false;
		private var timer:int = 0;
		
		private var amplit:int = -10;
		
		private var moneySfx:Sfx = new Sfx(SFX.money);
		
		public function Coin(_x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y;
			var _id:int = Math.random() * 2;
			
			shadow.centerOrigin();
			shadow.smooth = true;
			shadow.scaleX = 0.7;
			shadow.scaleY = 1;
			shadow.alpha = 0.4;
			shadow.visible = false;
			addGraphic(shadow);
			shadow.y = 5;
			
			
			addGraphic(coin);
			addGraphic(baks);
			
			coin.centerOrigin();
			baks.centerOrigin();
			coin.smooth = true;
			baks.smooth = true;
			
			
			if (_id == 0) 
			{
				baks.visible = false;
			}
			if (_id == 1) 
			{
				coin.visible = false;
			}
			
			setHitbox(50, 50, 25, 25);
			type = "coin";
		}
		
		override public function update():void
		{
			super.update();
			this.layer = -y;
			
			this.timer++;
			if (timer > 300)
			{
				coin.alpha -= 0.2;
				baks.alpha -= 0.2;
			}
			
			var player:Player = collide("player", x, y) as Player
			if (player)
			{
				collected = true;
			}
			
			var magnet:PlayerBonus = collide("playerBonus", x, y) as PlayerBonus
			if (magnet)
			{
				moveTowards(Player.pos.x, Player.pos.y, 15);
			}
			
			if (collected)
			{
				shadow.alpha = 0;
				moveTowards(player.x, player.y, 15);
				if ((x == player.x) && (y == player.y))
				{
					coin.alpha -= 0.2;
					baks.alpha -= 0.2;
				}
			}
			
			if (coin.alpha <= 0)
			{
				FP.world.remove(this);
				if (collected) 
				{
					Settings.totalCoins += reward;
					FP.world.add(new TextEffect(3, Player.pos.x, Player.pos.y, "$" + String(reward)));
					moneySfx = new Sfx(SFX.money);
					moneySfx.play(Settings.sound * 0.8);
				}
			}
			
			
			if (coin.y > 0) 
			{
				shadow.visible = true;
				return
			}
			coin.y += amplit;
			baks.y += amplit;
			amplit += 1;
		}
	}

}