//
//  MPDPlayerGenresController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDPlayerGenresController.h"


@implementation MPDPlayerGenresController
- (id) initWithScene: (BRRenderScene *) scene
{
  if( [super initWithScene: scene] == nil )
    return nil;
  
  [self setListTitle: @"Genres"];
  
  _names = [[NSMutableArray alloc] initWithObjects: @"All", @"One", @"Two", @"Three", nil];
  
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
  if( row >= [_names count] )
    return nil;
  BRAdornedMenuItemLayer *result = [BRAdornedMenuItemLayer adornedFolderMenuItemWithScene: [self scene]];
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
  printf("not implemented: %d\n", row);
}

@end
