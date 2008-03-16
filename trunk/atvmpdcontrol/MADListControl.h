//
//  BRDeactivatableListControl.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 01.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <BackRow/BRListControl.h>
#import "MADDeactivateableControl.h"

@interface MADListControl : BRListControl {
	MADDeactivateableControl*	_eventReceiver;
	id							_playPauseTarget;
	SEL							_playPauseSelector;
}

- (id)initWithScene:(BRRenderScene*)scene;
- (void)dealloc;

- (void)setPlayPauseTarget:(id)target withSelector:(SEL)selector;

- (void)setDeactObject:(id)deactObject;

- (BOOL)brEventAction:(BREvent*) brEvent;


@end
