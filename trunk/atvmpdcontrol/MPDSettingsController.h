//
//  MPDSettingsController.h
//  mpdctrl
//
//  Created by Marcus T on 6/15/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

#import "MPDConnection.h"
#import "MADHorzLayout.h"
#import "MADVertLayout.h"




@interface MPDSettingsController : BRMenuController <MPDConnectionLostDelegate, MPDStatusChangedDelegate> {
	MPDConnection*			_mpdConnection;
	id						_descText;
	MADHorzLayout*			_layout;
	int						_currentAudioDevice;
}

- (id) initWithScene:(BRRenderScene*)scene;
- (void) dealloc;

- (void) createDescText;
- (void)setDescription:(NSString*)description;

- (void)setMpdConnection:(MPDConnection*)mpdConnection; 
- (void)onConnectionLost;
- (void)onStatusChanged:(ChangedStatusType)what;

- (NSArray*)getDeviceList;

- (long) itemCount;
- (id<BRMenuItemLayer>) itemForRow: (long) row;
- (NSString *) titleForRow: (long) row;
- (long) rowForTitle: (NSString *) title;

- (id<BRMenuItemLayer>)createItemWithText:(NSString*)text;
- (id<BRMenuItemLayer>)createItemWithText:(NSString*)text rightJustifiedText:(NSString*)rText;

- (void) willBePushed;
- (void) willBePopped;

- (void) selectionChanged: (NSNotification *) note;

- (BOOL)brEventAction:(BREvent *) brEvent;

@end
