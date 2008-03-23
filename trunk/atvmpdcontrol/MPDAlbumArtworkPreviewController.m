//
//  MPDAlbumArtworkPreviewController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDAlbumArtworkPreviewController.h"

#import "MPDAlbumArtworkManager.h"


@implementation MPDAlbumArtworkPreviewController

- (id)initWithScene: (BRRenderScene *)scene 
    forAlbum: (NSString *)album
    andArtist: (NSString *)artist;
{
  if( [super initWithScene: scene] == nil )
    return nil;
  
  _refreshTimer = nil;
  
  [self setAsset: [[MPDAlbumArtworkManager sharedInstance] getAlbumAsset:album forArtist:artist]];
  [self setShowsMetadataImmediately:YES];
  
  return self;
}

- (void)startTimer
{
  if( _refreshTimer == nil )
  {
    // start timer:
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 
                                                     target:self
                                                   selector:@selector(onRefreshTimer)
                                                   userInfo: nil
                                                    repeats:YES ];
    [_refreshTimer retain];
  }
}

- (void)stopTimer
{
  if( _refreshTimer != nil )
  {
    // stop timer:
    [_refreshTimer invalidate];
    [_refreshTimer release];
    _refreshTimer = nil;
  }
}

// called on timer
- (void)onRefreshTimer
{
  if( ![_asset waitingForUpdate] )
  {
    [self stopTimer];
    printf("done waiting for image\n");
    [self _updateCoverArtLayerWithImage: [_asset coverArt]];
  }
}

// called once we are on screen:
- (void)activate
{
  if( [_asset waitingForUpdate] )
    [self startTimer];
  [super activate];
}

// called when we are about to go off screen:
- (void)willDeactivate
{
  [self stopTimer];
  [super willDeactivate];
}


@end
