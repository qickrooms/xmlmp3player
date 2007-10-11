/*
Copyright (c) 2007, Axel Jensen, Maikel Sibbald
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
/*
	xspf MP3Player version 0.1
    
    xspf mp3 player.
    
    Created by Maikel Sibbald
	info@flexcoders.nl
	http://labs.flexcoders.nl
	
	&
	
	Axel Jensen
	axel@cfwebtools.com	
	http://axel.cfwebtools.com
	
	Free to use.... just give us some credit
*/

package vo{
	import flash.net.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	import mx.utils.ObjectUtil;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	[Event(name="play", type="flash.events.Event")]
	[Event(name="pause", type="flash.events.Event")]
	[Event(name="configComplete", type="flash.events.Event")]
	[Event(name="onDelayViewChange", type="flash.events.Event")]
	[Event(name="onDelayError", type="flash.events.Event")]
	
	[Bindable]
	public class MP3Player extends UIComponent{
		
		public static const DEFAULT_PLAYLIST_URL:String = "http://www.killtheheart.com/playlist.xml";
		public static const DEFAULT_SONG_URL:String = "http://www.killtheheart.com/Music/Angels and Airwaves/We Don&apos;t Need to Whisper/08 - the gift.mp3";
		public static const DEFAULT_SONG_TITLE:String = "The Gift";
		public static const DEFAULT_WELCOME_MSG:String = "Flex XML Mp3 Player - by Axel Jensen & Maikal Sibbald";
		public static const LOADING_PLAYLIST_MSG:String = "Loading Playlist...";
		public static const EVENT_CONFIG_COMPLETE:String = "configComplete";
		
		public var length:Number;
		public var sLength:String				= "0.00";
		public var sPosition:String 			= "0.00";
		public var pMinutes:Number 				= 0;
		public var pSeconds:Number 				= 0;
		public var position:Number 				= 0;
		public var currentTrack:Number 			= -1;
		public var currentTrackVO:TrackVO;
		public var pausePosition:Number;
		public var playlist_url:String = MP3Player.DEFAULT_PLAYLIST_URL;

		private var _url:String;
		
		private var _autoPlay:Boolean = true;
		private var _repeat_playlist:Boolean = true;
		private var _song_url:String;
		private var _song_title:String;
		private var _isShuffleMode:Boolean = true;
		private var _isPlaying:Boolean = false;
		private var _isPaused:Boolean = false;
		private var _isResumeSet:Boolean = false;
		private var _isMoveTrackEnabled:Boolean = true;
		private var _isLoading:Boolean;
		private var _startTime:Number;
		private var _volume:Number 	= 0;
		private var _dataProvider:ArrayCollection = new ArrayCollection();
		private var _soundInstancePosition:Number = 0;
		
		/********************TIMERS***************/
		/*
			delayMoveTrackTimer is used to delay people from 
			requesting songs to fast
		*/
		private var delayMoveTrackTimer:Timer = new Timer(1200,1);
		
		/*
			delayViewChangeTimer is used to dispatch an event that 
			the view could be changed at this certain time after getTrackAt() 
			is accessed
		*/
		private var delayViewChangeTimer:Timer = new Timer(5000,1);
		
		/*
			delayErrorTimer is used to dispatch an event... sometimes when a song tries to download
			there is an unknown interuption depending on the network, or the specific song rip...
			this will dispatch an event and we can use it to change songs... 
		*/
		private var delayErrorTimer:Timer = new Timer(4000,1);
		
		
		private var soundInstance:Sound;
		private var soundChannelInstance:SoundChannel;
		private var urlRequest:URLRequest = new URLRequest();
		private var soundBytes:ByteArray;
		
		private static var mp3Player:MP3Player;
		public static function getInstance():MP3Player{
			if(mp3Player == null){
				mp3Player = new MP3Player();
			}
			return mp3Player;
		}
		public function MP3Player():void{
			this.explicitHeight = 100;
			this._isShuffleMode = true;
			this.isPaused = false;
			this._isPlaying = false;
			this._isResumeSet = false;
			this.soundInstance = new Sound();
			this.setupListeners();
		}
		
		/*****************TIMER HANDLERS*************************/
		private function delayMoveTrackStatus(event:TimerEvent):void{
			//trace('delayMoveTrackStatus');
			this.isMoveTrackEnabled = true;
		}
		private function delayViewChangeStatus(event:TimerEvent):void{
			this.dispatchEvent(new Event("onDelayViewChange"));
		}
		private function delayErrorStatus(event:TimerEvent):void{
			if(soundChannelInstance != null){
				if( this.sPosition == this.sLength ){
					this.dispatchEvent(new Event("onDelayError"));
				}
			}
		}
		
		/*****************TIMER HANDLERS*************************/
		public function newSound():void{
			//remove old listeners
			this.removeListeners();
			
			//create a new sound
			this.soundInstance = new Sound();
			
			//create new listeners
			this.setupListeners();
		}
		
		public function get dataProvider():ArrayCollection{
			return this._dataProvider;
		}
		
		public function set dataProvider(val:ArrayCollection):void{
			this._dataProvider = val;
		}
		
		public function set url(value:String):void{
			this._url = value;
			this.urlRequest.url = this._url;
			this.soundInstance.load(this.urlRequest);
			//trace('set url :' + _url);
		}

		public function get url():String{
			//trace('get url :' + _url);
			return _url;
		}
		
		public function set autoPlay(value:Boolean):void{
			this._autoPlay = value;
		}
		public function get autoPlay():Boolean{
			return this._autoPlay;
		}
		
		public function set repeat_playlist(value:Boolean):void{
			this._repeat_playlist = value;
		}
		public function get repeat_playlist():Boolean{
			return this._repeat_playlist;
		}
		
		public function set song_url(value:String):void{
			this._song_url = value;
		}
		public function get song_url():String{
			return this._song_url;
		}
		
		public function set song_title(value:String):void{
			this._song_title = value;
		}
		public function get song_title():String{
			return this._song_title;
		}
		
		public function set volume(value:Number):void{
			/* this._volume = value;
			if(this.soundChannelInstance != null){
				this.soundChannelInstance.soundTransform.volume = this._volume;
			} */
		}
		
		public function get isPlaying():Boolean{
			return this._isPlaying;
		}
		
		public function get isPaused():Boolean{
			return this._isPaused;
		}
		public function set isPaused(value:Boolean):void{
			this._isPaused = value;
		}
		
		public function get startTime():Number{
			return this._startTime;
		}
		
		public function get isResumeSet():Boolean{
			return this._isResumeSet;
		}
		
		public function get isMoveTrackEnabled():Boolean{
			return this._isMoveTrackEnabled;
		}
		
		public function set isMoveTrackEnabled(value:Boolean):void{
			this._isMoveTrackEnabled = value;
		}
		
		public function set startTime(value:Number):void{
			this._startTime = value;
		}
		public function get isBuffering():Boolean{
			return soundInstance.isBuffering;
		}
		public function get soundLength():Number{
			return soundInstance.length;
		}
		public function set isShuffleMode(value:Boolean):void{
			this._isShuffleMode = value;
		}
		public function get isShuffleMode():Boolean{
			return this._isShuffleMode;
		}
		
		
		public function getConfig(parameters:Object):void{
			
			var song_title:String = parameters.song_title;
			if( song_title == '')
				mp3Player.song_title = MP3Player.DEFAULT_SONG_TITLE;
			else
				mp3Player.song_title = song_title;
			
			
			var playlist_url:String = parameters.playlist_url;
			var song_url:String = parameters.song_url;
			if( !playlist_url ){
				
				if( !song_url )
					mp3Player.playlist_url = MP3Player.DEFAULT_PLAYLIST_URL;
				else
					mp3Player.song_url = song_url;
			}
			else
				mp3Player.playlist_url = playlist_url;
				
				
			var repeat_playlist:Boolean = parameters.repeat_playlist;
			if( repeat_playlist )
				mp3Player.repeat_playlist = true;
			else
				mp3Player.repeat_playlist = false;
			
			trace(mx.utils.ObjectUtil.toString(parameters));
			var autoPlay:String = parameters.autoPlay;
			autoPlay = autoPlay.toLowerCase();
			if( autoPlay == '0' || autoPlay == 'false' )
				mp3Player.autoPlay = false;
			else if( autoPlay == null )
				mp3Player.autoPlay = true;
			else
				mp3Player.autoPlay = Boolean(autoPlay);
				
				
			this.dispatchEvent(new Event(MP3Player.EVENT_CONFIG_COMPLETE));
			
		}
		public function get isLoading():Boolean{
			if(this.soundInstance != null){
				if(this.soundInstance.bytesLoaded < this.soundInstance.bytesTotal){
					_isLoading = true;
				}else{
					_isLoading = false;
				}
			}
			return _isLoading;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			if(this._autoPlay && !this._isPlaying){
				this.play();
			}
		}
		/******************************************CONTROLS***********************************************/
		private function setupListeners():void{
			//TIMER LISTENERS
			this.delayMoveTrackTimer.addEventListener("timer",delayMoveTrackStatus);
			this.delayViewChangeTimer.addEventListener("timer",delayViewChangeStatus);
			this.delayErrorTimer.addEventListener("timer",delayErrorStatus);
			
			this.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,onDataChangeHandler);
			
			this.soundInstance.addEventListener(Event.COMPLETE, completeHandler);
			this.soundInstance.addEventListener(Event.OPEN, openHandler);
            this.soundInstance.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.soundInstance.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			this.addEventListener( Event.ENTER_FRAME, enterFrameHandler);
		}
		private function removeListeners():void{
			this.soundInstance.removeEventListener(Event.COMPLETE, doNothing);
			this.soundInstance.addEventListener(Event.OPEN, doNothing);
            this.soundInstance.addEventListener(IOErrorEvent.IO_ERROR, doNothing);
			this.soundInstance.addEventListener(ProgressEvent.PROGRESS, doNothing);
		}
		public function doNothing(event:Event):void{
			//used when removing event listeners
		}
		
		public function getInfo():void{
			var u:URLRequest = new URLRequest(this.currentTrackVO.info);
			navigateToURL(u,'_blank');
		}
		public function getLink():void{
			var u:URLRequest = new URLRequest(this.currentTrackVO.link);
			navigateToURL(u,'_blank');
		}
		
		public function play():void{
			if(dataProvider){
				if(!this._isPlaying || this.isPaused){
					if(this.currentTrack == -1){
						this.getTrackAt(0);
					}else{
						this._isPlaying = true;
						this.isPaused = false;
						this.soundChannelInstance = this.soundInstance.play(startTime);						
						var e:Event = new Event("play");
						this.dispatchEvent(e);
						
						this.soundChannelInstance.soundTransform.volume = this._volume;
						this.soundInstance.addEventListener(ProgressEvent.PROGRESS, progressHandler);
						this.soundInstance.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
						this.soundChannelInstance.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
						this.pausePosition = 0;
					}//end current track == -1

				}//end now Playing iff
			}//end dataProvider if
		}
		
		public function pause(isResumeSet:Boolean=false):void{
			if(dataProvider){
				if(this._isPlaying){
					this.startTime = this.soundChannelInstance.position;
					this._isPlaying = false;
					this._isResumeSet = isResumeSet;
					this.isPaused = true;
					this.soundChannelInstance.stop();
					var e:Event = new Event("pause");
					this.dispatchEvent(e);
				}
			}
		}
		
		public function stop():void{
			if(this.soundInstance != null){
				if(this.isPlaying){
					if( this.isLoading )
						this.soundInstance.close();
						
					var e:Event = new Event("stop");
					this.dispatchEvent(e);
					//trace('[stop] '+this.soundInstance.bytesLoaded)
				}
			}
			
			if(dataProvider){
				if(this.isPlaying){
					this._isPlaying = false;
					this.soundChannelInstance.stop();
				}		
			}
		}
	
		public function getFirstTrack():void{
			getTrackAt(0);
		}
		public function getNextTrack():void{
			var i:int;
			
			//if at end don't do
			if(dataProvider){
				if( currentTrack < dataProvider.length-1 ){
					i = currentTrack + 1;
					getTrackAt(i);
				}else{
					if(!this.repeat_playlist){
						return;
					}
					getFirstTrack();
				}
			}else{
				trace('please choose tracks first');
			}
		}
		public function getPreviousTrack():void{
			var i:int;
			//if at beggining don't do
			if(dataProvider){
				if(currentTrack > 0){
					i = currentTrack - 1;
					getTrackAt(i);
				}else{
					i = dataProvider.length - 1;
					getTrackAt(i);					
				}
			}
		}
		public function getLastTrack():void{
			
			var i:int;
			if(dataProvider){
				i = dataProvider.length - 1;
				getTrackAt(i);
			}else{
				trace('please choose tracks first');
			}
		}
		public function getTrackAt(i:int):void{
			if(this.isMoveTrackEnabled){
				//try catch catches errors that are thrown.
				try{
					if(dataProvider.length){
						if(this.isPlaying || this.isPaused)
							this.stop();
							
						this.delayMoveTrackTimer.start();
						this.isMoveTrackEnabled = false;
						this.newSound();
						this.sPosition = '0:00';
						currentTrack = i;
						currentTrackVO = TrackVO(dataProvider.getItemAt(i));
						var _url:String = currentTrackVO.location + '?' + (new Date()).getTime();
						this.url = _url;
						this.play();

						//start the delayViewChange Timer so we can change views if necessarry
						delayViewChangeTimer.start();
						
						var tempDisplayTrack:int = currentTrack + 1;
						
						//trace('currentTrack :' + currentTrack);
					}else{
						trace('please choose tracks first');
					}
				}catch (err:Error){
					trace(err);
					//work around for error
					if( this.isLoading )
						this.stop();
						
					this.getNextTrack();
					trace('There was an error, track was skipped, this is still in beta testing, features are being added, and bugs are being fixed, please be patient');
				}
			}//end if is MoveTrackEnabled...
		}
		
		public function clearList():void{
			stop();
			currentTrack = -1; 
			
			if( dataProvider != null )
				dataProvider.removeAll();
			else
				dataProvider = new ArrayCollection();
				
		}
		/******************************************HANDLERS***********************************************/
		private function enterFrameHandler(event:Event):void {
			  if(soundChannelInstance != null){
			  	if(isPaused || isPaused == 'undefined'){
			  		position = startTime;
			  	}else{
			  		position = soundChannelInstance.position;
			  		this._soundInstancePosition = position;
				  	//trace('[enter_frameInsideIf]'+soundChannelInstance.position);
			  	}
			  	
			  	if( this.sPosition == this.sLength 
			  			&& this._soundInstancePosition != 0 
			  			&& !this.isPaused 
			  			&& !this.delayErrorTimer.running)
			  		this.delayErrorTimer.start();
			  		
			  	//trace('[enter_frameOutsideIf]'+soundChannelInstance.position);
			  	
			  	pMinutes = Math.floor(position / 1000 / 60);
			  	pSeconds = Math.floor(position / 1000) % 60;
			  	sPosition = pMinutes+":"+(pSeconds < 10?"0"+pSeconds:pSeconds);
			  }
		}
		private function onDataChangeHandler(event:CollectionEvent):void{
			if( autoPlay )
				play();
		}
		private function completeHandler(event:Event):void {
			this.dispatchEvent(event);
        }
        
		private function openHandler(event:Event):void {
			this.dispatchEvent(event);
        }

		public function soundCompleteHandler(event:Event):void {
			this._isPlaying = false;
			this.startTime = 0;
			this.stop();
			if(dataProvider.length > 0){
				this.getNextTrack();
			}
		}
		
        private function ioErrorHandler(event:IOErrorEvent):void {
           try{
           	
           }catch(err:Error){
	           trace('in error : ' + err.message);
           }
           //this.dispatchEvent(event);
        }

        private function progressHandler(event:ProgressEvent):void {
        	if(this.soundInstance != null){
	        	this.length = this.soundInstance.length;
				var tempMinutes:Number = Math.floor(this.length  / 1000 / 60);
				var tempSeconds:Number = Math.floor(this.length  / 1000) % 60;
				
				this.sLength = tempMinutes+":"+(tempSeconds < 10?"0"+tempSeconds:tempSeconds);
         	}
         	this.dispatchEvent(event);
        }

	}
}