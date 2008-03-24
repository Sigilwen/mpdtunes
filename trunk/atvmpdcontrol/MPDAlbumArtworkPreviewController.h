//
//  MPDAlbumArtworkPreviewController.h
//  mpdctrl
//
//  Created by Rob Clark on 3/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BRMetadataPreviewController.h>

@interface MPDAlbumArtworkPreviewController : BRMetadataPreviewController {
  NSTimer *_refreshTimer;
  
  NSString *_album;
  NSString *_artist;
  NSString *_song;
}

- (id)initWithScene: (BRRenderScene *)scene 
          forArtist: (NSString *)artist
           andAlbum: (NSString *)album
            andSong: (NSString *)song;


@end
