//
//  MPDPlaylistOptionsController.h
//  mpdctrl
//
//  Created by Marcus T on 7/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

#import "MPDSmallTextControl.h"
#import "MADHorzLayout.h"
#import "MPDConnection.h"
#import "MPDPlayerController.h"
#import "MPDAddressEntryController.h"

@interface MPDPlaylistOptionsController : BRMenuController <MPDConnectionLostDelegate, MPDStatusChangedDelegate> {
	MPDConnection*				_mpdConnection;
	int							_currentRootOption;
	NSString*					_currentPath;
	NSMutableArray*				_itemArray;
	MADHorzLayout*				_layout;
	
	MPDPlayerController*		_playerCtrl;
	
	MPDAddressEntryController*	_textEntryController;
	
	id							_descText;
}

- (id) initWithScene:(BRRenderScene*)scene;
- (void) dealloc;

- (int)selectedRootOption;

- (void)setDescription:(NSString*)description;

- (void)setMpdConnection:(MPDConnection*)mpdConnection; 
- (void)onConnectionLost;
- (void)onStatusChanged:(ChangedStatusType)what;

- (void)clearPlaylist;

- (long) itemCount;
- (id<BRMenuItemLayer>) itemForRow: (long) row;
- (NSString *) titleForRow: (long) row;
- (long) rowForTitle: (NSString *) title;

- (id<BRMenuItemLayer>)createFolderItemWithPath:(NSString*)path;
- (id<BRMenuItemLayer>)createFileItemWithPath:(NSString*)path;

- (id<BRMenuItemLayer>)createFolderItemWithText:(NSString*)text;
- (id<BRMenuItemLayer>)createItemWithText:(NSString*)text;
- (id<BRMenuItemLayer>)createItemWithText:(NSString*)text rightJustifiedText:(NSString*)rText;

- (void) willBePushed;
- (void) willBePopped;

- (BOOL)brEventAction:(BREvent *) brEvent;

@end
