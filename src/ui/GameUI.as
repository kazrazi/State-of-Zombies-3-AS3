package ui 
{
	import flash.filters.GlowFilter;
	import items.Shield;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import etc.GFX;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXSpritemap;
	import punk.fx.graphics.FXText;
	import units.Player;
	import net.flashpunk.utils.*;
	import units.Zombie;
	import units.ZombieBoss;
	/**
	 * ...
	 * @author Darksider
	 */
	public class GameUI extends Entity
	{
		private var gameUI:Spritemap = new Spritemap(GFX.GUI, 720, 480);
		
		private var healthLine:Spritemap = new Spritemap(GFX.HEALTHLINE, 100, 20);
		private var healthGrid:Spritemap = new Spritemap(GFX.HEALTHGRID, 110, 30);
		
		private var powerLine:Spritemap = new Spritemap(GFX.POWERLINE, 100, 20);
		private var powerGrid:Spritemap = new Spritemap(GFX.HEALTHGRID, 110, 30);
		
		private var expLine:Spritemap = new Spritemap(GFX.EXPLINE, 197, 17);
		
		private var weap:FXSpritemap = new FXSpritemap(GFX.WEAP_ICONS, 160, 100);
		private var item:FXSpritemap = new FXSpritemap(GFX.ITEMICONS, 170, 170);
		private var face:Spritemap = new Spritemap(GFX.PLAYER1_BODY, 100, 100);
		private var hair:Spritemap = new Spritemap(GFX.PLAYER1_BODY, 100, 200);
		
		private var distance:Spritemap = new Spritemap(GFX.DISTANCE, 150, 50);
		private var distText:FXText = new FXText("1000m", 70, 131);
		
		private var outlineFXBlue:GlowFX = new GlowFX(5, 0xB9FFFF, 10, 3);
		private var outlineFXYellow:GlowFX = new GlowFX(2, 0x935800, 7, 3);
		private var outlineFXBlack:GlowFX = new GlowFX(2, 0x151515, 10, 3);
		private var outlineFXBlue2:GlowFX = new GlowFX(5, 0xB9FFFF, 10, 3);
		
		private var ammo:FXText = new FXText("", 470, 40);
		private var itemsText:FXText = new FXText("", 80, 405);
		private var coin:FXText = new FXText("", 330, 6);
		private var expText:FXText = new FXText("", 280, 445);
		private var playerLvl:FXText = new FXText("", 140, 0);
		
		public static var gameStatus:String = "play";
		
		public function GameUI(_id:int = 1) 
		{
			switch(_id)
			{
				case 1:
					face = new Spritemap(GFX.PLAYER1_BODY, 100, 100);
					hair = new Spritemap(GFX.PLAYER1_BODY, 100, 200);
				break;
				case 2:
					face = new Spritemap(GFX.PLAYER2_BODY, 100, 100);
					hair = new Spritemap(GFX.PLAYER2_BODY, 100, 200);
				break;
				case 3:
					face = new Spritemap(GFX.PLAYER3_BODY, 100, 100);
					hair = new Spritemap(GFX.PLAYER3_BODY, 100, 200);
				break;
				case 4:
					face = new Spritemap(GFX.PLAYER4_BODY, 100, 100);
					hair = new Spritemap(GFX.PLAYER4_BODY, 100, 200);
				break;
			}
			
			this.layer = -1950;
			addGraphic(gameUI);
			addGraphic(healthLine);
			addGraphic(healthGrid);
			addGraphic(powerLine);
			addGraphic(powerGrid);
			addGraphic(expLine);
			addGraphic(hair);
			addGraphic(face);
			addGraphic(weap);
			addGraphic(ammo);
			addGraphic(coin);
			addGraphic(item);
			addGraphic(itemsText);
			addGraphic(expText);
			addGraphic(playerLvl);
			addGraphic(distance);
			
			distText.size = 17;
			distText.font = 'My Font'
			distText.color = 0xFFFFFF;
			distText.align = "left";
			addGraphic(distText);
			distText.scrollX = distText.scrollY = 0;
			
			ammo.size = 22;
			ammo.font = 'My Font'
			ammo.color = 0xFFFFFF;
			ammo.text = String("000" + " / " +"000");
			ammo.align = "right";
			
			coin.size = 22;
			coin.font = 'My Font'
			coin.color = 0xFFE377;
			coin.effects.add(outlineFXYellow);
			
			playerLvl.size = 22;
			playerLvl.font = 'My Font'
			playerLvl.align = "left";
			
			itemsText.size = 30;
			itemsText.font = 'My Font'
			itemsText.color = 0xFFFFFF;
			itemsText.effects.add(outlineFXBlack);
			
			expText.size = 20;
			expText.font = 'My Font'
			expText.color = 0xFFFFFF;
			expText.align = "left";
			
			distance.x = 0;
			distance.y = 120;
			
			healthLine.x = 155;
			healthLine.y = 45;
			
			healthGrid.x = 150;
			healthGrid.y = 40;
			
			powerLine.x = 155;
			powerLine.y = 80;
			
			powerGrid.x = 150;
			powerGrid.y = 75;
			
			expLine.x = 262;
			expLine.y = 451;
			
			face.smooth = true;
			face.centerOrigin();
			face.x = 75;
			face.y = 65;
			face.flipped = true;
			
			hair.smooth = true;
			hair.centerOrigin();
			hair.x = face.x;
			hair.y = face.y;
			hair.flipped = true;
			hair.frame = 6;
			hair.originY = 50;
			
			weap.centerOrigin();
			weap.smooth = true;
			weap.x = 655;
			weap.y = 65;
			weap.angle = 45;
			weap.scale = 0.7;
			weap.effects.add(outlineFXBlue);
			
			item.centerOrigin();
			item.smooth = true;
			item.x = 70;
			item.y = 412;
			item.scale = 0.6;
			item.effects.add(outlineFXBlue2);
			
			gameUI.scrollX = gameUI.scrollY = 0;
			healthLine.scrollX = healthLine.scrollY = 0;
			healthGrid.scrollX = healthGrid.scrollY = 0;
			powerLine.scrollX = powerLine.scrollY = 0;
			powerGrid.scrollX = powerGrid.scrollY = 0;
			expLine.scrollX = expLine.scrollY = 0;
			weap.scrollX = weap.scrollY = 0;
			item.scrollX = item.scrollY = 0;
			hair.scrollX = hair.scrollY = 0;
			face.scrollX = face.scrollY = 0;
			ammo.scrollX = ammo.scrollY = 0;
			coin.scrollX = coin.scrollY = 0;
			itemsText.scrollX = itemsText.scrollY = 0;
			expText.scrollX = expText.scrollY = 0;
			playerLvl.scrollX = playerLvl.scrollY = 0;
			distance.scrollX = distance.scrollY = 0;
		}
		
		override public function added():void
		{
			gameStatus = "play";
		}
		
		override public function update():void
		{
			super.update();
			
			var dist:int = Settings.levelLenght * 720 - Player.pos.x - 320;
			if (dist < 0) dist = 0;
			distText.text = String(dist)+"m";
			
			weap.frame = Player.weapID;
			item.frame = Player.itemID + 3;
			item.frame == 5? outlineFXBlue2.strength = 0 : outlineFXBlue2.strength = 5;
			var count:int = int(Settings.itemsXML.item.(@id == Player.itemID).@count);
			itemsText.text = String(count);
			count == 0? item.color = 0x333333: item.color = 0xFFFFFF;
			
			
			if (Player.currentHealth > Player.totalHealth) Player.currentHealth = Player.totalHealth;
			healthLine.scaleX = Player.currentHealth / Player.totalHealth;
			
			if (FP.world.classCount(Shield) > 0)
			{
				powerLine.scaleX = Shield.power / Shield.totalHealth;
			}
			else
			{
				powerLine.scaleX = 0
			}
			
			var playerlevel:Number = Settings.playerLevel
			var playerexp:Number = Settings.playerExp
			var needexp:Number = Settings.playerLevels[playerlevel - 1];
			var p1:int = playerexp - Settings.playerLevels[playerlevel - 2];
			var p2:int = needexp - Settings.playerLevels[playerlevel - 2];
			if (playerlevel == 1) 
			{
				p1 = playerexp;
				p2 = needexp;
			}
			expLine.scaleX = p1 / p2 ;
			if (expLine.scaleX < 0) expLine.scaleX = 0;
			expText.text = "exp: " + String(p1) + " / " + String(p2);
			playerLvl.text = "lvl :" +String(playerlevel);
			
			
			face.frame = Player.head.frame;
			if (Player.currentHealth <= 0) healthLine.scaleX = 0;
			
			coin.text = String(Settings.totalCoins);
			coin.align = "left";
			
			ammo.text = String(Player.ammoArray[Player.weapID][0] + " / " +Player.ammoArray[Player.weapID][1]);
			ammo.align = "right";
			
		}
		
		public static function gamePaused():void
		{
			Player.canWalk = false;
			Zombie.canWalk = false;
			ZombieBoss.canWalk = false;
			gameStatus = "paused";
			var pauseArray:Array = [];
			var excepArray:Array = [];
			FP.world.getAll(pauseArray);
			FP.world.getClass(WeapSelect, excepArray);
			FP.world.getClass(ItemSelect, excepArray);
			FP.world.getClass(Player, excepArray);
			FP.world.getClass(Cursor, excepArray);
			
			for (var i:int = 0; i < pauseArray.length; i ++)
			{
				pauseArray[i].active = false;
				for (var j:int = 0; j < excepArray.length; j++)
				{
					if (pauseArray[i] == excepArray[j]) pauseArray[i].active = true;
				}
			}
		}
		
		public static function gameResume():void
		{
			Player.canWalk = true;
			Zombie.canWalk = true;
			ZombieBoss.canWalk = true;
			gameStatus = "play";
			var pauseArray:Array = [];
			FP.world.getAll(pauseArray);
			for (var i:int = 0; i < pauseArray.length; i ++)
			{
				pauseArray[i].active = true;
			}
		}
		
	}

}