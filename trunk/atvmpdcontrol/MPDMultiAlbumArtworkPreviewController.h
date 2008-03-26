//
//  MPDAlbumArtworkPreviewController.h
//  mpdctrl
//
//  Created by Rob Clark on 3/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BRCoverArtPreviewController.h>

/**
 * Class supporting displaying multiple album cover previews without metadata.
 */
@interface MPDMultiAlbumArtworkPreviewController : BRCoverArtPreviewController {
  NSString *_genre;
  NSString *_artist;
  NSString *_album;
  NSString *_song;
}

/**
 * genre/artist/album/song are all optional..
 */
- (id)initWithScene: (BRRenderScene *)scene 
           forGenre: (NSString *)genre
          andArtist: (NSString *)artist
           andAlbum: (NSString *)album
            andSong: (NSString *)song;


@end
