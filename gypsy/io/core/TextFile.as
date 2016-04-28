package gypsy.io.core
{
	import gypsy.io.core.AFile;
	import flash.net.URLLoaderDataFormat;
	/**
	 * ...
	 * @author OneMadGypsy
	 */
	public class TextFile extends AFile 
	{
		
		public function TextFile():void {
			this.dataFormat = URLLoaderDataFormat.TEXT;
		}
		
		public function get data():String
		{	return _loader.data; 
		}
	}
	
}