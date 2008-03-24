//
//  MPDAlbumArtworkPreviewController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDAlbumArtworkPreviewController.h"

#import "MPDPlayerController.h"
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
  
  [self setMetadata:objects withLabels:labels];
//  [self _setMetadata:objects withLabels:labels updateFrame:YES];
}
@end
////////////////////////////////////////////////////////////////////////////////


@implementation MPDAlbumArtworkPreviewController

- (id)initWithScene: (BRRenderScene *)scene 
          forArtist: (NSString *)artist
           andAlbum: (NSString *)album
            andSong: (NSString *)song
{
  if( [super initWithScene:scene] == nil )
    return nil;
  
  _album  = album;
  _artist = artist;
  _song   = song;
  
  _refreshTimer = nil;
  
  [self setAsset: [[MPDAlbumArtworkManager sharedInstance] getAlbumAsset:album forArtist:artist]];
  if(song)
    [self setShowsMetadataImmediately:YES];
//[self setDeletterboxAssetArtwork:YES];  // ???
  
  return self;
}

- (BOOL)_assetHasMetadata   /* ??? XXX */
{
  return YES;
}

-(void)_populateMetadata
{
  [super _populateMetadata];
  
  NSString *genre = nil;
  int ntracks = 0;
  int length = 0;
  
  MPDConnection *mpdConnection = [MPDConnection sharedInstance];
  MpdData *data;
  
  NSLog(@"starting search: %@ %@ %@\n", _album, _artist, _song);
  for( data = [mpdConnection mpdSearchGenre:nil andArtist:_artist andAlbum:_album andSong:_song];
       data != NULL;
       data = [mpdConnection mpdSearchNext: data] )
  {
    if( data->type == MPD_DATA_TYPE_SONG )
    {
      ntracks++;
      if( data->song->genre && !genre )
        genre = str2nsstr(data->song->genre);
      length += data->song->time;
    }
  }
  NSLog(@"done search\n");
  
  if( ntracks > 0 )
  {
    if(_song)
    {
      [_metadataLayer setTitle:_song];
      if(_album)
        [_metadataLayer addMetaData:_album forLabel:@"Album"];
      if(_artist)
        [_metadataLayer addMetaData:_artist forLabel:@"Artist"];
      if(genre)
        [_metadataLayer addMetaData:genre forLabel:@"Genre"];
      [_metadataLayer addMetaData:[NSString stringWithFormat:@"%d:%d:%d", (length/3600), ((length/60)%60), (length % 60)] forLabel:@"Length"];
    }
    else if(_album)
    {
      [_metadataLayer setTitle:_album];
      if(_artist)
        [_metadataLayer addMetaData:_artist forLabel:@"Artist"];
      if(genre)
        [_metadataLayer addMetaData:genre forLabel:@"Genre"];
      [_metadataLayer addMetaData:[NSString stringWithFormat:@"%d", ntracks] forLabel:@"Tracks"];
      [_metadataLayer addMetaData:[NSString stringWithFormat:@"%d:%d:%d", (length/3600), ((length/60)%60), (length % 60)] forLabel:@"Length"];
    }
  }
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
