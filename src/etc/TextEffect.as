package etc 
{
	import flash.text.TextField;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXText;
	import units.Player;
	/**
	 * ...
	 * @author Darksider
	 */
	public class TextEffect extends Entity
	{
		private var id:int = 0;
		private var text:String = "";
		private var textField:FXText = new FXText("", 0, 0);
		private var outlineFX:GlowFX = new GlowFX(5, 0x3B080F, 10, 1);
		
		public function TextEffect(_id:int = 0, _x:int = 0, _y:int = 0, _text:String ="") 
		{
			id = _id;
			x = _x;
			y = _y;
			
			textField.text = _text;
			textField.font = 'My Font';
			switch(id)
			{
				case 0: // левел ап
					textField.size = 25;
					textField.color = 0xFFCC00;
					outlineFX = new GlowFX(5, 0x3B080F, 10, 1);
				break;
				case 1: // лечение
					textField.size = 20;
					textField.color = 0xFF0000;
					outlineFX = new GlowFX(5, 0x2B0000, 10, 1);
				break;
				case 2: // патроны, бонусы и щит
					textField.size = 20;
					textField.color = 0x77EDFF;
					outlineFX = new GlowFX(5, 0x02202B, 10, 1);
				break;
				case 3: // деньги
					textField.size = 18;
					textField.color = 0xFFCC00;
					outlineFX = new GlowFX(2, 0x3B080F, 7, 3);
				break;
			}
			
			textField.effects.add(outlineFX);
			textField.smooth = true;
			textField.scale = 0;
			addGraphic(textField);
			
			this.layer = -1600;
		}
		
		override public function update():void
		{
			super.update();
			textField.centerOrigin();
			textField.y > -100? textField.y -= 5: textField.y = -100;
			textField.scale < 1.3? textField.scale += 0.1:textField.scale = 1.3;
			textField.y == -100? textField.alpha -= 0.1: textField.alpha = 1;
			if (textField.alpha <= 0) FP.world.remove(this);
			
			x = Player.pos.x;
			y = Player.pos.y;
		}
		
	}

}