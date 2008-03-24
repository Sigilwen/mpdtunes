//
//  MPDPlayerArtistsController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDPlayerArtistsController.h"
#import "MPDPlayerAlbumsController.h"


@implementation MPDPlayerArtistsController

- (id) initWithScene: (BRRenderScene *) scene 
    mpdConnection: (MPDConnection *) mpdConnection 
    genre: (NSString *)genre;
{
  if( [super initWithScene: scene] == nil )
    return nil;
  
  [self setMpdConnection: mpdConnection];
  
  _genre = genre;
  if( _genre == NULL )
    [self setListTitle: @"Artists"];
  else
    [self setListTitle: _genre];
  
  if( ! [_mpdConnection commandAllowed:@"list"] )
  {
    [_names addObject: @"Couldn't fetch artist list, check password"];
  }
  else
  {
    MpdData *data;
    
    _names = [[NSMutableArray alloc] initWithObjects: @"All", nil];
    
    for( data = [_mpdConnection mpdSearchTag:MPD_TAG_ITEM_ARTIST forGenre:genre andArtist:nil andAlbum:nil andSong:nil];
         data != NULL;
         data = [_mpdConnection mpdSearchNext: data] )
    {
      if( data->type == MPD_DATA_TYPE_TAG )
        [_names addObject: str2nsstr(data->tag)];
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
  NSString *artist = nil;
  MPDPlayerController *controller = nil;
  
  if( row >= [_names count] )
    return;
  
  if( row != 0 )
    artist = [_names objectAtIndex: row];
  
  controller = [[MPDPlayerAlbumsController alloc] initWithScene: [self scene] mpdConnection:_mpdConnection genre:_genre artist:artist];
  [controller autorelease];
  [[self stack] pushController: controller];
}

- (void) itemPlay: (long)row
{
  NSString *artist = nil;
  
  if( row >= [_names count] )
    return;
  
  if( row != 0 )
    artist = [_names objectAtIndex: row];
  
  [self addToPlaylistGenre:_genre andArtist:artist andAlbum:nil andSong:nil];
}


- (id<BRMediaPreviewController>) previewControllerForItem: (long) item
{
  printf("previewControllerForItem: %d\n", item);
  NSString *artist = [self titleForRow:item];
  return [self previewControllerForAlbum:nil andArtist:artist];
}


@end
