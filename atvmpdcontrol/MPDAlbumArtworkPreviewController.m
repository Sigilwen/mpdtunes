//
//  MPDAlbumArtworkPreviewController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDAlbumArtworkPreviewController.h"

#import "MPDAlbumArtworkManager.h"

////////////////////////////////////////////////////////////////////////////////
@interface BRMetadataLayer (MPDBRMetadataExtensions)
- (void)addMetaData:(id)object forLabel:(id)label;
@end
@implementation BRMetadataLayer (MPDBRMetadataExtensions)
- (void)addMetaData:(id)object forLabel:(id)label
{
  NSMutableArray *labels  = _metadataLabels ? [_metadataLabels mutableCopy] : [NSMutableArray array];
  NSMutableArray *objects = _metadataObjs   ? [_metadataObjs mutableCopy]   : [NSMutableArray array];
  
  [labels addObject:label];
  [objects addObject:object];
  
  NSLog(@"labels=%@, objects=%@", labels, objects);
  
  [self setMetadata:objects withLabels:labels];
//  [self _setMetadata:objects withLabels:labels updateFrame:YES];
}
@end
////////////////////////////////////////////////////////////////////////////////


@implementation MPDAlbumArtworkPreviewController

- (id)initWithScene: (BRRenderScene *)scene 
    forAlbum: (NSString *)album
    andArtist: (NSString *)artist;
{
  if( [super initWithScene:scene] == nil )
    return nil;
  
  _album  = album;
  _artist = artist;
  
  _refreshTimer = nil;
  
  printf("metadataLayer: 0x%08x\n", _metadataLayer);
  
  [self setAsset: [[MPDAlbumArtworkManager sharedInstance] getAlbumAsset:album forArtist:artist]];
//  [self setShowsMetadataImmediately:NO];
//  [self _showMetadataWithAnimation:YES];
  [self setDeletterboxAssetArtwork:YES];  // ???
  
  return self;
}

- (BOOL)_assetHasMetadata   /* ??? XXX */
{
  return YES;
}

-(void)_populateMetadata
{
printf("_populateMetadata\n");
  [super _populateMetadata];
  
  if( _album != nil )
    [_metadataLayer setTitle:_album];
  if( _artist != nil )
    [_metadataLayer addMetaData:_artist forLabel:@"Artist"];
//  [_metadataLayer addMetaData:@"Value 2" forLabel:@"Label 2"];
//  [_metadataLayer addMetaData:@"Value 3" forLabel:@"Size"];
//  [_metadataLayer addMetaData:@"Value 4" forLabel:@"MetadataGenre"];
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
