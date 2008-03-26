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
  
  _genre  = genre;
  _artist = artist;
  _album  = album;
  _song   = song;
  
  [self setAssets: [[MPDAlbumArtworkManager sharedInstance] getAlbumAssetsForGenre:_genre andArtist:_artist andAlbum:_album andSong:_song]];
  
  return self;
}


// called once we are on screen:
- (void)activate
{
  int i, cnt = [_assets count];
  for( i=0; i<cnt; i++ )
    [[_assets objectAtIndex:i] setListener:self];
  [super activate];
}

// called when we are about to go off screen:
- (void)willDeactivate
{
  int i, cnt = [_assets count];
  for( i=0; i<cnt; i++ )
    [[_assets objectAtIndex:i] setListener:nil];
  [super willDeactivate];
}

- (void)imageLoaded
{
  printf("imageLoaded\n");
  [self setAssets:_assets];
  [_mainLayer setNeedsUpdates:YES];
  [_frontmostLayer setImage:[[_assets objectAtIndex:0] coverArt]];
}

@end
