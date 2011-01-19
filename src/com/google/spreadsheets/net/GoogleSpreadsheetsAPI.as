package com.google.spreadsheets.net
{
	import com.google.spreadsheets.enum.GoogleSpreadsheetsProjection;
	import com.google.spreadsheets.enum.GoogleSpreadsheetsVisibilty;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * @author Fraser Hobbs
	 */
	public class GoogleSpreadsheetsAPI
	{
		public static const NAMESPACE:Namespace = new Namespace("http://schemas.google.com/spreadsheets/2006");
		
		public static var visibility : String = GoogleSpreadsheetsVisibilty.PRIVATE;
		public static var projection : String = GoogleSpreadsheetsProjection.FULL;
		
		private static const URI : String = "https://spreadsheets.google.com/feeds/";
		private static var _callbacks : Dictionary = new Dictionary();
		
		public static function call(feedType : String, key : String, worksheet:String, success : Function, fail : Function) : void
		{
			var urlLoader : URLLoader = new URLLoader();
			var uri : String = URI + feedType + "/" + key + "/" + (worksheet ? worksheet + "/" : "") + visibility + "/" + projection;
			var callback : Callback = new Callback();
			
			trace(uri);
			
			callback.success = success;
			callback.fail = fail;
			_callbacks[urlLoader] = callback;

			addEventListeners(urlLoader);

			urlLoader.load(new URLRequest(uri));
		}

		private static function addEventListeners(urlLoader : URLLoader) : void
		{
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		private static function removeEventListeners(urlLoader : URLLoader) : void
		{
			urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		private static function securityErrorHandler(event : SecurityErrorEvent) : void
		{
			var urlLoader : URLLoader = URLLoader(event.target);
			var callback : Callback = _callbacks[urlLoader];
			
			trace("securityErrorHandler");

			removeEventListeners(urlLoader);

			callback.fail.call(callback, urlLoader.data);

			delete _callbacks[urlLoader];
		}

		private static function ioErrorHandler(event : IOErrorEvent) : void
		{
			var urlLoader : URLLoader = URLLoader(event.target);
			var callback : Callback = _callbacks[urlLoader];
			
			trace("ioErrorHandler");

			removeEventListeners(urlLoader);

			callback.fail.call(callback, urlLoader.data);

			delete _callbacks[urlLoader];
		}

		private static function completeHandler(event : Event) : void
		{
			var urlLoader : URLLoader = URLLoader(event.target);
			var callback : Callback = _callbacks[urlLoader];
			
			trace("completeHandler" + callback.success);

			removeEventListeners(urlLoader);

			callback.success.call(callback, urlLoader.data);

			delete _callbacks[urlLoader];
		}
	}
}

internal class Callback
{
	public var success : Function;
	public var fail : Function;
}