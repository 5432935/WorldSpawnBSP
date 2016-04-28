package
{
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.controllers.FirstPersonController;
	import away3d.cameras.lenses.PerspectiveLens;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	
	import gypsy.GameManager;

	[SWF(backgroundColor="#000000", frameRate="120", quality="LOW", width="1280", height="592")]
	
	public class WorldSpawn extends Sprite
	{
		//engine
		public static var view:View3D;
		private static var game:GameManager;
		private static var awayStats:AwayStats;
		private static var cameraController:FirstPersonController;
		
		private var roll:int = 0;
		private var rollLeft:Boolean = false;
		private var rollRight:Boolean = false;
		
		//rotation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		//movement variables
		private var drag:Number = 0.5;
		private var walkIncrement:Number = 6;
		private var strafeIncrement:Number = 6;
		private var walkSpeed:Number = 0;
		private var strafeSpeed:Number = 0;
		private var walkAcceleration:Number = 0;
		private var strafeAcceleration:Number = 0;
		
		/**
		 * Constructor
		 */
		public function WorldSpawn():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.LOW;
			
			view = new View3D();
			//setup the render loop
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
			
			game = new GameManager();
			game.addEventListener(Event.COMPLETE, handler);
			game.initGame("game.zip");
			
		}
		
		private function handler(event:* = null):void
		{
			switch(event.type)
			{
				case Event.COMPLETE:
					//it pays to make sure
					
					//setup the view
					addChild(view);
					view.camera.lens = new PerspectiveLens(60);
					view.scene.addChild(game.world.map);
					//view.scene.addChild(game.world.sky);
							
					var origin:Array = game.player_origin;
					
					//setup the camera
					view.camera.x = origin[0];
					view.camera.y = origin[2] + 56;
					view.camera.z = origin[1];
					trace("cam pos", view.camera.x, view.camera.y, view.camera.z);
					
					//setup camera controller
					cameraController = new FirstPersonController(view.camera, game.player_angle-90, -45, -80, 80);
					cameraController.tiltAngle = 0;	//lil effect
					
					//stats
					awayStats = new AwayStats(view);
					addChild(awayStats);
					
					initListeners();
					onMouseDown();
					onResize();
					
					//setup the render loop
					addEventListener(Event.ENTER_FRAME, _onEnterFrame);
					break;
			}
		}
		
		/**
		 * render loop
		 */
		private function _onEnterFrame(e:Event):void
		{	
			var a:int, b:int;
			//game.renderTick();
			
				cameraController.panAngle = 0.8*(stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.8*(stage.mouseY - lastMouseY) + lastTiltAngle;
			
			if (walkSpeed || walkAcceleration) {
				walkSpeed = (walkSpeed + walkAcceleration) * drag;
				if (Math.abs(walkSpeed) < 0.01)
					walkSpeed = 0;
				view.camera.moveForward(walkSpeed);
			}
			
			if (strafeSpeed || strafeAcceleration) {
				strafeSpeed = (strafeSpeed + strafeAcceleration) * drag;
				if (Math.abs(strafeSpeed) < 0.01)
					strafeSpeed = 0;
				cameraController.incrementStrafe(strafeSpeed);
			}
			view.render();
		}
		
		private function initListeners():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		/**
		 * Key down listener for camera control
		 */
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.W:
				case Keyboard.UP:
					walkAcceleration = walkIncrement;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					walkAcceleration = -walkIncrement;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					strafeAcceleration = -strafeIncrement;
					rollLeft = true;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					strafeAcceleration = strafeIncrement;
					rollRight = true;
					break;
			}
		}
		
		/**
		 * Key up listener for camera control
		 */
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.W:
					break;
				case Keyboard.UP:
				case Keyboard.DOWN:
				case Keyboard.S:
					walkAcceleration = 0;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					strafeAcceleration = 0;
					rollLeft = false;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					strafeAcceleration = 0;
					rollRight = false;
					break;
			}
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent = null):void
		{
			move = true;
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			//stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			Mouse.hide();
		}
		
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			Mouse.show();
		}
		
		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
	}
}
