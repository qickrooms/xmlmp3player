<cfparam name="URL.playlist_url" default="">
<cfparam name="URL.autoPlay" default="1">
<cfparam name="URL.song_title" default="">
<cfparam name="URL.song_url" default="">


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!-- saved from url=(0014)about:internet -->
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${title}</title>
<script language="JavaScript" type="text/javascript">
<!--
// -----------------------------------------------------------------------------
// Globals
// Major version of Flash required
var requiredMajorVersion = ${version_major};
// Minor version of Flash required
var requiredMinorVersion = ${version_minor};
// Minor version of Flash required
var requiredRevision = ${version_revision};
// -----------------------------------------------------------------------------
// -->
</script>
<!-- SWFObject embed by Geoff Stearns geoff@deconcept.com http://blog.deconcept.com/swfobject/ -->
<script type="text/javascript" src="swfobject.js"></script>
</head>
<body>
	<script language="JavaScript" type="text/javascript" src="history.js"></script>
	
	<div id="flashcontent">
		<strong>You need to upgrade your Flash Player</strong>
		This is replaced by the Flash content. 
		Place your alternate content here and users without the Flash plugin or with 
		Javascript turned off will see this. Content here allows you to leave out <code>noscript</code> 
		tags. Include a link to <a href="swfObjectExample.cfm?detectflash=false">bypass the detection</a> if you wish.
	</div>
	
	<cfoutput>
		<script type="text/javascript">
			// <![CDATA[
			//params swfObject takes
			//swf, id, w, h, ver, c, quality, xiRedirectUrl, redirectUrl, detectKey
			var so = new SWFObject("${swf}.swf", "${application}", "${width}", "${height}", "9", "#${bgcolor}", "high");
			so.addVariable("playlist_url", "#URL.playlist_url#"); // this line is optional, but this example uses the variable and displays this text inside the flash movie
			so.addVariable("song_title", "#URL.song_title#");
			so.addVariable("song_url", "#URL.song_url#");
			so.addVariable("autoPlay", "#URL.autoPlay#");
			so.write("flashcontent");
			
			// ]]>
		</script>
	</cfoutput>
	<ul>
		<li><b>Resources</b></li>
		<li><a href="http://code.google.com/p/xmlmp3player/" target="_blank">Google Code</a></li>
		<li><a href="http://labs.flexcoders.nl/?p=113" target="_blank">labs.flexcoders.nl</a></li>
		<li><a href="http://axel.cfwebtools.com/index.cfm/2007/10/18/Open-source-flex-xml-mp3-player" target="_blank">axel.cfwebtools.com</a></li>
		<li><a href="http://axel.cfwebtools.com/Examples/xspfPlayer/bin/xmlPlayer.cfm?playlist_url=data.xml" target="_blank">Big Version</a></li>
		<li><a href="http://axel.cfwebtools.com/Examples/xspfPlayer/bin/xmlPlayerSmall.cfm?playlist_url=data.xml&autoPlay=1" target="_blank">Small Version</a></li>
	</ul>
	<ul>
		<li><b>Download</b></li>
		<li><a href="http://axel.cfwebtools.com/download/xmlMp3Player/xmlMP3PlayerBig_1.0.1.zip" target="_blank">Download the Big version to use</a></li>
		<li><a href="http://axel.cfwebtools.com/download/xmlMp3Player/xmlMP3PlayerSmall_1.0.1.zip" target="_blank">Download the Small version to use</a></li>
		<li><a href="http://axel.cfwebtools.com/download/xmlMp3Player/xmlMP3PlayerFlexSource_1.0.1.zip" target="_blank">Download the Flex Source</a></li>
	</ul>
	<ul>
		<li><b>People using</b></li>
		<li><a href="http://flex.org/community" target="_blank">flex.org (using a version geared for podcasts)</a></li>
		<li><a href="http://www.killtheheart.com" target="_blank">Axel's site to listen to music (please don't tell the RIAA)</a></li>
	</ul>
	<ul>
		<li><b>Things that I hope for</b></li>
		<li>to get the podcast version relased</li>
		<li>people will report bugs (the issues tab) on the google code site <a href="http://code.google.com/p/xmlmp3player/" target="_blank">Google Code</a> </li>
		<li>people will report features they want on the google code site <a href="http://code.google.com/p/xmlmp3player/" target="_blank">Google Code</a> </li>
	</ul>
	<ul>
		<li><b>Examples - Coming soon (hopefully people start to use it and email make me some tutorials)</b></li>
		<li>How to Skin the mp3 player</li>
	</ul>
	
	<b>xml details (listed alphabetically)</b>
	<ul>
		<li>album</li>
			<ul><li>the album name of this track... leave blank if you wish this shows up in the big version on the bottom of the "now playing" view</li></ul>
		<li>annotaion</li>
			<ul><li>unused at the moment, please refer to xspf documenation for information</li></ul>
		<li>artist</li>
			<ul><li>the artist name of this track... leave blank if you wish this shows up in the big version in the middle of the "now playing" view</li></ul>
		<li>creator</li>
			<ul><li>the developer... this is just documentation in my eyes, but please refer to xspf docs</li></ul>
		<li>image</li>
			<ul><li>in the big version of the player, if you specify a url of the image you want, it will show on the left while the track is playing</li></ul>
		<li>info</li>
			<ul><li>there is an info button on the big version, it's simply another URL you could specify, and it will produce a popup window for it.</li></ul>
		<li>link</li>
			<ul><li>there is an image in the big version, specify a URL here, and when you click on the album in the big version it will give you a popup to the address you specify.</li></ul>
		<li>location</li>
			<ul>
				<li>the most import piece of the puzzle</li>
				<li>the url of the song (can be a URL, or relative path)</li>
			</ul>
		<li>timeEnd</li>
			<ul>
				<li>use this to pause the song at a certain point, say you only want the user to listen to 0:15 - 0:20, make the timeEnd 20000 (not exact but close enough, it's milliseconds) </li>
				<li>specify a 0 to just play through the end</li>
				<li>NOTE: it is milliseconds!</li>
			</ul>
		<li>timeStart</li>
			<ul>
				<li>use this to start the song at a certain point, say you only want the user to listen to 0:15 - 0:20, make the timeStart 15000 (not exact but close enough, it's milliseconds) </li>
				<li>specify a 0 to just play from the begining</li>
				<li>NOTE: it is milliseconds!</li>
			</ul>
		<li>title</li>
			<ul><li>this is the track title - it is displayed in the top of the 'now playing' view in the big version (note: doesnt necessarily have to be the track title it could just be whatever you chose to name the file... it's up to you)</li></ul>
		<li>trackNum</li>
			<ul><li>unused at the moment, but could be used for documentation </li></ul>
	</ul>
	
	<b>Instructions</b>
	<ol>
		<li>Download whatever version you want (big/small) by clicking the links above</li>
		<ul>
			<li>if your just using the product and dont care about the source, click on the links under <b>Download</b> section, that dont have the word "source"</li>
		</ul>
		<li>When you download it, there are 4 files</li>
			<ul>
				<li>data.xml (sample xml file)</li>
				<li>swfobject.js (swfobject.js used for including the swf file in your html/cfm/php/whatever else page) (NOTE: i'll try to keep up on new versions of swfobject but no gurantees if you want the latest and greatest go to http://blog.deconcept.com/swfobject/</li>
				<li>xmlPlayer(Small/Big).cfm (Small/Big depending on the version you downloaded... these are example cfm files to reference to for using swfObject to include your .swf... if you have any experience with using flash files on html pages, you should have not problem googling other ways besides swfobject)</li>
				<li>xmlPlayer(Small/Big).swf (this is the actual swf file to use)</li>
			</ul>
		<li>Place those files in whatever folder you would like under your webroot and then run the page in a browser (http://yourdomain/whereyouputthefiles/index.cfm (if you dont have coldfusion, please open up the cfm file with wordpad, and fix the code, it's pretty self explanatory, mostly it's just html)</li>
		<li>When you run the page, a default playlist will start playing if you have not provided one on the url</li>
		<li>please submit bugs to the google code site! I WILL FIX THEM I PROMISE! (the issues tab) <a href="http://code.google.com/p/xmlmp3player/" target="_blank">Google Code</a></li>
	</ol>
</body>
</html>