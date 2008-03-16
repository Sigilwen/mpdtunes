//
//  MADListControlSongSource.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 01.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADListControlSongSource.h"


@implementation MADListControlSongSource

- (id)initWithScene: (BRRenderScene *) scene
{
	[super initWithScene:scene];
	
	_artist = nil;
	_album = nil;
	
	_currentSongIds = [[NSMutableArray alloc]init];
	
	_mpdConnection = nil;
	
	return ( self );
}

- (void)dealloc
{
	[_currentSongIds release];
	[_artist release];
	[_album release];
	[super dealloc];
}

- (void)setMpdConnection:(MPDConnection*)mpdConnection;
{
	_mpdConnection = mpdConnection;
}

- (void) reset
{
	if(_artist)
		[_artist release];
	_artist = nil;
	
	if(_album)
		[_album release];
	_album = nil;
		
	[self reload];
}

- (NSMutableArray*)getCurrentSongIds
{
	return ( _currentSongIds );
}

- (void)reload
{
	MpdData* pData = 0;
	
	[_array removeAllObjects];
	[_rightArray removeAllObjects];
	
	[_currentSongIds removeAllObjects];
	
	[_array addObject: @"Add all Songs"];
	[_rightArray addObject:@""];
	
	if(!_mpdConnection || ![_mpdConnection isConnected] )
		return;
	
	if(! [_mpdConnection commandAllowed:@"listallinfo"] )
	{
		[_array addObject: @"Couldn't fetch song list, check password"];
		return;
	}		
		
	for(pData = mpd_database_get_complete([_mpdConnection object]);
		pData != NULL; 
		pData = mpd_data_get_next(pData) )
    {
		if(pData->type == MPD_DATA_TYPE_SONG)
		{
			if(_artist != nil)
			{
				if(pData->song->artist == 0)
					continue;
				else if([_artist compare:[NSString stringWithCString:pData->song->artist encoding:NSUTF8StringEncoding]  options:0] != NSOrderedSame)
					continue;
			}
			if(_album != nil)
			{
				if(pData->song->album == 0)
					continue;
				else if([_album compare:[NSString stringWithCString:pData->song->album encoding:NSUTF8StringEncoding] options:0] != NSOrderedSame)
					continue;			
			}

			[_currentSongIds addObject: [NSString stringWithCString:pData->song->file encoding:NSUTF8StringEncoding] ];
			
			if(pData->song->time != MPD_SONG_NO_TIME)
			{
			
				NSString *str = [NSString stringWithFormat:@"( %i:%02i )",pData->song->time/60, pData->song->time%60];
				
				[str retain];
				
				[_rightArray addObject:str];
			}
			else
				[_rightArray addObject:@""];
				
			if(pData->song->title == 0)
			{
				[_array addObject: [NSString stringWithCString: pData->song->file encoding:NSUTF8StringEncoding ] ];
			}
			else
				[_array addObject: [NSString stringWithCString: pData->song->title encoding:NSUTF8StringEncoding ] ];
			
		}
    }		
}

- (void)setArtist: (NSString *)sArtist
{
	_artist = [sArtist retain];
	[self reload];
}


- (void)setAlbum: (NSString *)sAlbum
{
	_album = [sAlbum retain];
	[self reload];
}



@end
