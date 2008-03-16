//
//  MPDListControlPlaylistSource.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDListControlPlaylistSource.h"


@implementation MPDListControlPlaylistSource

- (id)initWithScene: (BRRenderScene *) scene
{
	[super initWithScene:scene];

	_mpdConnection = nil;
		
	return ( self );
}

- (void) reload
{
	int i;
	[_array removeAllObjects];
	
	if(!_mpdConnection || ![_mpdConnection isConnected] )
		return;
		
	if([_mpdConnection commandAllowed:@"add"] )
	{
		[_array addObject: @"Add Song(s)"];
		[_rightArray addObject:@""];
	}
	
	int numSongs = mpd_playlist_get_playlist_length([_mpdConnection object]);
	
	for(i=0;i<numSongs;i++)
	{
		mpd_Song* pSong = mpd_playlist_get_song_from_pos([_mpdConnection object], i);
		if(!pSong)
			break;
		if(pSong->time != MPD_SONG_NO_TIME)
		{
		
			NSString *str = [NSString stringWithFormat:@"( %i:%02i )",pSong->time/60, pSong->time%60];
			
			[str retain];
			
			[_rightArray addObject:str];
		}
		else
			[_rightArray addObject:@""];
			
		NSString* strTitle;
		if(pSong->title == 0)
			strTitle = [NSString stringWithCString: pSong->file encoding:NSUTF8StringEncoding ];
		else
			strTitle = [NSString stringWithCString: pSong->title encoding:NSUTF8StringEncoding ];
		
		if(pSong->artist != 0)
		{
			NSString * strArtist = [NSString stringWithCString: pSong->artist encoding:NSUTF8StringEncoding ];
			[_array addObject: [NSString stringWithFormat:@"( %@ ) %@", strArtist, strTitle ] ];
		}
		else
			[_array addObject: strTitle ];
	

	}
}

- (void) reset
{
	[self reload];
}

- (void) setMpdConnection:(MPDConnection*)mpdConnection;
{
	_mpdConnection = mpdConnection;
}


@end
