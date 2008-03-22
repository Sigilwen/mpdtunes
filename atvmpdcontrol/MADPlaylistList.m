//
//  MADPlaylistList.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADPlaylistList.h"
#import "MPDStatusController.h"

@implementation MADPlaylistList

- (id)initWithScene:(BRRenderScene*)scene
{
	if( [super initWithScene:scene] == nil)
		return nil;
		
	_eventReceiver = nil;
	_mpdConnection = nil;
	_target = nil;
	
	_modeRemoveSongs = FALSE;
	
	[super setDatasource:self];
	
	return (self);
}

- (void)dealloc
{
//	[_eventReceiver release];
	[super dealloc];
}

- (void)setTarget:(id)target
{
	_target = target;
}

- (id)target
{
	return _target;
}

- (void)setDeactObject:(id)deactObject;
{
	_eventReceiver = (MADDeactivateableControl*)deactObject;
}

- (BOOL)brEventAction:(BREvent*)event
{
	int ret =  [_eventReceiver processEvent:event];
	
	if(ret == -1)
		return NO;
	
	if(ret == 1)
		return YES;
		
	BREventPageUsageHash hash = [event pageUsageHash];

	if([event value] == 1)
	{
		if(hash == kBREventTapPlayPause)
		{
			int sel = [self selection];
			if([_mpdConnection commandAllowed:@"delete" ] )
			{
				if(sel == 0)
				{
					_modeRemoveSongs = !_modeRemoveSongs;
					[self reload];
					[[self scene] renderScene];
					return YES;
				}
				else
					sel -= 1;
			}
			
			if(_modeRemoveSongs)
			{
				mpd_playlist_delete_pos([_mpdConnection object],sel);
				[self reload];
				[[self scene] renderScene];
			}
			else
			{
				mpd_Song* pSong = mpd_playlist_get_song_from_pos([_mpdConnection object],sel);
				int songId = pSong->id;
				
				mpd_freeSong(pSong);
				
				mpd_player_play_id([_mpdConnection object], songId);
			}
		}
	}
	
	return [super brEventAction:event];
}

- (void)setMpdConnection:(MPDConnection*)mpdConnection
{
	_mpdConnection = mpdConnection;
}

- (id) itemForRow: (long) row
{
	if([_mpdConnection commandAllowed:@"delete" ] )
	{
		if(row == 0)
		{
			if(_modeRemoveSongs)
				return [self createItemWithText:@"Select mode"];
			else
				return [self createItemWithText:@"Remove mode"];
		}
		row -= 1;
	}
	
	
	mpd_Song* pSong = mpd_playlist_get_song_from_pos([_mpdConnection object],row);
	
	if(!pSong)
		return nil;
		
	id item = nil;
	NSString * rightText = nil;
		
	if(pSong->time != MPD_SONG_NO_TIME)
	{
		rightText = [NSString stringWithFormat:@"( %i:%02i )",pSong->time/60, pSong->time%60];
	}
		
	NSString* strTitle;
	if(pSong->title == 0)
		strTitle = [NSString stringWithCString: pSong->file encoding:NSUTF8StringEncoding ];
	else
		strTitle = [NSString stringWithCString: pSong->title encoding:NSUTF8StringEncoding ];
	
	if(pSong->artist != 0)
	{
		NSString * strArtist = [NSString stringWithCString: pSong->artist encoding:NSUTF8StringEncoding ];
		item = [self createItemWithText: [NSString stringWithFormat:@"( %@ ) %@", strArtist, strTitle ] 
					 rightJustifiedText: rightText ];
	}
	else
		item = [self createItemWithText: strTitle ];
		
		
	mpd_freeSong(pSong);
	
	return item;
}

- (long) itemCount
{
	int count = 0;
	if(!_mpdConnection || ![_mpdConnection isConnected] )
		return count;

	if([_mpdConnection commandAllowed:@"delete" ] )
		count += 1;
	
	count += mpd_playlist_get_playlist_length([_mpdConnection object]);
	return count;
}

-(id<BRMenuItemLayer>)createItemWithText:(NSString*)text
{
	return [self createItemWithText:text rightJustifiedText:nil];
}

-(id<BRMenuItemLayer>)createItemWithText:(NSString*)text rightJustifiedText:(NSString*)rText
{
	BRTextMenuItemLayer* item = [[BRTextMenuItemLayer alloc] initWithScene: _scene];
	
	if(rText != nil)
		[item setRightJustifiedText:rText];
	
	[item setTitle: text centered:NO];
	[item setArrowDisabled:YES];
	
	return [item autorelease];
}

- (NSString *) titleForRow: (long) row
{
	return nil;
}

- (long) rowForTitle: (NSString *) title
{
	return -1;
}


@end
