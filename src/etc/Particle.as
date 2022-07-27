package etc
{
	import flash.display.NativeMenu;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Darksider
	 */
	public class Particle extends Entity
	{
		private var image:Spritemap = new Spritemap(GFX.PARTICLE, 50, 50);
		private var startY:Number;
		private var bloodAmplit:Number;
		private var gilzAmplit:Number;
		private var distance:Number;
		private var speed:Number = 0;
		private var moveSpeedX:Number = 0;
		private var compleed:Boolean;
		private var timer:Number = 0;
		private var randomTimer:Number;

		private var typeEffect:String;
		private var flip:int = 1;
		
		public function Particle(_x:Number, _y:Number, _flip:Boolean, _type:String = null) 
		{
			image.centerOrigin();
			image.smooth = true;
			image.scale = 1;
			x = _x;
			y = _y;
			startY = y;
			_flip? flip = -1:flip = 1;
			randomTimer = Math.random() * 200;
			bloodAmplit = Math.random() * 10 + 5;
			gilzAmplit = Math.random() * 5 + 8;
			moveSpeedX = Math.random() * 6 + 2;
			typeEffect = _type;
			
			switch(typeEffect)
            {
				case "blood":
				    image.frame = 8;
                break;
				case "brain":
					image.frame = 0;
                break;
				case "meat":
					image.frame = 4
                break;
				case "pistol":
				    image.frame = 16;
                break;
				case "shootgun":
					image.frame = 17;
                break;
				case "riffle":
					image.frame = 18;
                break;
				case "risen":
					image.frame = 24 + Math.random() * 4;
                break;
				case "risen2":
					image.frame = 24 + Math.random() * 4;
                break;
				case "chip":
					image.frame = 20 + Math.random() * 4;
                break;
            }

			graphic = image;
			image.flipped = _flip;
		}
		
		override public function update():void
		{
			super.update();
			timer++;
			if (timer > randomTimer) image.alpha -= 0.1;
			if (image.alpha == 0) FP.world.recycle(this);
			
			if ((typeEffect == "blood") || (typeEffect == "meat") || (typeEffect == "brain"))
			{
				playAnimation1();
				return
			}
			
			if ((typeEffect == "pistol") || (typeEffect == "shootgun") || (typeEffect == "riffle"))
			{
				playAnimation2();
				return
			}
			
			if ((typeEffect == "risen") || (typeEffect == "risen2"))
			{
				playAnimation1();
				return
			}
			
			if (typeEffect == "chip")
			{
				playAnimation1();
				return
			}
		}
		
		// ГИЛЬЗЫ
		private function playAnimation2():void
		{
			var dy:Number = Math.floor( -Math.cos(speed) * gilzAmplit + y);
			this.layer = - y - 100;
			x += gilzAmplit / 2 * flip;
			image.angle -= 20 * flip;
			
			if (y > (startY + 30))
			{
				speed = 0.5;
				gilzAmplit -= 1;
				y += 0.4;
			}
			y = dy;
			speed += 0.15;
			if (gilzAmplit <= 3) FP.world.recycle(this);
		}
		
		// КРОВЬ
		private function playAnimation1():void
		{	
			var dy:Number = -Math.cos(speed) * bloodAmplit + y;
			
			if ((y > startY) && (y >= dy-10) && !compleed) 
			{
				this.layer = - y + 100;
				compleed = true;
				image.angle = 0;
				image.scale = 1;
				if (typeEffect == "blood") image.frame += Math.floor(Math.random() * 7 + 1);
				if (typeEffect == "brain") image.frame += Math.floor(Math.random() * 3 + 1);
				if (typeEffect == "meat") image.frame += Math.floor(Math.random() * 3 + 1);
			}
            if (!compleed) 
			{
				y = dy;
				x += moveSpeedX * flip;
				image.angle -= 6 * flip;
				this.layer = - y - 20;
				if (typeEffect == "blood") 
				{
					this.layer = - y - 100;
					image.scale = 0.8;
				}
			}
			speed += 0.2;
		}
		
	}

}