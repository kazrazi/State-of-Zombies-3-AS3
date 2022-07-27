package menu 
{
	import etc.GFX;
	import etc.SFX;
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
	public class WeapSlot extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.MENUWEAP, 155, 185);
		private var weap:Spritemap = new Spritemap(GFX.WEAP_ICONS, 160, 100);
		private var coin:Spritemap = new Spritemap(GFX.COIN, 40, 40);
		private var iconNew:Spritemap = new Spritemap(GFX.MENUICONS, 45, 45);
		private var iconClose:Spritemap = new Spritemap(GFX.MENUICONS, 45, 45);
		private var iconBuy:Spritemap = new Spritemap(GFX.MENUICONS, 45, 45);
		private var iconSlot:Spritemap = new Spritemap(GFX.MENUSLOT, 70, 70);
		public var id:int = 0;
		private var status:String = "open";
		private var nameText:FXText = new FXText("", -65, -90);
		private var priceText:FXText = new FXText("", -27, 43);
		private var outlineFX:GlowFX;
		
		private var weapBtn:WeapBtn;
		
		private var clickTrueSfx:Sfx = new Sfx(SFX.tone8);
		private var clickFalsSfx:Sfx = new Sfx(SFX.tone2);
		private var clickEquiSfx:Sfx = new Sfx(SFX.pickupAmmo);
		
		public function WeapSlot(_id:int = 0, _x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y;
			id = _id;
			
			addGraphic(image);
			addGraphic(weap);
			addGraphic(coin);
			addGraphic(nameText);
			addGraphic(priceText);
			
			image.centerOrigin();
			weap.centerOrigin();
			coin.centerOrigin();
			
			image.smooth = true;
			weap.smooth = true;
			coin.smooth = true;
			
			weap.angle = 25;
			weap.frame = id;
			weap.y = -8;
			weap.x = -5;
			if (id > 4) weap.scale = 0.9;
			
			coin.x = -50;
			coin.y = 60;
			coin.scale = 0.85;
			layer = -1990;
			
			nameText.text = Settings.weaponsXML.weapon.(@id == id).@name;
			nameText.size = 20;
			nameText.font = 'My Font'
			nameText.align = "center";
			nameText.color = 0xFFCC00;
			outlineFX = new GlowFX(5, 0x3B080F, 10, 1);
			nameText.effects.add(outlineFX);
			
			
			priceText.text = Settings.weaponsXML.weapon.(@id == id).@price;
			priceText.size = 25;
			priceText.font = 'My Font'
			priceText.align = "left";
			priceText.color = 0xFFCC00;
			priceText.effects.add(outlineFX);
			
			iconClose.frame = 0;
			iconBuy.frame = 1;
			iconNew.frame = 2;
			addGraphic(iconBuy);
			addGraphic(iconClose);
			addGraphic(iconNew);
			
			iconClose.x = -25;
			iconClose.y = -35;
			
			iconBuy.x = 30;
			iconBuy.y = -100;
			
			iconNew.x = -60;
			iconNew.y = -60;
			
			addGraphic(iconSlot);
			iconSlot.smooth = true;
			iconSlot.scale = 0.6;
			iconSlot.x = 22;
			iconSlot.y = 5;
			
			setHitbox(80, 80, 45, 50);
			type = "weapSlot";
		}
		
		override public function added():void
		{	
			weapBtn = new WeapBtn(click);
			FP.world.add(weapBtn);
			iconSlot.frame = int(Settings.weaponsXML.weapon.(@id == id).@slot);
			image.alpha = weap.alpha = coin.alpha = nameText.alpha = priceText.alpha = iconSlot.alpha = 0;
			iconBuy.visible = iconClose.visible = iconNew.visible = false;
		}
		
		private function checkStatus():void
		{
			////// проверка и добавление иконок
			if (status == "open") 
			{
				if (int(Settings.weaponsXML.weapon.(@id == id).@price) <= Settings.totalCoins)
				{
					iconBuy.visible = true;
				}
				else
				{
					iconBuy.visible = false;
				}
			}
			else
			{
				iconBuy.visible = false;
			}
			
			if (status == "closed")
			{
				iconClose.visible = true;
				if (int(Settings.weaponsXML.weapon.(@id == id).@level <= Settings.playerLevel))
				{
					iconNew.visible = true;
					coin.visible = true;
					Settings.weaponsXML.weapon.(@id == id).@status = "open";
				}
			}
			else
			{
				iconClose.visible = false;
			}
			
			
		}
		
		override public function update():void
		{
			weap.alpha = coin.alpha = iconSlot.alpha = nameText.alpha = priceText.alpha = image.alpha ;
			if (GameMenu.menuPanelReady)
			{
				image.alpha < 1? image.alpha += 0.2:image.alpha = 1;
				checkStatus();
			}
			
			weapBtn.x = x;
			weapBtn.y = y + 105;
			status = Settings.weaponsXML.weapon.(@id == id).@status;
			
			switch(status)
			{
				case "open":
					image.frame = 1;
					weap.color = 0xFFFFFF;
					
					priceText.text = Settings.weaponsXML.weapon.(@id == id).@price;
					priceText.x = -27
					priceText.color = 0xFFCC00;
					outlineFX.color = 0x3B080F;
					
					weapBtn.statusText.text = "buy";
					weapBtn.image.frame = 0;
					weapBtn.statusText.color = 0xFFCC00;
					weapBtn.outlineFX.color = 0x3B080F;
					weapBtn.statusText.x = -5;
				break;
				case "equipped":
					image.frame = 0;
					weap.color = 0xFFFFFF;
					coin.visible = false;
					
					priceText.text = "equipped";
					priceText.x = -60;
					priceText.color = 0x80FFFF;
					outlineFX.color = 0x002D2D;
					
					weapBtn.statusText.text = "ready";
					weapBtn.image.frame = 0;
					weapBtn.statusText.color = 0xEAEAEA;
					weapBtn.outlineFX.color = 0x333333;
					weapBtn.statusText.x = -20;
				break;
				case "acquired":
					image.frame = 1;
					weap.color = 0xFFFFFF;
					coin.visible = false;
					
					priceText.text = "acquired";
					priceText.x = -60;
					priceText.color = 0xFFCC00;
					outlineFX.color = 0x3B080F;
					
					weapBtn.statusText.text = "equip";
					weapBtn.image.frame = 0;
					weapBtn.statusText.color = 0xEAEAEA;
					weapBtn.outlineFX.color = 0x333333;
					weapBtn.statusText.x = -15;
				break;
				case "closed":
					image.frame = 2;
					weap.color = 0x000000;
					coin.visible = false;
					
					priceText.text = "level " + Settings.weaponsXML.weapon.(@id == id).@level;
					priceText.x = -50;
					priceText.color = 0xCCCCCC;
					outlineFX.color = 0x333333;
					
					weapBtn.statusText.text = "closed";
					weapBtn.image.frame = 1;
					weapBtn.statusText.color = 0xCCCCCC;
					weapBtn.outlineFX.color = 0x333333;
					weapBtn.statusText.x = -23;
				break;
			}
		}
		
		private function click():void
		{
			if (status == "open")
			{
				if (Settings.totalCoins - int(Settings.weaponsXML.weapon.(@id == id).@price) >= 0)
				{
					Settings.totalCoins = Settings.totalCoins - int(Settings.weaponsXML.weapon.(@id == id).@price);
					Settings.weaponsXML.weapon.(@id == id).@status = "acquired";
					
					clickTrueSfx.play(Settings.sound);
				}
				else
				{
					clickFalsSfx.play(Settings.sound);
				}
			}
			
			if (status == "acquired")
			{
				var slot:int = int(Settings.weaponsXML.weapon.(@id == id).@slot);
				for (var i:int = 0; i < Settings.weaponsXML.weapon.length(); i++)
				{
					if (Settings.weaponsXML.weapon[i].(@slot == slot).@status == "equipped") 
					Settings.weaponsXML.weapon[i].@status = "acquired";
					
					Settings.weaponsXML.weapon.(@id == id).@status = "equipped";
					
					clickEquiSfx.play(Settings.sound);
				}
			}
		}
	}

}