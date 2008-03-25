//
//  MPDMultiAlbumArtworkPreviewController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDMultiAlbumArtworkPreviewController.h"
#import "MPDAlbumArtworkManager.h"

@implementation MPDMultiAlbumArtworkPreviewController

- (id)initWithScene: (BRRenderScene *)scene 
           forGenre: (NSString *)genre
          andArtist: (NSString *)artist
           andAlbum: (NSString *)album
            andSong: (NSString *)song
{
  if( [super initWithScene:scene] == nil )
    return nil;
  
  [self setAssets: [[MPDAlbumArtworkManager sharedInstance] getAlbumAssetsForGenre:genre andArtist:artist andAlbum:album andSong:song]];
  
//  [self _updateCoverArt:@"foo"];
  
  return self;
}

@end
