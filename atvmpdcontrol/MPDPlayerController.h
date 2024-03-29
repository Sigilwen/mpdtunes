//
//  MPDPlayerPage.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <BackRow/BRMenuController.h>
#import <BackRow/BackRow.h>

#import "libmpd/libmpd.h"

#import "MPDConnection.h"

@interface MPDPlayerController : BRMediaMenuController <MPDConnectionLostDelegate, MPDStatusChangedDelegate> 
{
	MPDConnection  *_mpdConnection;
  NSMutableArray *_names;
  BOOL  _visible;
}

- (id)initWithScene: (id)scene;
- (void)dealloc;

- (long) itemCount;
- (id) itemForRow: (long)row;
- (NSString *) titleForRow: (long)row;
- (long) rowForTitle: (NSString *)title;
- (void) itemSelected: (long)row;
- (void) itemPlay: (long)row;      /* should be renamed 'addToPlaylist'? */
- (void) itemRemove: (long)row;      /* should be renamed 'removeFromPlaylist'? */
- (BOOL) brEventAction: (BREvent *)event;

- (void) setMpdConnection: (MPDConnection *)mpdConnection; 
- (void) onConnectionLost;
- (void) onStatusChanged: (ChangedStatusType)what;

- (void) willBePushed;
- (void) willBePopped;

- (void) addToPlaylistGenre: (NSString *)genre
                  andArtist: (NSString *)artist
                   andAlbum: (NSString *)album
                    andSong: (NSString *)song;

- (id<BRMediaPreviewController>) previewControllerForArtist: (NSString *)artist andAlbum: (NSString *)album andSong:(NSString *)song;


@end
