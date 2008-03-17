//
//  MPDPlayerSongsController.h
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MPDPlayerController.h"

@interface MPDPlayerSongsController : MPDPlayerController {
  NSString *_genre;
  NSString *_artist;
  NSString *_album;
}

- (id) initWithScene: (BRRenderScene *) scene 
    mpdConnection: (MPDConnection *) mpdConnection 
    genre: (NSString *)genre
    artist: (NSString *)artist
    album: (NSString *)album;
- (id) itemForRow: (long) row;
- (void) itemSelected: (long) row;

@end

