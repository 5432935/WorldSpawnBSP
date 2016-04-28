package gypsy.io
{
	import away3d.materials.TextureMaterial;
	import flash.utils.ByteArray;
	import gypsy.io.core.EventCore;
	import flash.display.BitmapData;
	import flash.display.Loader;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipLibrary;
	import deng.fzip.FZipFile;
	
	import away3d.textures.ATFTexture;
	/**
	 * ...
	 * @author OneMadGypsy
	 */
	public class LoadAssets extends EventCore 
	{
		private static var fzip:FZip;
		private static var fzipLib:FZipLibrary;
		private static var zfile:FZipFile;
		private static var req:URLRequest;
		private static var xml:XML;
		private static var $_textures:Object;
		
		private static var cworld:uint = 0;
		private static var _assets:Object;
		private static var _cnt:int = 0;
		
		/**
		 * 
		 * @param	url
		 */
		public function LoadAssets(url:String = ""):void 
		{	if (url.length) load(url);
		}
		
		/**
		 * 
		 * @param	url
		 */
		public function load(url:String):void
		{
			fzipLib = new FZipLibrary();
			fzipLib.formatAsBitmapData(".gif");
			fzipLib.formatAsBitmapData(".jpg");
			fzipLib.formatAsBitmapData(".png");
			fzipLib.formatAsDisplayObject(".swf");
			addListeners(fzipLib);
			fzip = new FZip();
			req = new URLRequest(url);
			fzip.load(req);
			fzipLib.addZip(fzip);
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
					read_manifest();
					break;
				case IOErrorEvent.IO_ERROR:
					break;
				case ProgressEvent.PROGRESS:
					break;
			}
			
			//super.handler(event);
		}
		
		private function read_manifest():void
		{	var length:uint, n:int, i:int;
			var dir:String, world:XML;
			var name:String;
		
			xml = new XML(find_zfile("manifest.xml"));
			_assets = new Object();
			
			dir 	= xml.dir.@maps;							//get map directory
			world	= xml.world[cworld];						//get current world descriptor
			_assets.world = find_zfile(dir + world.@map);		//concat path/file
			
			length = world.ent.length()
			if (length)
			{	
				_assets.entities = new Object();
				dir = xml.dir.@mdl;								//get mdl directory
				n = -1;	//prime
				while (length - (++n))
				{	i = world.ent[n].@id.lastIndexOf(".");
					_assets.entities[world.ent[n].@id.substr(0,i)] = find_zfile(dir + world.ent[n].@id)
				}
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public static function ATFFromZFile(name:String, path:String):ByteArray
		{
			name = "game/" + path + "/" + name.replace(/\*/, "#") + ".atf";
			var n:int = -1;	//prime
			while (fzip.getFileCount() - (++n))
			{	zfile = fzip.getFileAt(n);
				if (zfile.filename == name)
					return zfile.content;
			}
			return null;
		}
		
		public static function PNGFromZFile(name:String, path:String):BitmapData
		{	if ($_textures == null) $_textures = new Object();
		
			if ($_textures[name] != undefined)
				return $_textures[name];
				
			$_textures[name] = fzipLib.getBitmapData( "game/" + path + "/" + name.replace(/\*/, "#") + ".png" );
			
			return $_textures[name];
		}
		
		public function get assets():Object {	
			return _assets;	//read-only access
		}
		
		private function find_zfile(name:String):ByteArray
		{
			var n:int = -1;	//prime
			while (fzip.getFileCount() - (++n))
			{	zfile = fzip.getFileAt(n);
				if (zfile.filename == name)
					return zfile.content;
			}
			return null;
		}
	}
}