package 
{
	import etc.GFX;
	import etc.SFX;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import menu.ButtonCheck;
	import menu.Informer;
	import menu.ItemSlot;
	import menu.NavButton;
	import menu.PlayerSlot;
	import menu.WeapEquip;
	import menu.WeapSlider;
	import menu.WeapBtn;
	import menu.WeapSlideBtn;
	import menu.WeapSlot;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXSpritemap;
	import punk.fx.graphics.FXText;
	import ui.Cursor;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	//Contextmenu imports
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;
	import net.flashpunk.utils.Input;
	import etc.GFX;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Darksider
	 */
	public class GameMenu extends World
	{
		private var menuBack:FXSpritemap = new FXSpritemap(GFX.MENUBACK, 720, 480);
		private var menuBackMask:FXSpritemap = new FXSpritemap(GFX.MENUBACKMASK, 720, 480);
		private var menuBackMaskEntity:Entity = new Entity();
		private var menuPanel:Spritemap = new Spritemap(GFX.MENUPANEL, 720, 480);
		
		public static var playerLab:Spritemap = new Spritemap(GFX.PLAYERLAB, 200, 200);
		
		private var coin:FXSpritemap = new FXSpritemap(GFX.COIN, 40, 40);
		private var coinText:FXText = new FXText("", 70, 0);
		private var outlineFX:GlowFX = new GlowFX(5, 0x3B080F, 10, 1);
		
		private var levelText:FXText = new FXText("", 50, 380);
		
		public static var menuPanelReady:Boolean = false;
		public static var menuPanelSwitch:Boolean = false;
		public static var weaponsArray:Array = [];
		private var slider:WeapSlider = new WeapSlider(215, 280);
		
		private var music:Sfx = new Sfx(SFX.musicMenu);
		
		public static var gameSave:SharedObject;
		
		public function GameMenu() 
		{
			add(new Cursor("hand"));
			add(new Informer());
			addGraphic(menuBack);
			addGraphic(menuPanel);
			
			menuBackMaskEntity.graphic = menuBackMask;
			menuBackMaskEntity.layer = -1991;
			
			menuPanel.x = 720;
			
			weaponsArray = [];
			initWeaponsSlots();
			
			addGraphic(coin);
			coin.x = 30;
			
			levelText.size = 20;
			levelText.font = 'My Font'
			levelText.color = 0xFFCC00;
			levelText.effects.add(outlineFX);
			addGraphic(levelText);
			
			coinText.size = 30;
			coinText.font = 'My Font'
			coinText.color = 0xFFCC00;
			coinText.effects.add(outlineFX);
			addGraphic(coinText);
			
			menuPanelReady = false;
			menuPanelSwitch = false;
			
			addGraphic(playerLab, -1992, 15, 190);
			playerLab.smooth = true;
			playerLab.scale = 0.8;
			playerLab.color = 0x43B431;
		}
		
		override public function begin():void
		{
			loadGame();
			
			music.loop(Settings.music);
			
			FP.world.add(menuBackMaskEntity);
			
			FP.world.add(new NavButton(backMenu, 0, 40, 440));
			FP.world.add(new NavButton(startGame, 1, 680, 440));
			FP.world.add(new NavButton(showCharacters, 2, 210, 445));
			FP.world.add(new NavButton(showWeapons, 3, 310, 445));
			FP.world.add(new NavButton(showItems, 4, 410, 445));
			FP.world.add(new NavButton(moreGames, 6, 510, 445));
			
			FP.world.add(new ButtonCheck(600, 25, "sound"));
			FP.world.add(new ButtonCheck(670, 25, "music"));
			
			showWeapons();
			
			FP.world.add(new IZZYbrand(360, 20, 0.3));
		}
		
		public static function saveGame():void 
		{
            gameSave = SharedObject.getLocal("StateOfZombies3");
			gameSave.data.playerLevel = Settings.playerLevel as int;
			gameSave.data.playerExp = Settings.playerExp as int;
			gameSave.data.totalCoins = Settings.totalCoins as int;
			gameSave.data.weaponsXML = Settings.weaponsXML as XML;
			gameSave.data.itemsXML = Settings.itemsXML as XML;
			gameSave.data.currentLevel = Settings.currentLevel as int;
            gameSave.flush();
        }
      
        public static function loadGame():void 
		{
            gameSave = SharedObject.getLocal("StateOfZombies3");
            if (gameSave.data.playerExp == undefined) 
			{
                clearGameSave();
            }
            else 
			{
				Settings.playerLevel = gameSave.data.playerLevel;
				Settings.playerExp = gameSave.data.playerExp;
				Settings.totalCoins = gameSave.data.totalCoins;
				Settings.weaponsXML = gameSave.data.weaponsXML;
				Settings.itemsXML = gameSave.data.itemsXML;
				Settings.currentLevel = gameSave.data.currentLevel;
            }
        }
      
        public static function clearGameSave():void 
		{
            gameSave = SharedObject.getLocal("StateOfZombies3");
			gameSave.data.playerLevel = 1 as int;
			gameSave.data.playerExp = 0 as int;
			gameSave.data.totalCoins = 0 as int;
			gameSave.data.weaponsXML = Settings.weaponsXML;
			gameSave.data.itemsXML = Settings.itemsXML;
			gameSave.data.currentLevel = 1;
            gameSave.flush();
        }
		
		override public function end():void
		{
			music.stop();
			saveGame();
		}
		
		private function moreGames():void
		{
			navigateToURL(new URLRequest("http://armor.ag/MoreGames"), "_blank");
		}
		
		////////////////////////////////////// ВЫБОР ПЕРСОНАЖА /////////////////////////////////////////////////////
		////////// НАЧАЛО /////////////////////
		
		public function showCharacters():void
		{
			clearStage();
			menuPanelSwitch = true;
			
			FP.world.add(new PlayerSlot(245, 200, 1, "Chris"));
			FP.world.add(new PlayerSlot(375, 200, 2, "Claire"));
			FP.world.add(new PlayerSlot(505, 200, 3, "Barry"));
			FP.world.add(new PlayerSlot(635, 200, 4, "Lisa"));
		}
		
		/////////// КОНЕЦ //////////////////////
		/////////////////////////////////////// ВЫБОР ПЕРСОНАЖА ////////////////////////////////////////////////////
		
		/////////////////////////////////////// ПОКУПКА ОРУЖИЯ ////////////////////////////////////////////////////
		/////////// НАЧАЛО //////////////////////
		public function initWeaponsSlots():void
		{
			// сортируем оружие по уровню
			var sortArray:Array = [];
			for (var i:int = 0; i < Settings.weaponsXML.weapon.length(); i ++)
			{
				var _id:int = Settings.weaponsXML.weapon[i].@id;
				var _level:int = Settings.weaponsXML.weapon[i].@level;
				sortArray.push( { id:_id, level:_level } );
			}
			sortArray.sortOn(['level'], Array.NUMERIC);
			
			// добавляем в массив
			for (var j:int = 0; j < sortArray.length; j++)
			{
				weaponsArray[j] = new WeapSlot(sortArray[j].id, 250 + j * 150, 150);
			}
		}
		
		private function sliderRight():void
		{
			slider.x += 0.8;
		}
		
		private function sliderLeft():void
		{
			slider.x -= 0.8;
		}
		
		private function showWeapons():void
		{
			clearStage();
			menuPanelSwitch = true;
			for (var i:int = 0; i < weaponsArray.length; i++)
			{
				FP.world.add(weaponsArray[i]);
			}
			for (var j:int = 0; j < 6; j++)
			{
				FP.world.add(new WeapEquip(j, 250 + j * 74, 370));
			}
			
			FP.world.add(slider);
			FP.world.add(new WeapSlideBtn(205, 305, -0.2, sliderLeft));
			FP.world.add(new WeapSlideBtn(665, 305, 0.2, sliderRight));
		}
		/////////// КОНЕЦ //////////////////////
		/////////////////////////////////////// ПОКУПКА ОРУЖИЯ ////////////////////////////////////////////////////
		
		
		////////////////////////////////////// ПОКУПКА ИТЕМОВ /////////////////////////////////////////////////////
		////////// НАЧАЛО /////////////////////
		
		public function showItems():void
		{
			clearStage();
			menuPanelSwitch = true;
			var k:Number = 0;
			for (var i:int = 0; i < Settings.itemsXML.item.length(); i ++)
			{
				if (i > 2) k = 175;
				var itemID:int = Settings.itemsXML.item[i].@id;
				FP.world.add(new ItemSlot(itemID, 290 + i * 150 - k * 2.57, 145 + k));
			}
			
		}
		
		/////////// КОНЕЦ //////////////////////
		/////////////////////////////////////// ПОКУПКА ИТЕМОВ ////////////////////////////////////////////////////
		
		
		private function clearStage():void
		{
			menuBackMask.visible = false;
			var clear:Array = [];
			FP.world.getClass(WeapSlot, clear);
			FP.world.getClass(WeapBtn, clear);
			FP.world.getClass(WeapSlideBtn, clear);
			FP.world.getClass(WeapSlider, clear);
			FP.world.getClass(WeapEquip, clear);
			FP.world.getClass(ItemSlot, clear);
			FP.world.getClass(PlayerSlot, clear);
			for (var i:int = 0; i < clear.length; i++)
			{
				FP.world.remove(clear[i]);
			}
		}
		
		private function switchPanel():void
		{
			if ((menuPanelReady == false) && (menuPanelSwitch == false))
			{
				if (menuPanel.x > 70)
				{
					menuPanel.x -= 60;
				}
				else
				{
					menuPanel.x = 70;
					menuPanelReady = true;
					menuPanelSwitch = false;
				}
			}
			if (menuPanelSwitch == true)
			{
				menuPanelReady = false;
				if (menuPanel.x < 720)
				{
					menuPanel.x += 60;
				}
				else
				{
					menuPanelSwitch = false;
				}
			}
		}
		
		private function backMenu():void
		{
			FP.world = new StartMenu();
		}
		
		private function startGame():void
		{
			FP.world = new GameRoom();
		}
		
		override public function update():void
		{
			super.update();
			music.volume = Settings.music;
			
			coinText.text = String(Settings.totalCoins);
			levelText.text = "level: " + String(Settings.playerLevel);
			switchPanel();
			if (menuPanelReady) menuBackMask.visible = true;
			
			if (Input.pressed(Key.DIGIT_1)) Settings.playerLevel ++;
		}
		
	}

}