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
    
    _names = [[NSMutableArray alloc] initWithObjects: @"All", nil];
    
    for( data = [self mpdSearchTag:MPD_TAG_ITEM_ALBUM forGenre:genre andArtist:artist andAlbum:nil andSong:nil];
         data != NULL;
         data = [self mpdSearchNext: data] )
    {
      if( data->type == MPD_DATA_TYPE_TAG )
        [_names addObject: [[NSString alloc] initWithCString: data->tag encoding:NSUTF8StringEncoding]];
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
  
  [self addToPlaylistGenre:_genre andArtist:_artist andAlbum:album andSong:nil];
}


- (id<BRMediaPreviewController>) previewControllerForItem: (long) item
{
  printf("previewControllerForItem: %d\n", item);
  NSString *album = [self titleForRow:item];
  return [self previewControllerForAlbum:album andArtist:_artist];
}


@end
