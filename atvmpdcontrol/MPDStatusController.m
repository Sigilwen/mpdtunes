//
//  MPDStatusController.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDStatusController.h"

#import "MADVertLayout.h"
#import "MADHorzLayout.h"

#import "MPDSmallTextControl.h"
#import "MADVerticalProgressBar.h"


@implementation MPDStatusController

- (id)initWithScene:(id)scene
{
    if ( [super initWithScene: scene] == nil )
        return ( nil );
			
	_mpdConnection = nil;
	
	_playerController = [[MPDPlayerController alloc] initWithScene:scene];
	_settingsController = [[MPDSettingsController alloc] initWithScene:scene];
	_playlistController = [[MPDPlaylistOptionsController alloc]initWithScene:scene];
	
	_glControl = [[MADGLControl alloc] initWithScene:scene];
	
	MADHorzLayout*	glLayout = [MADHorzLayout createSafeLayout:scene];
	
	MADVertLayout*  secLayout = [[[MADVertLayout alloc] init]autorelease];
	[glLayout addObject:nil withConstraint:1.0];
	[glLayout addObject:secLayout withSize:70];
	
	[secLayout addObject:_glControl withSize:70];
	
	[self addControl:_glControl];
	
	[glLayout doLayout];

//	float pt41 = (41.0/720)*[scene size].height;

	// Resize font so it resizes with screenres
	float pt22 = (22.0/480)*[scene size].height;
//	float pt20 = (20.0/480)*[scene size].height;
	float pt18 = (18.0/480)*[scene size].height;
	float pt10 = (10.0/480)*[scene size].height;

	_playlistCtrl = [[MADPlaylistList alloc]initWithScene:scene];
	[_playlistCtrl setTarget:self];
	_volumeBar = [[MPDVolumeCtrl alloc]initWithScene:scene];
	_controlBar = [[MPDControlBar alloc]initWithScene:scene];
	[_controlBar setSettingsTarget:self];

	[self addControl:_playlistCtrl leftCtrl:_controlBar rightCtrl:_volumeBar];
	[self addControl:_volumeBar leftCtrl:_playlistCtrl rightCtrl:_controlBar];
	[self addControl:_controlBar topCtrl:_volumeBar bottomCtrl:nil];
	
	MADHorzLayout* masterLayout = [MADHorzLayout createSafeLayout:scene ];
	
	MADVertLayout* layout = [[[MADVertLayout alloc] init] autorelease];
	[masterLayout addObject:layout withConstraint:1.0];
	
	MPDSmallTextControl * header = [[[MPDSmallTextControl alloc]initWithScene:scene withFontSize:pt22] autorelease];
	[header setText:@"Status"];
	
	[layout addObject:[MADHorzLayout createCenterLayout:header] withSizeFromObject:header ];
	[self addControl:header];
	
	[layout addObject:nil withSize:10];
	
	MADHorzLayout* playingLayout = [[[MADHorzLayout alloc]init]autorelease];
	
	MPDSmallTextControl* playingLabel = [[[MPDSmallTextControl alloc]initWithScene:scene withFontSize:pt18]autorelease];
	[playingLabel setText:@"Now playing: "];
	[self addControl:playingLabel];

	[layout addObject:playingLayout withSizeFromObject: playingLabel ];
	
	[playingLayout addObject:playingLabel];
	
	_songLabel = [[MPDSmallTextControl alloc]initWithScene:scene withFontSize:pt18];
	[_songLabel setText:@"Indiana Jones und die tochter des schnitzers"];
	[self addControl:_songLabel];
	
	[playingLayout addObject:_songLabel withConstraint:1.0];
	
	MADHorzLayout* centerLayout = [[[MADHorzLayout alloc]init]autorelease];
	[layout addObject:centerLayout withConstraint:1.0];
	
	////////////////////////////////////////////////////////////////////////////
	// Playlist Ctrl
	[centerLayout addObject:_playlistCtrl withConstraint:1.0];
	
	////////////////////////////////////////////////////////////////////////////
	// Volume Ctrl
	_volumeLabel = [[MPDSmallTextControl alloc]initWithScene:scene];
	[_volumeLabel setText:@"(0%)"];
	[self addControl: _volumeLabel];

	
	_volumeLayout = [[MADVertLayout alloc] init];
	[centerLayout addObject:_volumeLayout withSize:150];
	
	MADHorzLayout* volumeLabelLayout = [[[MADHorzLayout alloc]init]autorelease];
	[_volumeLayout addObject:volumeLabelLayout withSizeFromObject:_volumeLabel]; // Take height from label
	
	[volumeLabelLayout addObject:nil withConstraint:1.0];
	[volumeLabelLayout addObject:_volumeLabel];
	[volumeLabelLayout addObject:nil withConstraint:1.0];
	
	MADHorzLayout* volumeBarLayout = [[[MADHorzLayout alloc]init]autorelease];
	[_volumeLayout addObject:volumeBarLayout withConstraint:1.0]; // Take height from label
	
	[volumeBarLayout addObject:nil withConstraint:1.0];
	[volumeBarLayout addObject:_volumeBar withSize:28];
	[volumeBarLayout addObject:nil withConstraint:1.0];
	
	
	////////////////////////////////////////////////////////////////////////////
	// Time Ctrl
	
	_timeLabel = [[MPDSmallTextControl alloc] initWithScene:scene withFontSize:pt10 withColor:[NSColor greenColor]];
	[_timeLabel setText:@"(00:00)-(79:40)"];
	[self addControl:_timeLabel];      
	_timeLayout = [[MADHorzLayout alloc]init];
	
	[layout addObject:_timeLayout withSizeFromObject:_timeLabel ];
	
	[_timeLayout addObject:nil withConstraint:1.0];
	[_timeLayout addObject:_timeLabel];
	[_timeLayout addObject:nil withSize:115];
	
	
	_progressCtrl = [[MADHorizontalProgressBar alloc] initWithScene:scene];
	[self updateProgressCtrl];
	[self addControl:_progressCtrl];
	
	MADHorzLayout* horzProgressLayout = [[[MADHorzLayout alloc]init]autorelease];
	[layout addObject:horzProgressLayout withSize: 41];
	
	[horzProgressLayout addObject:nil withSize:100];
	[horzProgressLayout addObject:_progressCtrl withConstraint:1.0];
	[horzProgressLayout addObject:nil withSize:100];
	
	
	////////////////////////////////////////////////////////////////////////////
	// Button List
	
	MADHorzLayout* horzButtonLayout = [[[MADHorzLayout alloc]init]autorelease];
	[layout addObject:horzButtonLayout withSize: [[BRThemeInfo sharedTheme] listIconHeight] ];
	[horzButtonLayout addObject:_controlBar withConstraint:1.0];
	
	[masterLayout doLayout];
		
	return ( self );
}

