//
//  MPDPlayerAlbumsController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDPlayerAlbumsController.h"
#import "MPDPlayerSongsController.h"


@implementation MPDPlayerAlbumsController

- (id) initWithScene: (BRRenderScene *) scene 
    mpdConnection: (MPDConnection *) mpdConnection 
    genre: (NSString *)genre
    artist: (NSString *)artist;
{
  if( [super initWithScene: scene] == nil )
    return nil;
  
  [self setMpdConnection: mpdConnection];
  
  _genre = genre;
  _artist = artist;
  
  if( _artist == NULL )
    [self setListTitle: @"Albums"];
  else
    [self setListTitle: _artist];
  
  if( ! [_mpdConnection commandAllowed:@"list"] )
  {
    [_names addObject: @"Couldn't fetch artist list, check password"];
  }
  else
  {
    MpdData *data;
    const char *cGenre;
    const char *cArtist;
    
    _names = [[NSMutableArray alloc] initWithObjects: @"All", nil];
    
    mpd_database_search_field_start([_mpdConnection object], MPD_TAG_ITEM_ALBUM);
    if( _genre != NULL )
    {
      cGenre = [_genre UTF8String];
      mpd_database_search_add_constraint([_mpdConnection object], MPD_TAG_ITEM_GENRE, cGenre);
    }
    if( _artist != NULL )
    {
      cArtist = [_artist UTF8String];
      mpd_database_search_add_constraint([_mpdConnection object], MPD_TAG_ITEM_ARTIST, cArtist);
    }
    for( data = mpd_database_search_commit([_mpdConnection object]);
        data != NULL;
        data = mpd_data_get_next(data) )
    {
      if( data->type == MPD_DATA_TYPE_TAG )
        [_names addObject: [[NSString alloc] initWithCString: data->tag encoding:NSUTF8StringEncoding]];
    }
    // last mpd_data_get_next() free's the search
  }
  
  // set the datasource *after* you've setup your array....
  [[self list] setDatasource: self];
  
  return self;
}

- (id) itemForRow: (long) row
{
  if( row >= [_names count] )
    return nil;
  BRAdornedMenuItemLayer *result = [BRAdornedMenuItemLayer adornedFolderMenuItemWithScene: [self scene]];
  [[result textItem] setTitle: [_names objectAtIndex: row]];
  return result;
}

- (void) itemSelected: (long) row
{
  NSString *album = nil;
  MPDPlayerController *controller = nil;
  
  if( row >= [_names count] )
    return;
  
  if( row != 0 )
    album = [_names objectAtIndex: row];
  
  controller = [[MPDPlayerSongsController alloc] initWithScene: [self scene] mpdConnection:_mpdConnection genre:_genre artist:_artist album:album];
  [controller autorelease];
  [[self stack] pushController: controller];
}

- (void) itemPlay: (long)row
{
  NSString *album = nil;
  
  if( row >= [_names count] )
    return;
  
  if( row != 0 )
    album = [_names objectAtIndex: row];
  
  [self addToPlaylist:_mpdConnection genre:_genre artist:_artist album:album song:nil];
}


- (id<BRMediaPreviewController>) previewControllerForItem: (long) item
{
  printf("previewControllerForItem: %d\n", item);
  NSString *album = [self titleForRow:item];
  return [self previewControllerForAlbum:album andArtist:_artist];
}


@end
