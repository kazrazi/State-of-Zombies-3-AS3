package menu 
{
	import etc.GFX;
	import etc.SFX;
	import mx.core.FlexTextField;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXText;
	/**
	 * ...
	 * @author Darksider
	 */
	public class ItemSlot extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.MENUWEAP, 155, 185);
		private var item:Spritemap = new Spritemap(GFX.ITEMICONS, 170, 170);
		private var coin:Spritemap = new Spritemap(GFX.COIN, 40, 40);
		private var priceText:FXText = new FXText("", -35, -91)
		private var countText:FXText = new FXText("", 30, 5);
		private var outlineFX:GlowFX;
		
		public var id:int = 0;
		private var weapBtn:WeapBtn;
		
		private var clickTrueSfx:Sfx = new Sfx(SFX.tone8);
		private var clickFalsSfx:Sfx = new Sfx(SFX.tone2);
		
		public function ItemSlot(_id:int = 0, _x:int = 0, _y:int = 0) 
		{
			id = _id;
			x = _x;
			y = _y;
			
			addGraphic(image);
			image.smooth = true;
			image.centerOrigin();
			image.scale = 1;
			image.frame = 0;
			
			addGraphic(item);
			item.smooth = true;
			item.centerOrigin();
			item.scale = 0.7;
			item.frame = id + 3;
			item.x = - 3;
			item.y = - 10;
			
			addGraphic(coin);
			coin.smooth = true;
			coin.centerOrigin();
			coin.scale = 0.7;
			coin.x = -55;
			coin.y = -76;
			
			addGraphic(priceText);
			priceText.text = Settings.itemsXML.item.(@id == id).@price;
			priceText.size = 22;
			priceText.font = 'My Font'
			priceText.align = "left";
			priceText.color = 0xFFCC00;
			outlineFX = new GlowFX(5, 0x3B080F, 10, 1);
			priceText.effects.add(outlineFX);
			
			addGraphic(countText);
			countText.size = 30;
			countText.font = 'My Font'
			countText.align = "left";
			countText.color = 0xFFCC00;
			countText.effects.add(outlineFX);
			
			type = "itemSlot";
			setHitbox(80, 80, 40, 55);
		}
		
		override public function added():void
		{
			weapBtn = new WeapBtn(click);
			FP.world.add(weapBtn);
			weapBtn.x = x-1;
			weapBtn.y = y + 62;
			
			image.alpha = item.alpha = coin.alpha = countText.alpha = priceText.alpha = 0;
		}
		
		override public function update():void
		{
			super.update();
			item.alpha = coin.alpha = countText.alpha = priceText.alpha = image.alpha;
			if (GameMenu.menuPanelReady)
			{
				image.alpha < 1? image.alpha += 0.2:image.alpha = 1;
			}
			
			countText.text = Settings.itemsXML.item.(@id == id).@count;
			
			if (int(countText.text) > 0)
			{
				image.frame = 0;
			}
			else
			{
				image.frame = 1;
			}
			
			var max:int = Settings.itemsXML.item.(@id == id).@max;
			if (int(countText.text) < max)
			{
				weapBtn.statusText.text = "buy";
				weapBtn.statusText.x = -5;
				weapBtn.image.frame = 0;
			}
			else
			{
				weapBtn.statusText.text = "max";
				weapBtn.statusText.x = -5;
				weapBtn.image.frame = 2;
			}
			
		}
		
		private function click():void
		{
			if (Settings.totalCoins - int(priceText.text) >= 0)
			{
				if (weapBtn.statusText.text != "max")
				{
					Settings.totalCoins -= int(priceText.text);
					Settings.itemsXML.item.(@id == id).@count = String(int(Settings.itemsXML.item.(@id == id).@count) + 1);
					
					clickTrueSfx = new Sfx(SFX.tone8);
					clickTrueSfx.play(Settings.sound);
				}
				else
				{
					clickFalsSfx.play(Settings.sound);
				}
			}
			else
			{
				clickFalsSfx.play(Settings.sound);
			}
		}
		
	}

}