- (void)dealloc
{
	[_controlBar release];
	[_playlistCtrl release];
	[_volumeLayout release];
	[_volumeLabel release];
	[_volumeBar release];
	[_timeLayout release];
	[_timeLabel release];
	[_songLabel release];
	[_progressCtrl release];
	
	[_settingsController release];
	[_playerController release];
	[_playlistController release];
	
	[_glControl release];
	
	[super dealloc];
}

- (id)retain
{
	return [super retain];
}

- (void)release
{
	[super release];
}

- (void)onAction
{
	[[self stack] pushController:_settingsController];
}

- (void)onAddSongPressed
{
	[[self stack] pushController:_playerController];
}

- (void)onEditClicked
{
	[[self stack] pushController:_playlistController];
}

- (void)updateVolumeCtrl
{
	int volume = mpd_status_get_volume([_mpdConnection object]);
	
	if(volume < 0)
		volume = 0;
		
	[_volumeBar setPercent:volume/100.0];
	
	[_volumeLabel setText:[NSString stringWithFormat:@"(%i%%)", volume] ];
	
	[_volumeLayout doLayout];
}

- (void)updateProgressCtrl
{
	
	int total = mpd_status_get_total_song_time([_mpdConnection object]);
	int elapsed = mpd_status_get_elapsed_song_time([_mpdConnection object]);
	
	if(total < 0 || elapsed < 0)
	{
		return;
	}
	
	float percent = ( (float)elapsed / (float)total );
	
	if(percent < 0.0 || percent > 1.0)
		percent = 0.0;
	
	[_progressCtrl setPercent:percent];
	
	NSString *str = [NSString stringWithFormat:@"( %i:%02i ) - ( %i:%02i )",elapsed/60, elapsed%60,	
																			total/60, total%60];
	[_timeLabel setText:str];
	[_timeLayout doLayout];
	
	[[self scene] renderScene];	
}

