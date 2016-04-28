package gypsy.models.bsp 
{
	import gypsy.models.bsp.BSPR;
	/**
	 * ...
	 * @author OneMadGypsy
	 */
	public class BSPWorld extends BSPR
	{
		
		protected static var markSurf:Vector.<int>;
		
		public function BSPWorld():void;
		
		public function findEntityByClassname(classname:String):Object
		{	var n:int = -1;
			
			while ($bspr.ents.length - (++n))
				if ($bspr.ents[n].classname == classname)
					return $bspr.ents[n];
			
			return null;
		}
		
		public function findEntitiesWithClassname(classname:String):Vector.<Object>
		{	var n:int = -1;
			var temp:Vector.<Object> = new Vector.<Object>();
			
			while ($bspr.ents.length - (++n))
				if ($bspr.ents[n].classname == classname)
					temp.push($bspr.ents[n]);
			
			return temp;
		}
		
		private static function pointInLeaf(x:Number, y:Number, z:Number):int
		{	var plane:Object;
			var n:int = $bspr.models[0].node[0];
			
			while(n >= 0)
			{	//trace("Node:",n);
				plane = $bspr.planes[ $bspr.nodes[n].plane_id ];
				var dot:Number = ((int(x) * plane.normal.x) + (int(z) * plane.normal.y) + (int(y) * plane.normal.z)) - plane.dist;
				n = (dot >= 0)? $bspr.nodes[n].front : $bspr.nodes[n].back;
			}
			//trace("Leaf:",-(n+1));
			return -(n+1);
		}
		
	}
	
}