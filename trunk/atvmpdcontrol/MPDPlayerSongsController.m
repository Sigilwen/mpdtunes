//
//  MPDPlayerSongsController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDPlayerSongsController.h"


@implementation MPDPlayerSongsController
- (id) initWithScene: (BRRenderScene *) scene 
    mpdConnection: (MPDConnection *) mpdConnection 
    genre: (NSString *)genre
    artist: (NSString *)artist
    album: (NSString *)album;
{
  if( [super initWithScene: scene] == nil )
    return nil;
  
  [self setMpdConnection: mpdConnection];
  
  _genre = genre;
  _artist = artist;
  _album = album;
  if( _album == NULL )
    [self setListTitle: @"Songs"];
  else
    [self setListTitle: _album];
  
  if( ! [_mpdConnection commandAllowed:@"list"] )
  {
    [_names addObject: @"Couldn't fetch artist list, check password"];
  }
  else
  {
    MpdData *data;
    
    _names = [[NSMutableArray alloc] initWithObjects: @"All", nil];
    
    if( artist == nil )
      _artists = [[NSMutableArray alloc] initWithObjects: @"All", nil];
    
    if( album == nil )
      _albums = [[NSMutableArray alloc] initWithObjects: @"All", nil];
    
    for( data = [_mpdConnection mpdSearchGenre:genre andArtist:artist andAlbum:album andSong:nil];
         data != NULL;
         data = [_mpdConnection mpdSearchNext: data] )
    {
      if( data->type == MPD_DATA_TYPE_SONG )
      {
        [_names addObject: str2nsstr(data->song->title)];
        if( artist == nil )
          [_artists addObject: str2nsstr(data->song->artist)];
        if( album == nil )
          [_albums addObject:  str2nsstr(data->song->album)];
      }
    }
    // last mpdSearchNext: free's the search
  }
  
  // set the datasource *after* you've setup your array....
  [[self list] setDatasource: self];
  
  return self;
}

- (id) itemForRow: (long) row
{
  if( row >= [_names count] )
    return nil;
  BRAdornedMenuItemLayer *result = [BRAdornedMenuItemLayer adornedMenuItemWithScene: [self scene]];
  [[result textItem] setTitle: [self titleForRow: row]];
  return result;
}

- (void) itemSelected: (long) row
{
  [self itemPlay:row];
}


- (void) itemPlay: (long)row
{
  NSString *song = nil;
  
  if( row >= [_names count] )
    return;
  
  if( row != 0 )
    song = [_names objectAtIndex: row];
  
  [self addToPlaylistGenre:_genre andArtist:_artist andAlbum:_album andSong:song];
}


- (id<BRMediaPreviewController>) previewControllerForItem: (long) item
{
  NSString *artist = (_artist != nil) ? _artist : ((item == 0) ? nil : [_artists objectAtIndex:item]);
  NSString *album  = (_album != nil)  ? _album  : ((item == 0) ? nil : [_albums objectAtIndex:item]);
  NSString *song   = (item == 0) ? nil : [self titleForRow:item];
  return [self previewControllerForArtist:artist andAlbum:album andSong:song];
}

@end
