//
//  MADPlaylistList.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "MADEventForwarder.h"
#import "MPDConnection.h"
#import "MADDeactivateableControl.h"

@interface MADPlaylistList : BRListControl <MADEventForwarder, BREventResponder, BRMenuListItemProvider> {
	MADDeactivateableControl*	_eventReceiver;
	MPDConnection*				_mpdConnection;
	id							_target;
	BOOL						_modeRemoveSongs;
}

- (id)initWithScene:(BRRenderScene*)scene;

- (void)setDeactObject:(id)deactObject;

- (BOOL)brEventAction:(BREvent*)event;

- (void)setMpdConnection:(MPDConnection*)mpdConnection;

- (void)setTarget:(id)target;
- (id)target;

- (id) itemForRow: (long) row;
- (long) itemCount;
- (NSString *) titleForRow: (long) row;
- (long) rowForTitle: (NSString *) title;

-(id<BRMenuItemLayer>)createItemWithText:(NSString*)text;
-(id<BRMenuItemLayer>)createItemWithText:(NSString*)text rightJustifiedText:(NSString*)rText;

@end
