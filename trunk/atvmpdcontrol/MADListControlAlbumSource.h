//
//  MADListControlAlbumSource.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 01.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "libmpd/libmpd.h"
#import "MADListControlArrayDataSource.h"
#import "MPDConnection.h"

@interface MADListControlAlbumSource : MADListControlArrayDataSource {
	MPDConnection*	_mpdConnection;
	NSString*		_sArtist;
}

- (id)initWithScene: (BRRenderScene *) scene;
- (void)dealloc;

- (void)setArtist: (NSString *)sArtist;

- (void)setMpdConnection:(MPDConnection*)mpdConnection;
- (void)reload;
- (void)reset;

@end
