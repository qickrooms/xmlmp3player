Flex xml mp3 player

Basically you can specify an xml playlist from the url, and have it play whatever is in the playlist…

The links for the examples are on the right side.

You can also specify the playlist in the url if you'd like:

http://axel.cfwebtools.com/Examples/xspfPlayer/bin/xmlPlayer.cfm?playlist%5Furl=http://killtheheart.com/playlist.xml

here are the variables you can use:

  * playlist\_url : the url of the xspf file to load
  * repeat\_playlist : boolean value that make the repeats the playlist after the end
  * song\_url : String the href location of a single song you want to play, when this is used playlist\_url is ignored
  * song\_title : the name of the song you want to use
  * podcast\_mode : the boolean value that makes the playlist\_url be a rss feed for a podcast for example http://axel.cfwebtools.com/Examples/xspfPlayer/bin/xmlPlayerSmall.cfm?podcast_mode=true&playlist_url=http://www.theflexshow.com/blog/rss.cfm







The music player can also be used to play single mp3 files instead of playlists, the parameters are:
  * song\_url : the url of the single mp3 you want to play
  * song\_title : the text to replace the players default's


and you could even create a custom playlist on your site (this link doesn't work it's an example) http://flexcoders.nl/someplaylist.xml



and as long as it was in the right format, it’s all good….



here is the format
http://axel.cfwebtools.com/Examples/xspfPlayer/bin/data.xml

right click and view source to actually copy and paste xml...





It’s loosely based on the xspf (‘spiff’) standard, it’s an open source shareable playlist format…

Here is the documentation on it:

http://www.xspf.org/xspf-v1.html#rfc.section.4.1.1.2

here is another example of a playlist

http://www.killtheheart.com/playlist.xml


xml details
  * album
    * the album name of this track... leave blank if you wish this shows up in the big version on the bottom of the "now playing" view
  * annotaion
    * unused at the moment, please refer to xspf documenation for information
  * artist
    * the artist name of this track... leave blank if you wish this shows up in the big version in the middle of the "now playing" view
  * creator
    * the developer... this is just documentation in my eyes, but please refer to xspf docs
  * image
    * in the big version of the player, if you specify a url of the image you want, it will show on the left while the track is playing
  * info
    * there is an info button on the big version, it's simply another URL you could specify, and it will produce a popup window for it.
  * link
    * there is an image in the big version, specify a URL here, and when you click on the album in the big version it will give you a popup to the address you specify.
  * location
    * the most import piece of the puzzle
    * the url of the song (can be a URL, or relative path)
  * timeEnd
    * use this to pause the song at a certain point, say you only want the user to listen to 0:15 - 0:20, make the timeEnd 20000 (not exact but close enough, it's milliseconds)
    * specify a 0 to just play through the end
    * NOTE: it is milliseconds!
  * timeStart
    * use this to start the song at a certain point, say you only want the user to listen to 0:15 - 0:20, make the timeStart 15000 (not exact but close enough, it's milliseconds)
    * specify a 0 to just play from the begining
    * NOTE: it is milliseconds!
  * title
    * this is the track title - it is displayed in the top of the 'now playing' view in the big version (note: doesnt necessarily have to be the track title it could just be whatever you chose to name the file... it's up to you)
  * trackNum
    * unused at the moment, but could be used for documentation

```
<?xml version="1.0" encoding="UTF-8"?>
<!-- http://www.xspf.org/xspf-v1.html#rfc.section.4.1.1.2 -->
<!-- the above link is all the documentation on xspf, this loosely follows the spec -->
<playlist version="0">
	<trackList>

		<track>
			<album>Unknown</album>
			<annotation></annotation>
			<artist>Unknown</artist>
			<creator>Axel Jensen</creator>
			<image></image>
			<info>http://www.killtheheart.com</info>
			<link>http://www.downloads.betterpropaganda.com/</link>
			<location>http://downloads.betterpropaganda.com/music/Imperial_Teen-Ivanka_128.mp3</location>
			<timeEnd>20000</timeEnd>
			<timeStart>15000</timeStart>
			<title>Imperial Teen Ivanka</title>
			<trackNum></trackNum>
		</track>
		
		<track>
			<album>We Don't Need to Whisper</album>
			<annotation></annotation>
			<artist>Angels and Airwaves</artist>
			<creator>Axel Jensen</creator>
			<image>http://www.killtheheart.com/Music/Angels and Airwaves/We Don't Need to Whisper/cover.jpg</image>
			<info>http://www.killtheheart.com</info>
			<link>http://www.angelsandairwaves.com/</link>
			<location>http://www.killtheheart.com/Music/Angels and Airwaves/We Don&apos;t Need to Whisper/08 - the gift.mp3</location>
			<timeEnd>15000</timeEnd>
			<timeStart>0</timeStart>
			<title>The Gift</title>
			<trackNum>8</trackNum>
		</track>
	
		<track>
			<album>We Don't Need to Whisper</album>
			<annotation></annotation>
			<artist>Angels and Airwaves</artist>
			<creator>Axel Jensen</creator>
			<image>http://www.killtheheart.com/Music/Angels and Airwaves/We Don't Need to Whisper/cover.jpg</image>
			<info>http://www.killtheheart.com</info>
			<link>http://www.angelsandairwaves.com/</link>
			<location>http://www.killtheheart.com/Music/Angels and Airwaves/We Don&apos;t Need to Whisper/09 - good day.mp3</location>
			<timeEnd>0</timeEnd>
			<timeStart>0</timeStart>
			<title>Good Day</title>
			<trackNum>9</trackNum>
		</track>

	
	</trackList>
</playlist>


```