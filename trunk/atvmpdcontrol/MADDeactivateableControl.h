//
//  MADDeactivateableControl.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "MADEventForwarder.h"

@protocol MADEventForwarder;

@interface MADDeactivateableControl : NSObject {
	MADDeactivateableControl*		_leftCtrl;
	MADDeactivateableControl*		_rightCtrl;
	MADDeactivateableControl*		_topCtrl;
	MADDeactivateableControl*		_bottomCtrl;
	
	BRValueAnimation*				_fadeAnim;
	
	BRControl<MADEventForwarder>*	_control;
	
	BOOL							_deactivated;
}

- (id)initWithControl:(BRControl <MADEventForwarder>*)ctrl deactivated:(BOOL)deactivated;

- (BRControl*)control;

- (void)setDeactivated:(BOOL)deactivated;
- (BOOL)deactivated;

- (void)setLeftCtrl:(MADDeactivateableControl*)ctrl;
- (MADDeactivateableControl*)leftCtrl;

- (void)setRightCtrl:(MADDeactivateableControl*)ctrl;
- (MADDeactivateableControl*)rightCtrl;

- (void)setTopCtrl:(MADDeactivateableControl*)ctrl;
- (MADDeactivateableControl*)topCtrl;

- (void)setBottomCtrl:(MADDeactivateableControl*)ctrl;
- (MADDeactivateableControl*)bottomCtrl;

- (int)processEvent:(BREvent*)brEvent;

@end
