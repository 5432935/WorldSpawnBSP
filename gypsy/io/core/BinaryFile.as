package gypsy.io.core
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import gypsy.io.core.AFile;
	import flash.net.URLLoaderDataFormat;
	/**
	 * ...
	 * @author OneMadGypsy
	 */
	public class BinaryFile extends AFile 
	{
		
		public function BinaryFile():void {
			this.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		public function get data():ByteArray
		{	_loader.data.endian = Endian.LITTLE_ENDIAN;
			_loader.data.position = 0;
			return _loader.data; 
		}
		
	}
	
}