- (void)updateSongLabel
{
	int songid = mpd_player_get_current_song_id([_mpdConnection object]);
	
	if(songid < 0)
		[_songLabel setText:@""];
	else
	{
		mpd_Song* currentSong = mpd_playlist_get_song([_mpdConnection object], songid);
		
		if(currentSong->title == 0)
		{
			[_songLabel setText: [[NSString alloc] initWithCString: currentSong->file encoding:NSUTF8StringEncoding ] ];
		}
		else
		{
			if(currentSong->artist != 0)
			{
				NSString* title = [NSString stringWithCString:currentSong->title encoding:NSUTF8StringEncoding];
				NSString* artist = [NSString stringWithCString:currentSong->artist encoding:NSUTF8StringEncoding];
				NSString* str = [NSString stringWithFormat:@"%@ - %@", artist, title ];
			
				[_songLabel setText: str];
			}
			else
				[_songLabel setText: [NSString stringWithCString: currentSong->title encoding:NSUTF8StringEncoding ] ];
		}
	}
	
	[[self scene] renderScene];
}

- (void)updatePlaylist
{
	[_playlistCtrl reload];
}

- (void)setMpdConnection:(MPDConnection*)mpdConnection; 
{
	_mpdConnection = mpdConnection;
	
	[_volumeBar setMpdConnection:mpdConnection];
	[_controlBar setMpdConnection:mpdConnection];
	[_playlistCtrl setMpdConnection:mpdConnection];
	[_playerController setMpdConnection:_mpdConnection];
	[_settingsController setMpdConnection:_mpdConnection];
	[_playlistController setMpdConnection:_mpdConnection];
}

- (void) onConnectionLost
{
	// Jump directly back to the root Controller
	[[self stack] popToControllerWithLabel:@"com.apple.frontrow.appliance.axxr.mpdctrl.rootController"];
}

- (void) onStatusChanged:(ChangedStatusType)what
{
	if( what & MPD_CST_SONGID)
	{
		[self updateSongLabel];
	}
	if( what & MPD_CST_ELAPSED_TIME)
	{
		[self updateProgressCtrl];
	}
	if(what & MPD_CST_VOLUME)
	{
		[self updateVolumeCtrl];
	}
	if(what & MPD_CST_PLAYLIST)
	{
		[self updatePlaylist];
	}
	if(what & MPD_CST_STATE)
	{
		[self updateSongLabel];
		[_controlBar reload];
		[[self scene] renderScene];
	}
	
}

- (void) willBePushed
{
	[self updateSongLabel];
	[self updateProgressCtrl];
	[self updateVolumeCtrl];
	[_mpdConnection addStatusListener:self];
	[_mpdConnection addConnectionLostReceiver:self];	
	[super willBePushed];
	[self updatePlaylist];
	
	[_controlBar reload];
}

- (void) willBePopped
{
	[_mpdConnection removeStatusListener:self];
	[_mpdConnection removeConnectionLostReceiver:self];
	[super willBePopped];
}

@end
