package 
{
	import etc.SFX;
	import flash.net.URLRequest;
	import menu.ButtonCheck;
	import net.flashpunk.Engine;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.World;
	import etc.GFX;
	import net.flashpunk.FP;
	import menu.Button;
	import ui.Cursor;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;
	/**
	 * ...
	 * @author Darksider
	 */
	public class StartMenu extends World
	{
		[Embed(source = "ui/LuckiestGuy.ttf", embedAsCFF = "false", fontFamily = "My Font")] private var font:Class;
		
		public static var background:Spritemap
		private var bg1:Spritemap = new Spritemap(GFX.BACKGROUND1, 720, 560);
		private var bg2:Spritemap = new Spritemap(GFX.BACKGROUND1, 720, 560);
		private var back1:Spritemap = new Spritemap(GFX.BACK1, 720, 560);
		private var gamename:Spritemap = new Spritemap(GFX.GAMENAME, 720, 480);
		
		private var facebookBtn:Button = new Button(gotoFacebook, 590, 430)
		
		private var music:Sfx = new Sfx(SFX.musicStart);
		private var voice:Sfx = new Sfx(SFX.startVoice);
		private var button:Sfx = new Sfx(SFX.startButton);
		
		private var playBtn:Button = new Button(playGame, 360, 360);
		private var start:Boolean = false;
		
		public function StartMenu() 
		{
			FP.screen.color = 0xFFFFFF;
		}
		
		override public function begin():void
		{
			music.loop(Settings.music)
			
			back1.scrollX = 0;
			FP.world.addGraphic(back1);
			FP.world.addGraphic(bg1);
			FP.world.addGraphic(bg2);
			FP.world.addGraphic(gamename);
			gamename.x = -10;
			gamename.alpha = 0;
			bg2.x = 720;
			
			FP.world.add(new Cursor("hand"));
			
			playBtn.setImage(GFX.PLAY_BTN, 170, 75, 0.8);
			FP.world.add(playBtn);
			
			FP.world.add(new ButtonCheck(50, 25, "sound"));
			FP.world.add(new ButtonCheck(120, 25, "music"));
			
			FP.world.add(new IZZYbrand(150, 430, 0.5, "h"));
			
			
			add(facebookBtn);
			facebookBtn.setImage(GFX.FACEBOOK, 1280, 452, 0.1);
		}
		
		private function gotoFacebook():void
		{
			navigateToURL(new URLRequest("http://www.facebook.com/ArmorGames"), "_blank");
		}
		
		override public function end():void
		{
			music.stop();
			button.stop();
		}
		
		private function playGame():void
		{
			if (!start)
			{
				start = true;
				button.play(Settings.sound);
				bg1.alpha = 0;
				bg2.alpha = 0;
				back1.alpha = 0;
				bg1.x = 0;
				bg2.x = 720;
			}
		}
		
		private function startUpdater():void
		{
			music.stop();
			FP.world.remove(playBtn);
			
			bg1.alpha = bg2.alpha = back1.alpha;
			back1.alpha < 1? back1.alpha += 0.05:back1.alpha = 1;
			
			if (Math.round(button.position)==1) 
			{
				voice.play(Settings.sound);
			}
			
			if (Math.round(button.position)==4) 
			{
				gamename.alpha -= 0.1;
			}
			
			if ((start) && (Math.round(button.position)==6)) FP.world = new GameMenu();
		}
		
		override public function update():void
		{
			super.update();
			
			music.volume = Settings.music;
			
			if (start) startUpdater();
			
			bg1.x <= -720? bg1.x = 720: bg1.x -= 0.5;
			bg2.x <= -720? bg2.x = 720: bg2.x -= 0.5;
			
			if (!start) gamename.alpha < 1? gamename.alpha += 0.2: gamename.alpha = 1;
		}
		
	}

}