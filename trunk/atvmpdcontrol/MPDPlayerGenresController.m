//
//  MPDPlayerGenresController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDPlayerGenresController.h"
#import "MPDPlayerArtistsController.h"
#import "libmpd/libmpd.h"


@implementation MPDPlayerGenresController

- (id) initWithScene: (BRRenderScene *) scene mpdConnection: (MPDConnection *) mpdConnection;
{
  if( [super initWithScene: scene] == nil )
    return nil;
  
  [self setMpdConnection: mpdConnection];
  [self setListTitle: @"Genres"];
  
  if( ! [_mpdConnection commandAllowed:@"list"] )
  {
    [_names addObject: @"Couldn't fetch genre list, check password"];
  }
  else
  {
    MpdData *data;
    
    _names = [[NSMutableArray alloc] initWithObjects: @"All", nil];
    
    for( data = [self mpdSearchTag:MPD_TAG_ITEM_GENRE forGenre:nil andArtist:nil andAlbum:nil andSong:nil];
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
  NSString *genre = nil;
  MPDPlayerController *controller = nil;
  
  if( row >= [_names count] )
    return;
  
  if( row != 0 )
    genre = [_names objectAtIndex: row];
  
  controller = [[MPDPlayerArtistsController alloc] initWithScene: [self scene] mpdConnection: _mpdConnection genre: genre];
  [controller autorelease];
  [[self stack] pushController: controller];
}

- (void) itemPlay: (long)row
{
  NSString *genre = nil;
  
  if( row >= [_names count] )
    return;
  
  if( row != 0 )
    genre = [_names objectAtIndex: row];
  
  [self addToPlaylistGenre:genre andArtist:nil andAlbum:nil andSong:nil];
}

@end
