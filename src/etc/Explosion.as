package etc 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Explosion extends Entity
	{
		private var typeExp:String = "";
		private var explode:Emitter;
		private var smokeArray:Array = [];
		private var smokeSpeed:Number = 10;
		
		private var flash:Spritemap = new Spritemap(GFX.EXPLOS, 100, 100);
		private var flashOrange:Spritemap = new Spritemap(GFX.EXPLOS, 100, 100);
		
		private var explodeSfx:Sfx = new Sfx(SFX.explos);
		
		public function Explosion(_x:int = 0, _y:int = 0, _typeExp:String="explos") 
		{
			x = _x;
			y = _y;
			typeExp = _typeExp;
			
			if (typeExp == "explos")
			{
				addGraphic(flashOrange);
				flashOrange.centerOrigin();
				flashOrange.scale = 0;
				flashOrange.frame = 1;
				flashOrange.originY = 90;
				flashOrange.smooth = true;
				flashOrange.y = 30;
				flashOrange.blend = "add";
			
				addGraphic(flash);
				flash.centerOrigin();
				flash.scale = 0;
				flash.smooth = true;
			}
		}
		
		override public function added():void
		{
			this.layer = -y;
			for (var i:int = 0; i < 10; i++)
			{
				var smokeEntity:Entity = new Entity(x, y);
				var smoke:Spritemap = new Spritemap(GFX.EXPLOS, 100, 100);
				smoke.centerOrigin();
				smokeEntity.graphic = smoke;
				smoke.smooth = true;
				
				var angle:int = 0 + i * 20;
				var layer:int = - y + Math.random() * 10;
				var scale:Number = Math.random() * 2 + 1;
				
				switch(typeExp)
				{
				case "explos":
					explodeSfx = new Sfx(SFX.explos);
					explodeSfx.play(Settings.sound * 0.2);
					
					smoke.frame = 12 + Math.random() * 2;
					if ((i == 2) || (i == 5) || (i == 8))
					{
						smoke.frame = 3;
						smoke.angle = angle-90;
						scale = 1;
						smoke.originY = 80;
					}
				break;
				case "smoke":
					explodeSfx = new Sfx(SFX.itemDestroy);
					explodeSfx.play(Settings.sound * 0.2);
					
					smoke.frame = 9 + Math.random() * 2;
				break;
				case "gas":
					smoke.frame = 6 + Math.random() * 2;
				break;
				}
				smokeArray[i] = [];
				
				smokeArray[i].push(smokeEntity);
				smokeArray[i].push(angle);
				smokeArray[i].push(layer);
				smokeArray[i].push(scale);
				
				FP.world.add(smokeArray[i][0]);
			}
			
			if (typeExp == "explos")
			{
				FP.world.add(new WorldObject(x, y, "risen"));
				FP.world.add(new Particle(x, y, true , "risen"));
				FP.world.add(new Particle(x, y, false , "risen2"));
				FP.world.add(new Particle(x, y, true , "risen2"));
				FP.world.add(new Particle(x, y, false , "risen"));
			}
		}
		
		override public function update():void
		{
			super.update();
			smokeUpdate();
			if (typeExp == "explos") updateExplos();
		}
		
		private function updateExplos():void
		{
			flashOrange.scale < 2? flashOrange.scale += 0.4:flashOrange.scale = 2;
			if (flashOrange.scale >= 2) flashOrange.alpha -= 0.2;
			if (flashOrange.alpha <= 0) flashOrange.visible = false;
			
			flash.scale < 2? flash.scale += 0.3: flash.visible = false;
			
		}
		
		private function smokeUpdate():void
		{
			smokeSpeed > 1 ? smokeSpeed -= 0.7:smokeSpeed = 1;
			for (var i:int = 0; i < smokeArray.length; i++)
			{
				if ((i == 2) || (i == 5) || (i == 8))
				{
					if (smokeSpeed == 1) smokeArray[i][0].graphic.alpha -= 0.2;
				}
				
				var radians:Number = -smokeArray[i][1] * Math.PI / 180;
				var vectorX:Number = Math.cos(radians);
				var vectorY:Number = Math.sin(radians);
				smokeArray[i][0].x += smokeSpeed * vectorX;
				smokeArray[i][0].y += smokeSpeed * vectorY;
				
				smokeArray[i][0].layer = smokeArray[i][2];
				
				if (smokeSpeed <= 3) smokeArray[i][0].graphic.alpha -= 0.02;
				smokeArray[i][0].graphic.scale < smokeArray[i][3]? smokeArray[i][0].graphic.scale += 0.2: smokeArray[i][0].graphic.scale = smokeArray[i][3];
				
				if (smokeArray[i][0].graphic.alpha <= 0) FP.world.remove(smokeArray[i][0]);
			}
			
			if (smokeArray[smokeArray.length-1][0].graphic.alpha <= 0) FP.world.remove(this);
		}
	}

}