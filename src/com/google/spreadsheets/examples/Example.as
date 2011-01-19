package com.google.spreadsheets.examples
{
	import com.google.spreadsheets.net.GoogleSpreadsheetsAPI;
	import com.google.spreadsheets.net.Worksheet;
	import com.google.spreadsheets.enum.GoogleSpreadsheetsProjection;
	import com.google.spreadsheets.enum.GoogleSpreadsheetsVisibilty;
	import com.google.spreadsheets.net.Spreadsheet;

	import flash.display.Sprite;

	/**
	 * @author Fraser Hobbs
	 */
	public class Example extends Sprite
	{
		private var _spreadsheet:Spreadsheet = new Spreadsheet("t7keWLgvpJScr2US3qHtdgg");
		
		public function Example()
		{
			GoogleSpreadsheetsAPI.visibility = GoogleSpreadsheetsVisibilty.PUBLIC;
			GoogleSpreadsheetsAPI.projection = GoogleSpreadsheetsProjection.VALUES;
			
			_spreadsheet.getWorksheets(worksheetsSuccess, worksheetsFail);
		}
		
		private function worksheetsSuccess(worksheets:Vector.<Worksheet>):void
		{
			trace("SUCCESS\n" + worksheets);

			worksheets[0].getCells(cellsSuccess, cellsFail);
		}
		
		private function worksheetsFail(data:Object):void
		{
			trace("FAIL\n" + data);
		}
		
		private function cellsSuccess(data:Object):void
		{
			trace("SUCCESS\n" + data);
		}
		
		private function cellsFail(data:Object):void
		{
			trace("FAIL\n" + data);
		}
	}
}
