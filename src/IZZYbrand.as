package  
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	//Contextmenu imports
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;
	import net.flashpunk.utils.Input;
	import etc.GFX;
	/**
	 * ...
	 * @author ...
	 */
	public class IZZYbrand extends Entity
	{
		private var graph:Spritemap = new Spritemap(GFX.LOGO, 518, 145);
		private var myUrl:String = "http://armor.ag/MoreGames";
		private var reset:Boolean = false;
		public var posX:int = 0;
		public var posY:int = 0;
		public var scaleImg:Number = 1;
		
		public function IZZYbrand (_x:int = 0, _y:int = 0, _scaleImg:Number = 1,_type:String="normal") 
		{
			if (_type == "h")
			{
				graph = new Spritemap(GFX.hLOGO, 390, 117);
			}
			type = _type;
			
			x = _x;
			y = _y;
			posX = _x;
			posY = _y;
			graphic = graph;
			graph.smooth = true;
			graph.centerOrigin();
			this.layer = -1999;
			scaleImg = _scaleImg;
			graph.scale = scaleImg;
			setHitbox(graph.width * scaleImg, graph.height * scaleImg, graph.width * scaleImg / 2, graph.height * scaleImg / 2);
		}
		
		override public function update():void
		{
			super.update();
			graph.scrollX = graph.scrollY = 0;
			
			if (type == "h")
			{
				this.originX = posX - FP.camera.x - posX + 195 * scaleImg;
				this.originY = posY - FP.camera.y - posY + 59 * scaleImg;
			}
			else
			{
				this.originX = posX - FP.camera.x - posX + 259 * scaleImg;
				this.originY = posY - FP.camera.y - posY + 72 * scaleImg;
			}
			
			if (collide("cursor", x, y) )
            {
                if ((Input.mouseReleased) && (reset == false))
				{
					navigateToURL(new URLRequest(myUrl), "_blank");
					reset = true;
				}
            }
			else
			{
				reset = false;
			}
		}
		
		
		
	}

}