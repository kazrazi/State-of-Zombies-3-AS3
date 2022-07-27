package ui 
{
	import etc.Coin;
	import etc.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import punk.fx.graphics.FXText;
	import units.Player;
	/**
	 * ...
	 * @author Darksider
	 */
	public class PlayerBonus extends Entity
	{
		private var timer:int = 500;
		public var id:int = 0;
		
		private var bonusBar:Entity = new Entity();
		private var bonusImage:Spritemap = new Spritemap(GFX.ITEMICONS, 170, 170);
		private var bonusBack:Spritemap = new Spritemap(GFX.BONUSBAR, 70, 70);
		
		private var timerText:FXText = new FXText("", 470, 40);
		
		public static var bonusArray:Array = [];
		
		public function PlayerBonus(_id:int = 0) 
		{
			id = _id;
			type = "playerBonus";
			
			timerText.size = 22;
			timerText.font = 'My Font'
			timerText.color = 0xFFFFFF;
		}
		
		override public function added():void
		{
			for (var i:int = 0; i < bonusArray.length; i++)
			{
				if (bonusArray[i].id == id) bonusArray[i].destroy();
			}
			
			bonusArray[bonusArray.length] = this;
			
			FP.world.add(bonusBar);
			bonusBar.addGraphic(bonusBack);
			bonusBar.addGraphic(bonusImage);
			bonusBar.addGraphic(timerText);
			
			bonusBack.centerOrigin();
			bonusBack.smooth = true;
			
			bonusImage.centerOrigin();
			bonusImage.smooth = true;
			bonusImage.scale = 0.6;
			bonusImage.frame = id + 6;
			
			bonusBack.scrollX = bonusBack.scrollY = bonusImage.scrollY = bonusImage.scrollX = 0;
			timerText.scrollX = timerText.scrollY = 0;
			
			bonusBar.layer = -1950;
		}
		
		override public function update():void
		{
			super.update();
			
			if (timer % 10 == 0) timerText.text = String(Math.floor(timer / FP.frameRate));
			
			var pos:int = 0;
			for (var i:int = 0; i < bonusArray.length; i++)
			{
				if (bonusArray[i].id == id) pos = i;
			}
			bonusBack.x = bonusImage.x = timerText.x = 670 - 70 * pos;
			bonusBack.y = bonusImage.y = timerText.y = 430;
			
			x = Player.pos.x;
			y = Player.pos.y;
			
			if (id == 3) speed();
			if (id == 4) magnet();
			if (id == 5) adrenaline();
			
			timer--;
			if (timer <= 0)
			{
				destroy();
			}
		}
		
		public function destroy():void
		{
			for (var i:int = 0; i < bonusArray.length; i++)
			{
				if (bonusArray[i].id == id) bonusArray.splice(i, 1);
			}
			
			FP.world.remove(this);
			FP.world.remove(bonusBar);
			if (id == 3) Player.walkBonus = 0;
			if (id == 5) Player.adrenBonus = 1;
		}
		
		private function magnet():void
		{
			setHitbox(400, 400, 200, 200);
		}
		
		private function speed():void
		{
			Player.walkBonus = 2;
		}
		
		private function adrenaline():void
		{
			Player.adrenBonus = 2;
		}
		
	}

}