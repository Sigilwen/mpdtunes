//
//  MPDAlbumArtworkPreviewController.h
//  mpdctrl
//
//  Created by Rob Clark on 3/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BRMetadataPreviewController.h>

/**
 * Class supporting displaying single album cover preview with album or
 * song metadata.
 */
@interface MPDAlbumArtworkPreviewController : BRMetadataPreviewController {
  NSString *_album;
  NSString *_artist;
  NSString *_song;
}

- (id)initWithScene: (BRRenderScene *)scene 
          forArtist: (NSString *)artist
           andAlbum: (NSString *)album
            andSong: (NSString *)song;


@end
