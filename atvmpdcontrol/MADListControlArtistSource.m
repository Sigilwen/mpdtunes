//
//  MADListControlArtistSource.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 01.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADListControlArtistSource.h"


@implementation MADListControlArtistSource

- (id)initWithScene: (BRRenderScene *) scene
{
	[super initWithScene:scene];

	_mpdConnection = nil;
		
	return ( self );
}

- (void) reload
{
	MpdData* pData = 0;

	[_array removeAllObjects];
	
	if(!_mpdConnection || ![_mpdConnection isConnected] )
		return;
	
	if(! [_mpdConnection commandAllowed:@"list"] )
	{
		[_array addObject: @"Couldn't fetch artist list, check password"];
		return;
	}
					
	[_array addObject: @"All Artists"];
	

	
	for(pData = mpd_database_get_artists([_mpdConnection object] );
		pData != NULL; 
		pData = mpd_data_get_next(pData) )
    {
		if(pData->type == MPD_DATA_TYPE_TAG)
		{
			[_array addObject: [[NSString alloc] initWithCString: pData->tag encoding:NSUTF8StringEncoding ] ];
		}
    }
	
	// pData got free'd automatically
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
