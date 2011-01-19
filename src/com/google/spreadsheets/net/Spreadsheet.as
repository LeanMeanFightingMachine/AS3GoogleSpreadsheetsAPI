package com.google.spreadsheets.net
{
	import com.google.spreadsheets.enum.GoogleSpreadsheetsFeedTypes;

	/**
	 * @author Fraser Hobbs
	 */
	public class Spreadsheet
	{
		private static const NO:Namespace = new Namespace("http://www.w3.org/2005/Atom");
		private static const GS:Namespace = new Namespace("http://schemas.google.com/spreadsheets/2006");
		
		private var _key : String;
		private var _worksheets:Vector.<Worksheet>;
		private var _successCallback:Function;
		private var _failCallback:Function;

		public function Spreadsheet(key : String)
		{
			_key = key;
		}

		public function getWorksheets(successCallback : Function, failCallback : Function) : void
		{
			_successCallback = successCallback;
			_failCallback = failCallback;
			
			if(_worksheets)
			{
				_successCallback.call(this, _worksheets);
			}
			else
			{
				GoogleSpreadsheetsAPI.call(GoogleSpreadsheetsFeedTypes.WORKSHEETS, _key, null, success, fail);
			}
		}
		
		private function success(data:Object):void
		{
			var xml:XML = new XML(data);
			
			trace(xml);
			
			_worksheets = new Vector.<Worksheet>();
			
			for each (var entry:XML in xml.NO::entry)
			{
				_worksheets.push(parseXML(entry));
			}
			
			_successCallback.call(this, _worksheets);
		}
		
		private function parseXML(entry:XML):Worksheet
		{
			var id:String = entry.NO::id;
			id = id.substring(id.lastIndexOf("/") + 1, id.length);
			
			var title:String = entry.NO::title;
			
			return new Worksheet(_key, id, title);
		}
		
		private function fail(data:Object):void
		{
			
		}
	}
}
internal class Callback
{
	public var success : Function;
	public var fail : Function;
}
