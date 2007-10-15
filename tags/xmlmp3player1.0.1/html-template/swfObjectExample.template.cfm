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
			so.write("flashcontent");
			
			// ]]>
		</script>
	</cfoutput>

</body>
</html>