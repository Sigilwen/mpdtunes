//
//  MADListControlArtistSource.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 01.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "libmpd/libmpd.h"
#import "MADListControlArrayDataSource.h"
#import "MPDConnection.h"

@interface MADListControlArtistSource : MADListControlArrayDataSource {
	MPDConnection*			_mpdConnection;
}

- (id)initWithScene: (BRRenderScene *) scene;

- (void) reload;
- (void) reset;

- (void) setMpdConnection:(MPDConnection*)mpdConnection;



@end
