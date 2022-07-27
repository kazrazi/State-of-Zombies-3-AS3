package ui 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import etc.GFX;
	import net.flashpunk.FP;
	import units.Player;
	
	/**
	 * ...
	 * @author Darksider
	 */
	public class Cursor extends Entity
	{
		private var cursor:Spritemap = new Spritemap(GFX.CURSOR, 100, 100);
		public static var posX:int = 0;
		public static var posY:int = 0;
		public static var status:String = "hand";
		public function Cursor(_status:String = "hand") 
		{
			setHitbox(8, 8, 4, 4);
			type = "cursor";
			graphic = cursor;
			
			cursor.smooth = true;
			cursor.scale = 0.6;
			
			this.layer = -2000;
			status = _status;
		}
		
		override public function update():void
		{
			super.update();
			
			this.x = FP.world.mouseX;
			this.y = FP.world.mouseY;
			
			posX = x;
			posY = y;
			
			if(status=="hand")
			{
				Input.mouseDown? cursor.frame = 2:cursor.frame = 1;
				cursor.originX = originY = -5;
				cursor.scale = 0.6;
			}
			else
			{
				cursor.frame = 0;
				cursor.originX = cursor.originY = 50;
				Input.mouseDown? cursor.scale = 0.8:cursor.scale = 0.9;
			}
		}
	}

}