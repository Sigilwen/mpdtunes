//
//  MPDPlayerAlbumsController.h
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MPDPlayerController.h"

@interface MPDPlayerAlbumsController : MPDPlayerController {
  NSString *_genre;
  NSString *_artist;
}

- (id) initWithScene: (BRRenderScene *) scene 
    mpdConnection: (MPDConnection *) mpdConnection 
    genre: (NSString *)genre
    artist: (NSString *)artist;
- (id) itemForRow: (long) row;
- (void) itemSelected: (long) row;
- (void) itemPlay: (long)row;

@end
