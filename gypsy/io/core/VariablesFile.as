package gypsy.io.core
{
	import gypsy.io.core.AFile;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author OneMadGypsy
	 */
	public class VariablesFile extends AFile 
	{
		
		public function VariablesFile():void {
			this.dataFormat = URLLoaderDataFormat.VARIABLES;
		}
		
		
		public function get data():URLVariables
		{	return _loader.data; 
		}
		
	}
	
}