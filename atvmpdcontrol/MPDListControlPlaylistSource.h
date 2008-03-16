//
//  MPDListControlPlaylistSource.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MADListControlArrayDataSource.h"
#import "MPDConnection.h"

@interface MPDListControlPlaylistSource : MADListControlArrayDataSource {
	MPDConnection*			_mpdConnection;
}

- (id)initWithScene: (BRRenderScene *) scene;

- (void) reload;
- (void) reset;

- (void) setMpdConnection:(MPDConnection*)mpdConnection;

@end
