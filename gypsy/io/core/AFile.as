package gypsy.io.core 
{
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import gypsy.io.core.EventCore;

	/**
	 * ...
	 * @author Gypsy
	 */
	public class AFile extends EventCore
	{
		protected static var _loader:URLLoader;
		private static var _request:URLRequest;
		private static var _dataFormat:String = URLLoaderDataFormat.TEXT;
		
		/**
		 * Constructor 
		 */
		public function AFile():void {}
		
		/**
		 * Load a file
		 * @param	fname: path to file
		 */
		public function load(fname:String):void
		{	if(fname is String)
			{	_request = new URLRequest(fname);
			
				_loader = new URLLoader();
				_loader.dataFormat = _dataFormat;
				addListeners(_loader);
				_loader.load(_request);
			} else {
				//Houston we have a problem
			}
		}
		
		/**
		 * @param	dFormat
		 */
		protected static function set dataFormat(dFormat:String):void {
			_dataFormat = dFormat;
		}
	}
}