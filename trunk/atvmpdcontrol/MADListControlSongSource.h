//
//  MADListControlSongSource.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 01.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "libmpd/libmpd.h"
#import "MADListControlArrayDataSource.h"
#import "MPDConnection.h"

@interface MADListControlSongSource : MADListControlArrayDataSource {
	MPDConnection*	_mpdConnection;
	NSString*		_artist;
	NSString*		_album;
	
	NSMutableArray*	_currentSongIds;
}

- (void)dealloc;
- (id)initWithScene: (BRRenderScene *) scene;

- (void)reload;
- (void)reset;
- (void)setMpdConnection:(MPDConnection*)mpdConnection;

- (void)setArtist: (NSString *)sArtist;
- (void)setAlbum: (NSString *)sAlbum;

- (NSMutableArray*)getCurrentSongIds;

@end
