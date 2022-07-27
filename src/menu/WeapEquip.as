package menu 
{
	import etc.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import punk.fx.effects.GlowFX;
	import punk.fx.graphics.FXSpritemap;
	/**
	 * ...
	 * @author Darksider
	 */
	public class WeapEquip extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.MENUSLOT, 70, 70);
		public var weap:FXSpritemap = new FXSpritemap(GFX.WEAP_ICONS, 160, 100);
		public var id:int = 0;
		private var outlineFX:GlowFX = new GlowFX(5, 0x000000, 5, 1);
		public function WeapEquip(_id:int = 0, _x:int = 0, _y:int = 0) 
		{
			x = _x;
			y = _y;
			id = _id;
			addGraphic(image);
			image.centerOrigin();
			image.frame = _id;
			
			addGraphic(weap);
			weap.smooth = true;
			weap.centerOrigin();
			weap.visible = false;
			weap.effects.add(outlineFX);
			
			setHitbox(40, 40, 20, 20);
			type = "weapEquip";
		}
		
		override public function added():void
		{
			image.alpha = weap.alpha = 0;
		}
		
		override public function update():void
		{
			super.update();
			
			weap.alpha = image.alpha;
			if (GameMenu.menuPanelReady)
			{
				image.alpha < 1? image.alpha += 0.2:image.alpha = 1;
			}
			
			for (var i:int = 0; i < Settings.weaponsXML.weapon.length(); i++)
			{
				if (Settings.weaponsXML.weapon[i].(@slot == String(id)).@status == "equipped")
				{
					weap.visible = true;
					weap.frame = i;
					weap.angle = 45;
					weap.frame > 4? weap.scale = 0.38:weap.scale = 0.5;
					if (weap.frame > 9) weap.scale = 0.45;
					
					image.frame = 6;
				}
			}
		}
		
	}

}