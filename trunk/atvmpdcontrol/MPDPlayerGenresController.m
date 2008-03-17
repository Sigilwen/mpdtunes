//
//  MPDPlayerGenresController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDPlayerGenresController.h"
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
    
    mpd_database_search_field_start([_mpdConnection object], MPD_TAG_ITEM_GENRE);
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
  printf("not implemented: %d\n", row);
}

@end
