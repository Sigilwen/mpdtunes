//
//  MADListControlAlbumSource.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 01.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADListControlAlbumSource.h"


@implementation MADListControlAlbumSource

- (id)initWithScene: (BRRenderScene *) scene
{
	[super initWithScene:scene];
	
	_mpdConnection = nil;
	_sArtist = nil;
	
	return ( self );
}

- (void) dealloc
{
	[_sArtist release];
	[super dealloc];
}

- (void)setMpdConnection:(MPDConnection*)mpdConnection;
{
	_mpdConnection = mpdConnection;
}

- (void)setArtist:(NSString*)sArtist
{
	_sArtist = [sArtist retain];
	[self reload];
}

- (void) reset
{
	if(_sArtist)
		[_sArtist release];
	
	_sArtist = nil;
	
	[self reload];
}

- (void)reload
{
	MpdData* pData = 0;
	char* cArtist = 0;
	
	[_array removeAllObjects];
	
	if(!_mpdConnection || ![_mpdConnection isConnected] )
		return;
	
	if(! [_mpdConnection commandAllowed:@"list"] )
	{
		[_array addObject: @"Couldn't fetch album list, check password"];
		return;
	}

	if(_sArtist != nil)
		cArtist = (char*)[_sArtist cStringUsingEncoding:NSUTF8StringEncoding];
	
	[_array addObject: @"All Albums"];
	
	for(pData = mpd_database_get_albums([_mpdConnection object],cArtist);
		pData != NULL; 
		pData = mpd_data_get_next(pData) )
    {
		if(pData->type == MPD_DATA_TYPE_TAG)
		{
			[_array addObject: [[NSString alloc] initWithCString: pData->tag encoding:NSUTF8StringEncoding ] ];
		}
    }

}


@end
