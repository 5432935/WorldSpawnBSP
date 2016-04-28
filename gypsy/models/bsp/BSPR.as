package gypsy.models.bsp
{
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.SkyBox;
	import flash.utils.ByteArray;
	import gypsy.io.core.EventCore;
	import gypsy.io.LoadAssets;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.display.BlendMode;
	import flash.display.BitmapData;
	
	import away3d.utils.Cast;
	import away3d.tools.commands.Weld;
	import away3d.tools.commands.Merge;
	import away3d.textures.ATFTexture;
	import away3d.textures.ATFCubeTexture;
	import away3d.core.base.Geometry;
	import away3d.core.base.SubGeometry;
	import away3d.core.base.CompactSubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.LightMapMethod;
	import away3d.animators.UVAnimationSet;
	import away3d.animators.UVAnimator;
	import away3d.animators.nodes.UVClipNode;
	import away3d.tools.utils.GeomUtil;
	
	/**
	 * ...
	 * @author OneMadGypsy
	 */
	public class BSPR extends EventCore
	{
		
		protected static var $bspr:Object;
		
		private static var _textures:Object = new Object();
		private static var _lmatlas:Object = new Object();
		
		
		private static var uvAnimationSet:UVAnimationSet;
		private static var uvAnimator:UVAnimator;
		
		private static var _tsubgeo:Vector.<SubGeometry>;
		private static var com_tsubgeo:Vector.<CompactSubGeometry>;
		private static var _tgeo:Vector.<Geometry>;
		private static var _tmodels:Vector.<Mesh>;
		
		private static var _assets:Object;
		private static var _bsp:ObjectContainer3D;
		private static var _skyMap:ATFCubeTexture;
		private static var _skyBox:SkyBox;
		
		public function BSPR():void;
		
		public function get map():ObjectContainer3D { return _bsp; }
		public function get sky():SkyBox { return _skyBox; }
		
		/**		INIT
		 * 
		 * 		@param	assets - all the game assets
		 */
		public function init(assets:Object):void
		{	_assets = assets;
			
			_bsp = new ObjectContainer3D();
			_tsubgeo = new Vector.<SubGeometry>();
			_tgeo	 = new Vector.<Geometry>();
			_tmodels = new Vector.<Mesh>();
			com_tsubgeo = new Vector.<CompactSubGeometry>();
					
			parse(assets.world);
			
			dispatchEvent(new Event(Event.COMPLETE));	//tell the engine we are ready
		}
		
		private static function parse(data:ByteArray):void
		{	
			$bspr = new Object();
			$bspr = data.readObject();
			
			var i:int;
			
			var name:String, cname:String, j:int;
			for (name in $bspr)
			{	trace(name);
				switch(name)
				{
					case "map":
						objectAssign($bspr.map);
						break;
					case "brush":
						i = 0;  do {
							objectAssign($bspr.brush[i], true);
						} while ($bspr.brush.length - (++i))
						break;
				}
			}
			
			j = 0;
			do
			{	if(_tmodels[j] != null)
					_bsp.addChild(_tmodels[j]);
			}
			while ((++j) - _tmodels.length);
		}
		
		private static function objectAssign(model:Object, compact:Boolean = false):void 
		{	var l:int, j:int;
			var name:String;
							
			for (name in model)
			{
				buildMaterial(name);
				j = _tgeo.length;
				_tgeo.push(new Geometry());
				
				if (!compact)
				{	l = _tsubgeo.length;
					_tsubgeo.push(new SubGeometry());
					_tsubgeo[l].updateVertexData(model[name].vertices);
					_tsubgeo[l].updateIndexData (model[name].indices);
					_tsubgeo[l].updateUVData	(model[name].uvs);
					_tsubgeo[l].updateSecondaryUVData(model[name].lmuvs);
					
					_tgeo[j].addSubGeometry(_tsubgeo[l]);
					
				} else {
					l = com_tsubgeo.length;
					com_tsubgeo.push(new CompactSubGeometry());
					com_tsubgeo[l].updateData(GeomUtil.interleaveBuffers((model[name].vertices.length/3), model[name].vertices, null, null, model[name].uvs, model[name].lmuvs));
					com_tsubgeo[l].updateIndexData(model[name].indices);
					
					_tgeo[j].addSubGeometry(com_tsubgeo[l]);
				}
				
				_tmodels.push(new Mesh(_tgeo[j]));
				_tmodels[j].material = _textures[name];
			}
		}
		
		private static function buildMaterial(cname:String):void
		{	var _temp:BitmapData;
			var anim:Boolean = false;
			var skip:Boolean = false;
			
			if (!_textures[cname])
			{	
				anim = ( cname.indexOf("*") == -1 )? false : true;
				skip = ( cname.search(/trigger|clip/) == -1 )? false : true;
				
				_textures[cname] = new TextureMaterial(new ATFTexture(LoadAssets.ATFFromZFile(cname, "textures")), false, true, !anim);
				
				if (!anim)
				{	if(!skip)
					{	_temp = LoadAssets.PNGFromZFile(cname, "lmatlas");
						_lmatlas[cname] = new LightMapMethod( Cast.bitmapTexture(_temp), BlendMode.MULTIPLY, true);
						_textures[cname].addMethod(_lmatlas[cname]);
					} else _textures[cname].alpha = 0.0;
				} else {
					_textures[cname].alphaBlending = true;
					_textures[cname].alpha = 0.5;
				}
			}
		}
		
		/**
		 * adding a blank set, to meet the generic animators architecture
		 */
		private static function generateBlankAnimationSet(animID:String) : UVAnimationSet
		{
			var uvAnimationSet:UVAnimationSet = new UVAnimationSet();
			var node:UVClipNode = new UVClipNode();
			node.name = animID;
			uvAnimationSet.addAnimation(node);

			return uvAnimationSet;
		}
		
		private static function watermove():void
		{
			uvAnimationSet = generateBlankAnimationSet("water");
			uvAnimator = new UVAnimator(uvAnimationSet);
			uvAnimator.autoTranslate = true;
			uvAnimator.setTranslateIncrease( -.001, -.001);
		}

	}
}