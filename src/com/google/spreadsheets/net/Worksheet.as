package com.google.spreadsheets.net
{
	import com.google.spreadsheets.enum.GoogleSpreadsheetsFeedTypes;
	/**
	 * @author Fraser Hobbs
	 */
	public class Worksheet
	{
		private static const NO:Namespace = new Namespace("http://www.w3.org/2005/Atom");
		private static const GS:Namespace = new Namespace("http://schemas.google.com/spreadsheets/2006");
		
		private var _key : String;
		private var _id:String;
		private var _title:String;
		private var _cellsByRow:Array;
		private var _cellsByCol:Array;
		private var _successCallback:Function;
		private var _failCallback:Function;
		
		public function Worksheet(key:String, id:String, title:String = null)
		{
			_key = key;
			_id = id;
			_title = title;
		}
		
		public function getTitle():String
		{
			return _title;
		}
		
		public function getCells(successCallback : Function, failCallback : Function):void
		{
			_successCallback = successCallback;
			_failCallback = failCallback;
			
			if(_cellsByRow)
			{
				_successCallback.call(this, _cellsByRow);
			}
			else
			{
				GoogleSpreadsheetsAPI.call(GoogleSpreadsheetsFeedTypes.CELLS, _key, _id, success, fail);
			}
		}
		
		public function getRow(value:int):Array
		{
			return _cellsByRow[value];
		}
		
		public function getCol(value:int):Array
		{
			return _cellsByCol[value];
		}
		
		private function success(data:Object):void
		{
			var xml:XML = new XML(data);
			var val:*;
			
			_cellsByRow = [];
			_cellsByCol = [];
			
			for each (var cell:XML in xml..GS::cell)
			{
				var row:int = int(cell.@row) - 1;
				var col:int = int(cell.@col) - 1;
				
				trace(row + "," + col);
				
				if(!_cellsByRow[row]) _cellsByRow[row] = [];
				if(!_cellsByCol[col]) _cellsByCol[col] = [];
				
				if(cell.hasOwnProperty("@numericValue"))
				{
					val = Number(cell.@numericValue);
				}
				else
				{
					val = String(cell);
				}
				
				_cellsByRow[row][col] = val;
				_cellsByCol[col][row] = val;
			}
				
			_successCallback.call(this, _cellsByRow);
		}
		
		private function fail(data:Object):void
		{
			_failCallback.call(this, data);
		}
	}
}
