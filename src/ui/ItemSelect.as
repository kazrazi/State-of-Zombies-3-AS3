package ui 
{
	import etc.SFX;
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import etc.GFX;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXSpritemap;
	import units.Player;
	import net.flashpunk.utils.*;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ItemSelect extends Entity
	{
		private var circle:Spritemap = new Spritemap(GFX.WEAPSELECT, 200, 200);
		private var focus:Spritemap = new Spritemap(GFX.FOCUS, 1520, 880);
		private var focusEntity:Entity = new Entity();
		private var weapArray:Array = [];
		private var weapID:int;
		private var selectedID:int;
		private var iconArray:Array = [];
		
		public static var show:Boolean = false;
		private var setSfx:Sfx = new Sfx(SFX.tone4);
		public function ItemSelect() 
		{
			this.layer = -1500;
			setHitbox(10, 10, 5, 5);
			
			circle.alpha = 0;
			circle.scale = 0;
			circle.centerOrigin()
			circle.smooth = true;
		}
		
		override public function added():void
		{
			show = false;
			
			addGraphic(circle);
			weapArray = Player.itemArray;
			weapID = Player.itemID;
			selectedID = weapID;
			
			focusEntity.graphic = focus;
			focus.centerOrigin();
			focus.smooth = true;
			focus.alpha = 0;
			FP.world.add(focusEntity);
			
			for (var i:int = 0; i < weapArray.length; i++)
			{
				var weap:FXSpritemap = new FXSpritemap(GFX.ITEMICONS, 170, 170);
				var outlineFXBlue:GlowFX = new GlowFX(5, 0x66FFFF, 10, 3);
				var back:Spritemap = new Spritemap(GFX.WEAPSELECT, 200, 200);
				var line:Spritemap = new Spritemap(GFX.WEAPSELECT, 200, 200);
				var angle:int = 360 / weapArray.length;
				weap.centerOrigin();
				weap.smooth = true;
				weap.scale = 0.6;
				weap.frame = weapArray[i] + 3;
				weap.x = x + 70 * Math.cos((0 + angle * i) *  Math.PI / 180);
				weap.y = y - 70 * Math.sin((0 + angle * i) *  Math.PI / 180);
				weap.effects.add(outlineFXBlue);
				
				back.centerOrigin();
				back.smooth = true;
				back.scale = 0.65;
				back.x = weap.x;
				back.y = weap.y;
				back.frame = 1;
				back.visible = false;
				
				line.centerOrigin();
				line.smooth = true;
				line.scale = back.scale;
				line.x = weap.x;
				line.y = weap.y;
				line.frame = 4;
				line.visible = false;
				
				addGraphic(back);
				addGraphic(line);
				addGraphic(weap);
				
				iconArray[i] = [];
				iconArray[i].push(weap);
				iconArray[i].push(back);
				iconArray[i].push(angle * i);
				iconArray[i].push(weapArray[i]);
				iconArray[i].push(line);
				iconArray[i].push(outlineFXBlue);
			}
		}
		
		override public function update():void
		{
			super.update();
			x = Player.pos.x;
			y = Player.pos.y - 20;
			
			focusEntity.x = x;
			focusEntity.y = y;
			
			openMenu();
		}
		
		private function check():void
		{
			for (var i:int = 0; i < iconArray.length; i++)
			{
				var ang:int = -int(Math.atan2(FP.world.mouseY - y, FP.world.mouseX - x) * 180 / Math.PI);
				if (ang < 0) 
				{
					ang += 360;
				}
				
				iconArray[i][1].frame = 1;
				iconArray[i][5].strength = 0;
				if((ang>340)||(ang < 20))
				{
					iconArray[0][1].frame = 2;
					iconArray[0][5].strength = 5;
					selectedID = iconArray[0][3];
				}
				else
				if ((iconArray[i][2] > ang - 20) && (iconArray[i][2] < ang + 20))
				{
					iconArray[i][1].frame = 2;
					iconArray[i][5].strength = 5;
					selectedID = iconArray[i][3];
				}
			}
		}
		
		private function openMenu():void
		{
			if ((Input.check(Key.E)) && (GameUI.gameStatus != "gameover") && (!WeapSelect.show))
			{
				if (GameUI.gameStatus == "play") GameUI.gamePaused();
				show = true;
				focus.alpha < 1? focus.alpha += 0.2:focus.alpha = 1;
				circle.alpha += 0.15;
				circle.scale < 0.7? circle.scale += 0.2: circle.scale = 0.7;
				check();
				Player.powAngle = 0;
				Player.fireTimer = 0;
				
				for (var i:int = 0; i < iconArray.length; i++)
				{
					var totalAmmo:int = int(Settings.itemsXML.item.(@id == iconArray[i][0].frame-3).@max);
					var ammo:int = int(Settings.itemsXML.item.(@id == iconArray[i][0].frame-3).@count)
					var percent:int = ammo * 100 / totalAmmo;
					percent <= 0? iconArray[i][0].color =  0x333333:iconArray[i][0].color = 0xFFFFFF;
				}
			}
			else
			if(!WeapSelect.show)
			{
				if (GameUI.gameStatus == "paused") 
				{
					GameUI.gameResume();
					setSfx.play(Settings.sound * 0.5);
				}
				show = false;
				focus.alpha > 0? focus.alpha -= 0.2:focus.alpha = 0;
				circle.alpha -= 0.15;
				circle.scale > 0? circle.scale -= 0.2: circle.scale = 0;
				Player.itemID = selectedID;
			}
			for (var k:int = 0; k < iconArray.length; k++)
			{
				iconArray[k][1].frame == 2? iconArray[k][1].scale = 0.7: iconArray[k][1].scale = 0.6;
				iconArray[k][4].scale = iconArray[k][1].scale;
				
				iconArray[k][0].alpha = circle.alpha;
				iconArray[k][1].alpha = circle.alpha;
				iconArray[k][4].alpha = circle.alpha;
			}
		}
		
	}

}