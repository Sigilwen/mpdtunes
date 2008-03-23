//
//  MPDPlayerRootController.m
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MPDPlayerRootController.h"
#import "MPDPlayerGenresController.h"
#import "MPDPlayerArtistsController.h"
#import "MPDPlayerAlbumsController.h"
#import "MPDPlayerSongsController.h"
#import "MPDSettingsController.h"
#import "MPDServerController.h"


@implementation MPDPlayerRootController

- (id) initWithScene: (BRRenderScene *) scene
{
  if( [super initWithScene: scene] == nil )
    return nil;
  
  [self addLabel:@"com.apple.frontrow.appliance.axxr.mpdctrl.rootController"];
  
  _mpdConnection = [[MPDConnection alloc] init];
  
  _serverController = [[MPDServerController alloc] initWithScene:scene mpdConnection: _mpdConnection];
  
  _statusController = [[MPDStatusController alloc] initWithScene:scene];
  
  [_statusController setMpdConnection:_mpdConnection];
  
  _alertController = [BRAlertController alertOfType:2
                                             titled:@""
                                        primaryText:@"Couldn't connect to specified Server"
                                      secondaryText:@"Check if your network is up and running"
                                          withScene:scene];
  
  [_alertController retain];
  
  [self setListTitle: @"Music"];
  
  [self updateConnectionState];
  
  return self;
}

- (void) updateConnectionState
{
  _names = [[NSMutableArray alloc] init];
  if( [_mpdConnection isConnected] )
  {
    printf("enabling connected menu entries\n");
    [_names addObject: @"Shuffle"];
    [_names addObject: @"Playlists"];
    [_names addObject: @"Artists"];
    [_names addObject: @"Albums"];
    [_names addObject: @"Songs"];
    [_names addObject: @"Genres"];
    [_names addObject: @"Now Playing"];
    [_names addObject: @"Clear Playlist"];
    [_names addObject: @"Settings"];
  }
  [_names addObject: @"Servers"];
  
  // set the datasource *after* you've setup your array....
  [[self list] setDatasource: self];
}

- (BOOL) autoconnect
{
  if( ![_mpdConnection isConnected] )
  {
    printf("going to autoconnect\n");
    if( [_serverController autoconnect] == MPDConnectionFailed )
      return FALSE;
    [self updateConnectionState];
  }
  return TRUE;
}

- (void) willBeExhumed
{
printf("willBeExhumed\n");
  if( ! [self autoconnect] )
    [[self stack]pushController:_alertController];
  [super willBeExhumed];
}

- (void) wasPushed
{
printf("wasPushed\n");
  [self autoconnect];
  [super wasPushed];
}

- (void) wasPopped    /* for debug */
{
printf("wasPopped\n");
  [super wasPopped];
}


- (id) itemForRow: (long) row
{
  BRAdornedMenuItemLayer *result = nil;
  NSString *item = [self titleForRow:row];
  
  if( [item isEqualToString:@"Shuffle"] )
  {
    result = [BRAdornedMenuItemLayer adornedShuffleMenuItemWithScene: [self scene]];
  }
  else if( [item isEqualToString:@"Playlists"] ||
           [item isEqualToString:@"Artists"] ||
           [item isEqualToString:@"Albums"] ||
           [item isEqualToString:@"Songs"] ||
           [item isEqualToString:@"Genres"] ||
           [item isEqualToString:@"Now Playing"] ||
           [item isEqualToString:@"Clear Playlist"] ||
           [item isEqualToString:@"Settings"] )
  {
    result = [BRAdornedMenuItemLayer adornedFolderMenuItemWithScene: [self scene]];
  }
  else if( [item isEqualToString:@"Servers"] )
  {
    result = [BRAdornedMenuItemLayer adornedNetworkMenuItemWithScene: [self scene]];
  }
  
  if( result != nil )
  {
    [[result textItem] setTitle: [_names objectAtIndex: row]];
  }
  
  return result;
}

- (void) itemSelected: (long) row
{
  id controller = nil;
  NSString *item = [self titleForRow:row];
  
  if( [item isEqualToString:@"Shuffle"] )
  {
    controller = [[BRAlertController alertOfType:2
                                          titled:@"Error"
                                     primaryText:@"Not implemented"
                                   secondaryText:@""
                                       withScene:[self scene]] autorelease];
  }
  else if( [item isEqualToString:@"Playlists"] )
  {
    controller = [[BRAlertController alertOfType:2
                                          titled:@"Error"
                                     primaryText:@"Not implemented"
                                   secondaryText:@""
                                       withScene:[self scene]] autorelease];
  }
  else if( [item isEqualToString:@"Artists"] )
  {
    controller = [[[MPDPlayerArtistsController alloc] autorelease] initWithScene: [self scene] mpdConnection:_mpdConnection genre:nil];
  }
  else if( [item isEqualToString:@"Albums"] )
  {
    controller = [[[MPDPlayerAlbumsController alloc] autorelease] initWithScene: [self scene] mpdConnection:_mpdConnection genre:nil artist:nil];
  }
  else if( [item isEqualToString:@"Songs"] )
  {
    controller = [[[MPDPlayerSongsController alloc] autorelease] initWithScene: [self scene] mpdConnection:_mpdConnection genre:nil artist:nil album:nil];
  }
  else if( [item isEqualToString:@"Genres"] )
  {
    controller = [[[MPDPlayerGenresController alloc] autorelease] initWithScene: [self scene] mpdConnection: _mpdConnection];
  }
  else if( [item isEqualToString:@"Now Playing"] )
  {
    controller = _statusController;
  }
  else if( [item isEqualToString:@"Clear Playlist"] )
  {
    mpd_playlist_clear([_mpdConnection object]);
  }
  else if( [item isEqualToString:@"Settings"] )
  {
    controller = [[[MPDSettingsController alloc] autorelease] initWithScene: [self scene] mpdConnection: _mpdConnection];
  }
  else if( [item isEqualToString:@"Servers"] )
  {
    controller = _serverController;
  }
  
  if( controller != nil )
  {
    [[self stack] pushController: controller];
  }
}

@end
