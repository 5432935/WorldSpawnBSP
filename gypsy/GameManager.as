package gypsy
{
	import away3d.containers.View3D;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import gypsy.io.core.EventCore;
	import gypsy.io.LoadAssets;
	
	import gypsy.models.bsp.BSPWorld;
	/**
	 * ...
	 * @author OneMadGypsy
	 */
	public class GameManager extends EventCore
	{	private static var view:View3D;
		private static var lib:LoadAssets;
		private static var _world:BSPWorld;
		
		private static var camval:Number;
		private static var oldcam:Number;
	
		public function GameManager():void;
		
		/**
		 * 
		 * @param	game
		 */
		public function initGame(game:String):void
		{
			lib = new LoadAssets();
			lib.addEventListener(Event.COMPLETE, handler);
			lib.addEventListener(IOErrorEvent.IO_ERROR, handler);
			lib.addEventListener(ProgressEvent.PROGRESS, handler);
			lib.load(game);
		}
		
		/**
		 * 
		 * @param	event
		 */
		protected override function handler(event:*):void
		{
			switch(event.type)
			{
				case Event.COMPLETE:
					dropListeners(event.target);
					if(!_world)
					{		
						_world = new BSPWorld();
						
						_world.addEventListener(Event.COMPLETE, handler);
						_world.init(lib.assets);
					} else {
						
						view = WorldSpawn.view;
						dispatchEvent(new Event(Event.COMPLETE));
					}
					break;
				case IOErrorEvent.IO_ERROR:
					break;
				case ProgressEvent.PROGRESS:
					break;
			}
		}
		
		public function get player_origin():Array {
			var player:Object = _world.findEntityByClassname("info_player_start");
			return player.origin;
		}
		
		public function get player_angle():Number {
			var player:Object = _world.findEntityByClassname("info_player_start");
			return player.angle;
		}
		
		public function get world():BSPWorld {
			return _world;
		}
		
		public function renderTick():void
		{	
		}
	}	
}