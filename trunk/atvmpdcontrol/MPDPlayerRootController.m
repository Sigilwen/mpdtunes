//
//  MPDPlayerRootController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDPlayerRootController.h"
#import "MPDPlayerGenresController.h"


@implementation MPDPlayerRootController

enum {
  ID_SHUFFLE = 0,
  ID_PLAYLISTS,
  ID_ARTISTS,
  ID_ALBUMS,
  ID_SONGS,
  ID_GENRES
};

- (id) initWithScene: (BRRenderScene *) scene
{
  if( [super initWithScene: scene] == nil )
    return nil;
  
  [self setListTitle: @"Rob's Menu"];
  
  _names = [[NSMutableArray alloc] initWithObjects: @"Shuffle", @"Playlists", @"Artists", @"Albums", @"Songs", @"Genres", nil];
  
  // set the datasource *after* you've setup your array....
  [[self list] setDatasource: self];
  
  return self;
}

- (void) dealloc
{
  [_names release];
  [super dealloc];
}

- (long) itemCount
{
  return [_names count];
}

- (id) itemForRow: (long) row
{
  BRAdornedMenuItemLayer *result = nil;
  switch(row)
  {
    case ID_SHUFFLE: 
      result = [BRAdornedMenuItemLayer adornedShuffleMenuItemWithScene: [self scene]];
      break;
    case ID_PLAYLISTS:
    case ID_ARTISTS:
    case ID_ALBUMS:
    case ID_SONGS:
    case ID_GENRES:
      result = [BRAdornedMenuItemLayer adornedFolderMenuItemWithScene: [self scene]];
      break;
    default:
      return nil;
  }
  
  [[result textItem] setTitle: [_names objectAtIndex: row]];
  
  return result;
}

- (NSString *) titleForRow: (long) row
{
  if( row > [_names count] )
    return ( nil );
  return [_names objectAtIndex: row];
}

- (void) itemSelected: (long) row
{
  id controller = nil;
  
  switch(row)
  {
    case ID_SHUFFLE: 
    case ID_PLAYLISTS:
    case ID_ARTISTS:
    case ID_ALBUMS:
    case ID_SONGS:
      printf("not implemented: %d\n", row);
      break;
    case ID_GENRES:
      controller = [[MPDPlayerGenresController alloc] initWithScene: [self scene]];
      break;
  }
  
  if( controller != nil )
  {
    [controller autorelease];
    [[self stack] pushController: controller];
  }
}


@end
