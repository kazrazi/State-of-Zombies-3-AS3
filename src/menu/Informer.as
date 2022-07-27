package menu 
{
	import etc.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXText;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Informer extends Entity
	{
		private var outlineFX:GlowFX = new GlowFX(5, 0x3B080F, 10, 1);
		private var textNavBtn:FXText = new FXText("", 0, 0);
		private var textItmBtn:FXText = new FXText("", 0, 0);
		private var textItmDis:FXText = new FXText("", 0, 0);
		
		private var textWeapName:FXText = new FXText("", 0, 0);
		private var textWeapDamage:FXText = new FXText("", 0, 0);
		private var textWeapSpeed:FXText = new FXText("", 0, 0);
		private var textWeapAmmo:FXText = new FXText("", 0, 0);
		
		private var textWeapDamageNum:FXText = new FXText("", 0, 0);
		private var textWeapSpeedNum:FXText = new FXText("", 0, 0);
		private var textWeapAmmoNum:FXText = new FXText("", 0, 0);
		
		private var itemBg:Spritemap = new Spritemap(GFX.MENUINFORM, 200, 200);
		private var weapBg:Spritemap = new Spritemap(GFX.MENUINFORM, 200, 200);
		
		public function Informer() 
		{
			setHitbox(10, 10, 5, -5);
			this.layer = -1999;
			
			weapBg.x = -160;
			weapBg.y = -40;
			weapBg.scale = 0.8;
			weapBg.scaleY = 0.85;
			weapBg.scaleX = 1;
			addGraphic(weapBg);
			
			itemBg.x = -160;
			itemBg.y = -40;
			itemBg.scale = 0.8;
			addGraphic(itemBg);
			
			// навигация
			textNavBtn.size = 20;
			textNavBtn.font = 'My Font';
			textNavBtn.color = 0xFFCC00;
			textNavBtn.effects.add(outlineFX);
			textNavBtn.smooth = true;
			addGraphic(textNavBtn);
			
			// итемы
			textItmBtn.size = 20;
			textItmBtn.font = 'My Font';
			textItmBtn.color = 0xFFCC00;
			textItmBtn.effects.add(outlineFX);
			textItmBtn.smooth = true;
			addGraphic(textItmBtn);
			
			textItmDis.size = 18;
			textItmDis.font = 'My Font';
			textItmDis.color = 0xFFFFFF;
			textItmDis.smooth = true;
			textItmDis.wordWrap = true;
			textItmDis.width = 150;
			addGraphic(textItmDis);
			
			// оружие
			textWeapName.size = 20;
			textWeapName.font = 'My Font';
			textWeapName.color = 0xD6DCE9;
			textWeapName.smooth = true;
			addGraphic(textWeapName);
			
			textWeapDamage.size = 16;
			textWeapDamage.font = 'My Font';
			textWeapDamage.color = 0xFFCC00;
			textWeapDamage.effects.add(outlineFX);
			textWeapDamage.smooth = true;
			addGraphic(textWeapDamage);
			
			textWeapSpeed.size = 16;
			textWeapSpeed.font = 'My Font';
			textWeapSpeed.color = 0xFFCC00;
			textWeapSpeed.effects.add(outlineFX);
			textWeapSpeed.smooth = true;
			addGraphic(textWeapSpeed);
			
			textWeapAmmo.size = 16;
			textWeapAmmo.font = 'My Font';
			textWeapAmmo.color = 0xFFCC00;
			textWeapAmmo.effects.add(outlineFX);
			textWeapAmmo.smooth = true;
			addGraphic(textWeapAmmo);
			
			
			// цифры
			textWeapDamageNum.size = 16;
			textWeapDamageNum.font = 'My Font';
			textWeapDamageNum.color = 0xFFFFFF;
			textWeapDamageNum.smooth = true;
			addGraphic(textWeapDamageNum);
			
			textWeapSpeedNum.size = 16;
			textWeapSpeedNum.font = 'My Font';
			textWeapSpeedNum.color = 0xFFFFFF;
			textWeapSpeedNum.smooth = true;
			addGraphic(textWeapSpeedNum);
			
			textWeapAmmoNum.size = 16;
			textWeapAmmoNum.font = 'My Font';
			textWeapAmmoNum.color = 0xFFFFFF;
			textWeapAmmoNum.smooth = true;
			addGraphic(textWeapAmmoNum);
		}
		
		override public function added():void
		{
			
		}
		
		override public function update():void
		{
			super.update();
			x = Input.mouseX;
			y = Input.mouseY;
			
			checkNavBtn();
			checkItemSlot();
			checkWeapSlot();
		}
		
		private function checkWeapSlot():void
		{
			var weapSlot:WeapSlot = collide("weapSlot", x, y) as WeapSlot
			var weapEquip:WeapEquip = collide("weapEquip", x, y) as WeapEquip
			textWeapDamage.x = textWeapSpeed.x = textWeapAmmo.x = textWeapName.x = -150;
			textWeapName.y = -35;
			textWeapSpeed.y = 30;
			textWeapAmmo.y = 60;
			
			textWeapDamageNum.y = 0;
			textWeapSpeedNum.y = 30;
			textWeapAmmoNum.y = 60;
			
			textWeapDamageNum.x = -60;
			textWeapSpeedNum.x = -60;
			textWeapAmmoNum.x = -60;
			
			var id:int;
			if (weapSlot) id = weapSlot.id;
			if (weapEquip) id = weapEquip.weap.frame;
			if ((weapSlot) || ((weapEquip) && (weapEquip.weap.visible)))
			{
				weapBg.visible = true;
				textWeapName.text = Settings.weaponsXML.weapon.(@id == id).@name;
				textWeapDamage.text = "damage:";
				textWeapSpeed.text = "f.rate:";
				textWeapAmmo.text = "ammo:";
				
				textWeapDamageNum.text = Settings.weaponsXML.weapon.(@id == id).@damage;
				textWeapSpeedNum.text = String(100 - int(Settings.weaponsXML.weapon.(@id == id).@spd) * 2);
				textWeapAmmoNum.text = Settings.weaponsXML.weapon.(@id == id).@ammo;
			}
			else
			{
				weapBg.visible = false;
				textWeapName.text = "";
				textWeapDamage.text = "";
				textWeapSpeed.text = "";
				textWeapAmmo.text = "";
				
				textWeapDamageNum.text = "";
				textWeapSpeedNum.text = "";
				textWeapAmmoNum.text = "";
			}
		}
		
		private function checkItemSlot():void
		{
			var itemSlot:ItemSlot = collide("itemSlot", x, y) as ItemSlot
			textItmBtn.y = -30;
			textItmBtn.x = -150;
			textItmDis.x = -150;
			
			if (itemSlot)
			{
				itemBg.visible = true;
				switch(itemSlot.id)
				{
					case 0:
						textItmBtn.text = "grenade";
						textItmDis.text = "It causes great damage to the enemy and environment";
					break;
					case 1:
						textItmBtn.text = "airstrike";
						textItmDis.text = "It calls for backup, and causes damage to the area around you";
					break;
					case 2:
						textItmBtn.text = "energy shield";
						textItmDis.text = "Protects your character from any damage during the short time";
					break;
					case 3:
						textItmBtn.text = "first aid";
						textItmDis.text = "Restores 50% health character";
					break;
					case 4:
						textItmBtn.text = "med chest";
						textItmDis.text = "Restores 100% health character";
					break;
					case 5:
						textItmBtn.text = "ammo chest";
						textItmDis.text = "Fully restores ammunition all weapons";
					break;
				}
			}
			else
			{
				itemBg.visible = false;
				textItmBtn.text = "";
				textItmDis.text = "";
			}
		}
		
		private function checkNavBtn():void
		{
			var navBtn:NavButton = collide("navBtn", x, y) as NavButton
			if (navBtn)
			{
				textNavBtn.x = -30;
				textNavBtn.y = -30;
				switch(navBtn.id)
				{
					case 0:
						textNavBtn.text = "Exit";
					break;
					case 1:
						textNavBtn.text = "Start";
					break;
					case 2:
						textNavBtn.text = "Characters";
					break;
					case 3:
						textNavBtn.text = "Weapons";
					break;
					case 4:
						textNavBtn.text = "Items";
					break;
					case 5:
						textNavBtn.text = "Achievments";
					break;
					case 6:
						textNavBtn.text = "More Games";
					break;
				}
			}
			else
			{
				textNavBtn.text = "";
			}
		}
		
	}

}