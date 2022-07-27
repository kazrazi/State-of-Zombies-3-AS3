package ui 
{
	import adobe.utils.ProductManager;
	import etc.GFX;
	import etc.SFX;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXText;
	import units.Player;
	/**
	 * ...
	 * @author Darksider
	 */
	public class GameStatusBar extends Entity
	{
		private var back:Spritemap = new Spritemap(GFX.GAMESTATUSBG, 720, 480);
		private var focus:Spritemap = new Spritemap(GFX.FOCUS, 1520, 880);
		private var status:String = "pause";
		
		private var resumeGameBtn:GameStatusBtn;
		private var returnMenuBtn:GameStatusBtn;
		private var restarGameBtn:GameStatusBtn;
		private var nextGameBtn:GameStatusBtn;
		
		private var header:FXText = new FXText("", 240, 80);
		
		private var outlineFXYellow:GlowFX = new GlowFX(3, 0x935800, 7, 3);
		private var outlineFXBlack:GlowFX = new GlowFX(3, 0x151515, 7, 3);
		private var outlineFXRed:GlowFX = new GlowFX(3, 0x330504, 7, 3);
		
		private var showSfx:Sfx = new Sfx(SFX.tone7);
		
		private var brand:IZZYbrand = new IZZYbrand(360, 250, 0.7);
		
		public function GameStatusBar(_status:String = "pause") 
		{
			focus.centerOrigin();
			addGraphic(focus);
			addGraphic(back);
			this.layer = -1998;
			x = FP.camera.x;
			y = FP.camera.y;
			status = _status;
			focus.x = 360;
			focus.y = 240;
		}
		
		
		
		override public function added():void
		{
			FP.world.add(brand);
			
			showSfx.play(Settings.sound);
			header.size = 35;
			header.font = 'My Font'
			addGraphic(header);
			
			
			resumeGameBtn = new GameStatusBtn(resumeGame, 4);
			returnMenuBtn = new GameStatusBtn(returnMenu, 2);
			restarGameBtn = new GameStatusBtn(restarGame, 0);
			nextGameBtn = new GameStatusBtn(returnMenu, 4);
			
			switch(status)
			{
				case "pause":
					GameRoom.gamePaused();
					GameUI.gameStatus = "paused";
					
					FP.world.add(resumeGameBtn);
					resumeGameBtn.x = x + 460;
					resumeGameBtn.y = y + 400;
					
					FP.world.add(returnMenuBtn);
					returnMenuBtn.x = x + 260;
					returnMenuBtn.y = y + 400;
					
					header.color = 0xFFFFFF;
					header.text = "GAME PAUSED";
					header.effects.add(outlineFXBlack);
					header.x = 250;
				break;
				case "gameover":
					GameRoom.gamePaused();
					GameUI.gameStatus = "gameover";
					
					FP.world.add(restarGameBtn);
					restarGameBtn.x = x + 460;
					restarGameBtn.y = y + 400;
					
					FP.world.add(returnMenuBtn);
					returnMenuBtn.x = x + 260;
					returnMenuBtn.y = y + 400;
					
					header.color = 0xEA1B15;
					header.text = "DEFEAT";
					header.effects.add(outlineFXRed);
					header.x = 300;
				break;
				case "victory":
					GameRoom.gamePaused();
					GameUI.gameStatus = "victory";
					
					FP.world.add(nextGameBtn);
					nextGameBtn.x = x + 460;
					nextGameBtn.y = y + 400;
					
					header.color = 0xFFCC00;
					header.text = "LEVEL COMPLETE";
					header.effects.add(outlineFXYellow);
				break;
			}
		}
		
		override public function update():void
		{
			super.update();
			x = FP.camera.x;
			y = FP.camera.y;
			
		}
		
		private function resumeGame():void
		{
			GameRoom.gameResume();
			destroy();
		}
		
		private function returnMenu():void
		{
			if (GameUI.gameStatus == "victory") giveReward();
			FP.world = new GameMenu();
			destroy();
		}
		
		private function restarGame():void
		{
			FP.world = new GameRoom();
			destroy();
		}
		
		private function destroy():void
		{
			FP.world.remove(this);
			FP.world.remove(returnMenuBtn);
			FP.world.remove(resumeGameBtn);
			FP.world.remove(restarGameBtn);
			FP.world.remove(brand);
		}
		
		private function giveReward():void
		{
			Settings.currentLevel++;
		}
	}

}