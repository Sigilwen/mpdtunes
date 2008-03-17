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

@interface MPDPlayerController : BRMenuController <MPDConnectionLostDelegate, MPDStatusChangedDelegate> 
{	
	MPDConnection*					_mpdConnection;
}

- (id)initWithScene:(id)scene;
- (void)dealloc;

// abstract:
- (long) itemCount;
- (id) itemForRow: (long) row;
- (NSString *) titleForRow: (long) row;

- (long) rowForTitle: (NSString *) title;

- (void)setMpdConnection:(MPDConnection*)mpdConnection; 
- (void)onConnectionLost;
- (void)onStatusChanged:(ChangedStatusType)what;

- (void) willBePushed;
- (void) willBePopped;

@end
