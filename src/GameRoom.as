package 
{
	import etc.Helicopter;
	import etc.ItemsStreet;
	import etc.Particle;
	import etc.SFX;
	import flash.geom.Point;
	import items.Bonus;
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import punk.fx.graphics.FXText;
	import ui.Cursor;
	import ui.GameStatusBar;
	import ui.GameStatusBtn;
	import ui.GameUI;
	import ui.ItemSelect;
	import ui.WeapSelect;
	import units.Player;
	import etc.GFX;
	import units.Zombie;
	import net.flashpunk.utils.*;
	import units.ZombieBoss;
	/**
	 * ...
	 * @author Darksider
	 */
	public class GameRoom extends World
	{
		public static var background:Spritemap;
		private var background1:Spritemap = new Spritemap(GFX.BACKGROUND1, 720, 560);
		private var background2:Spritemap = new Spritemap(GFX.BACKGROUND2, 720, 560);
		private var background3:Spritemap = new Spritemap(GFX.BACKGROUND3, 720, 560);
		private var background4:Spritemap = new Spritemap(GFX.BACKGROUND4, 720, 560);
		private var back1:Spritemap = new Spritemap(GFX.BACK1, 720, 560);
		
		public static var cameraBlock:Point = new Point();
		private var music:Sfx = new Sfx(SFX.musicGame);
		
		private var stageText:FXText = new FXText("", 240, 340);
		private var stageEntity:Entity = new Entity(0, 0);
		
		private var waveArray:Array = [];
		private var waveTimer:int = 0;
		private var zombRang:int = 4;
		
		private var brand:IZZYbrand = new IZZYbrand(360, 60, 0.35,"h");
		
		public function GameRoom() 
		{
			
		}
		
		public static function gamePaused():void
		{
			GameUI.gameStatus = "paused";
			Player.canWalk = false;
			Zombie.canWalk = false;
			ZombieBoss.canWalk = false;
			var pauseArray:Array = [];
			var excepArray:Array = [];
			FP.world.getAll(pauseArray);
			FP.world.getClass(Cursor, excepArray);
			FP.world.getClass(GameStatusBar, excepArray);
			FP.world.getClass(GameStatusBtn, excepArray);
			
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
			GameUI.gameStatus = "play";
			Player.canWalk = true;
			Zombie.canWalk = true;
			ZombieBoss.canWalk = true;
			var pauseArray:Array = [];
			FP.world.getAll(pauseArray);
			for (var i:int = 0; i < pauseArray.length; i ++)
			{
				pauseArray[i].active = true;
			}
		}
		
		override public function begin():void
		{
			FP.world.add(brand);
			
			music.loop(Settings.music);
			FP.world.add(new Cursor("aim"));
			
			back1.scrollX = 0;
			FP.world.addGraphic(back1);
			
			zombRang += Settings.currentLevel;
			if (zombRang > 12) zombRang = 12;
			
			Settings.levelLenght = Settings.currentLevel + 3;
			if (Settings.levelLenght > 14) Settings.levelLenght = 14;
			for (var i:int = 0; i < Settings.levelLenght; i++)
			{
				background = background1;
				if (Settings.currentLevel > 4) background = background2;
				if (Settings.currentLevel > 9) background = background3;
				if (Settings.currentLevel > 15) background = background4;
				FP.world.addGraphic(background, 0, 0 + i * background.width, 0);
				FP.world.add(new ItemsStreet(Math.random() * 6, i * FP.width + (Math.random() * 2 + 1) * 100, Math.random() * 250 + 150));
				FP.world.add(new ItemsStreet(Math.random() * 6, i * FP.width + (Math.random() * 2 + 3) * 100, Math.random() * 250 + 150));
				FP.world.add(new ItemsStreet(Math.random() * 6, i * FP.width + (Math.random() * 2 + 6) * 100, Math.random() * 250 + 150));
				
				var rand:int = Math.round(Math.random() * 6);
				if (rand == 3) FP.world.add(new ItemsStreet(7, i * FP.width + (Math.random() * 2 + 0) * 100, Math.random() * 250 + 150));
			}
			cameraBlock.x = Settings.levelLenght * background.width - FP.width - 10;
			cameraBlock.y = background.height - FP.height;
			FP.world.add(new Player(300, 300, Settings.playerID));
			FP.world.add(new Helicopter((Settings.levelLenght - 1) * 720, 0));
			
			stageText.size = 60;
			stageText.font = 'My Font'
			stageText.color = 0xFFFFFF;
			stageText.text = "Stage: " + Settings.currentLevel;
			stageText.scrollX = stageText.scrollY = 0;
			stageEntity.addGraphic(stageText);
			stageEntity.layer = -1600;
			add(stageEntity);
			
			generateWaves();
			
		}
		
		override public function end():void
		{
			music.stop();
			GameMenu.saveGame();
		}
		
		private function generateWaves():void
		{
			var waveCount:int = Settings.levelLenght * 3;
			for (var i:int = 0; i < waveCount; i++)
			{
				waveArray[i] = new Array();
				waveArray[i].push(i * 240 + 450); // дистанция появления
				waveArray[i].push(2 * int(Settings.currentLevel / 2) + 2); // колличество зомби
				waveArray[i].push("false"); // статус
			}
			
		}
		
		private function addZombies(_count:int = 0):void
		{
			if (_count > 20) _count = 20;
			for (var i:int = 0; i < _count; i++)
			{
				FP.world.add(new Zombie(Player.pos.x + (Math.round(Math.random() * 10)) * 100 + 100, Math.random() * 260 + 200, int(Math.random() * zombRang)));
			}
			
			var randBoss:int = 1;
			if (Settings.currentLevel > 2) randBoss = Math.random() * 10;
			if (Settings.currentLevel > 5) randBoss = Math.random() * 7;
			if (Settings.currentLevel > 7) randBoss = Math.random() * 5;
			if (Settings.currentLevel > 10) randBoss = Math.random() * 3;
			if (Settings.currentLevel > 13) randBoss = Math.random() * 2;
			if (Settings.currentLevel > 16) randBoss = Math.random() * 1;
			if ((Settings.currentLevel > 1) && (randBoss == 0))
			{
				var randID:int = 0;
				if (Settings.currentLevel > 3) randID = 1;
				if (Settings.currentLevel > 5) randID = 2;
				if (Settings.currentLevel > 7) randID = 3;
				if (Settings.currentLevel > 10) randID = 4;
				FP.world.add(new ZombieBoss(Player.pos.x + 900, Math.random() * 260 + 200, int(Math.random() * randID + 1)));
			}
		}
		
		override public function update():void
		{
			super.update();
			FP.world.autoClear = true;
			
			if (Player.pos.x > 400) stageText.alpha -= 0.2;
			if (stageText.alpha <= 0) FP.world.remove(stageEntity);
			
			waveTimer++;
			if (waveTimer > 10)
			{
				waveTimer = 0;
				for (var i:int = 0; i < waveArray.length; i++)
				{
					if ((Player.pos.x>waveArray[i][0]) && (waveArray[i][2] == "false"))
					{
						waveArray[i][2] = "true";
						addZombies(waveArray[i][1]);
					}
				}
			}
			
			if (Input.released(Key.P)) 
			{
				if (GameUI.gameStatus == "play") FP.world.add(new GameStatusBar("pause"));
			}
			
			if (GameUI.gameStatus == "play")
			{
				brand.graphic.visible = true;
			}
			else
			{
				brand.graphic.visible = false;
			}
		}
		
	}

}