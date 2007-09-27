package model
{
	[Bindable]
	public class MusicModelLocator
	{
		/* This code is always the same for a ModelLocator. */
		private static var modelLocator:MusicModelLocator;
		public static function getInstance():MusicModelLocator{
			if(modelLocator == null){
				modelLocator = new MusicModelLocator();
			}
			return modelLocator;
		}
		
		//DEFAULTS
		public static const DEFAULT_PLAYLIST_URL:String = "http://www.killtheheart.com/Music/Angels and Airwaves/We Don't Need to Whisper/playlist.xml";
		
		
	}
}