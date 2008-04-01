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
    
    _names = [[NSMutableArray alloc] initWithObjects: @"Shuffle", nil];
    
    if( artist == nil )
      _artists = [[NSMutableArray alloc] initWithObjects: @"Shuffle", nil];
    
    if( album == nil )
      _albums = [[NSMutableArray alloc] initWithObjects: @"Shuffle", nil];
    
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
  BRAdornedMenuItemLayer *result;
  if( row == 0 )
    result = [BRAdornedMenuItemLayer adornedShuffleMenuItemWithScene: [self scene]];
  else
    result = [BRAdornedMenuItemLayer adornedMenuItemWithScene: [self scene]];
  [[result textItem] setTitle: [self titleForRow: row]];
  return result;
}

/** play */
- (void) itemSelected: (long) row
{
  [self itemPlay:row];
}


/** fast-fwd */
- (void) itemPlay: (long)row
{
  if( row >= [_names count] )
    return;
  
  mpd_playlist_clear([_mpdConnection object]);
  [self addToPlaylistGenre:_genre andArtist:_artist andAlbum:_album andSong:nil];
  
  int songId = -1;
  if( row != 0 )  // not "Shuffle"
  {
    mpd_player_set_random([_mpdConnection object], NO);
    
    mpd_Song* pSong = mpd_playlist_get_song_from_pos([_mpdConnection object], row-1);
    songId = pSong->id;
    mpd_freeSong(pSong);
    
/*
    NSString *song = [_names objectAtIndex: row];
    MpdData *data;
    for( data = [_mpdConnection mpdSearchGenre:_genre andArtist:_artist andAlbum:_album andSong:song];
         data != NULL;
         data = [_mpdConnection mpdSearchNext: data] )
    {
      if( data->type == MPD_DATA_TYPE_SONG )
      {
        songId = data->song->id;
        [_mpdConnection mpdSearchFree:data];
        break;
      }
    }
*/
  }
  else
  {
    mpd_player_set_random([_mpdConnection object], YES);
    // XXX should randomly pick first song..
  }
  
  printf("mpd_player_play_id(%d)\n", songId);
  mpd_player_play_id([_mpdConnection object], songId);
  
}


- (id<BRMediaPreviewController>) previewControllerForItem: (long) item
{
  NSString *artist = (_artist != nil) ? _artist : ((item == 0) ? nil : [_artists objectAtIndex:item]);
  NSString *album  = (_album != nil)  ? _album  : ((item == 0) ? nil : [_albums objectAtIndex:item]);
  NSString *song   = (item == 0) ? nil : [self titleForRow:item];
  return [self previewControllerForArtist:artist andAlbum:album andSong:song];
}

@end
