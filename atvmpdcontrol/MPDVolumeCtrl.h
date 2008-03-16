//
//  MADVolumeCtrl.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MADVerticalProgressBar.h"
#import "MADEventForwarder.h"
#import "MPDConnection.h"
#import "MADDeactivateableControl.h"

@interface MPDVolumeCtrl : MADVerticalProgressBar <MADEventForwarder, BREventResponder> {
	MADDeactivateableControl*	_eventReceiver;
	MPDConnection*				_mpdConnection;
}

- (id)initWithScene:(BRRenderScene*)scene;
- (void)dealloc;

- (void)setMpdConnection:(MPDConnection*)mpdConnection;

- (void)setDeactObject:(id)deactObject;
- (BOOL)brEventAction:(BREvent*)event;
@end
