//
//  MPDControlBar.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MADEventForwarder.h"
#import "MPDConnection.h"
#import "MADDeactivateableControl.h"
#import "MADHorizontalList.h"

@interface MPDControlBar : MADHorizontalList <MADEventForwarder, BREventResponder, BRMenuListItemProvider> {
	MADDeactivateableControl*	_eventReceiver;
	MPDConnection*				_mpdConnection;
	id							_target;
}

- (id)initWithScene:(BRRenderScene*)scene;

- (void)setDeactObject:(id)deactObject;

- (BOOL)brEventAction:(BREvent*)event;

- (void)setSettingsTarget:(id)target;

- (void)setMpdConnection:(MPDConnection*)mpdConnection;

-(id<BRMenuItemLayer>)createItemWithText:(NSString*)text;

- (id) itemForRow: (long) row;
- (long) itemCount;
- (NSString *) titleForRow: (long) row;
- (long) rowForTitle: (NSString *) title;

@end
