package gypsy.io.core
{

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	
	
	/**
	* ...
	* @author Gypsy
	*/
	
	public class EventCore extends EventDispatcher
	{
		private static var _events:Vector.<String> = new Vector.<String>();
		private static var _eventsArray:Vector.<String> = new Vector.<String>();
		private static var _autoEvents:Vector.<String> = Vector.<String>([Event.COMPLETE, ProgressEvent.PROGRESS, IOErrorEvent.IO_ERROR]);
		
		/**
		* Constructor
		*/
		public function EventCore():void {
			super();
		}
		
		/**
		* Loop add events to an object
		* @param	target: the object in which to add the listeners to
		*/
		protected function addListeners(target:*):void
		{
			_events = _autoEvents.concat(_eventsArray);
			
			_events.forEach(function(value:String, key:int, evt:Vector.<String>):void
			{
				target.addEventListener(value, handler);
			});
		}
		
		/**
		* Loop remove events from an object
		* @param	target: the object in which to remove the listeners from
		*/
		protected function dropListeners(target:*):void
		{
			_events = _autoEvents.concat(_eventsArray);
			
			_events.forEach(function(value:String, key:int, evt:Vector.<String>):void
			{
				if (target.hasEventListener(value))
					target.removeEventListener(value, handler);
			});
		}
		
		/**
		* Handle drop listeners for any event which is not a PROGRESS event. Dispatch any event.
		* @param	event: the current event being processed
		*/
		protected function handler(event:*):void
		{
			if (event.type != ProgressEvent.PROGRESS)
				dropListeners(event.target);
			
			dispatchEvent(event.clone());
		}
		
		/**
		* Append to the event listener list
		* @param	events: an array of event constants 
		* 
		* note: 	The array supplied here will be concattenated to _autoEvents.
		* 			If no array is ever supplied here only _autoEvents will be used.
		*/
		public function set events(events:Vector.<String>):void
		{
			_eventsArray = events;
		}
	}
}
