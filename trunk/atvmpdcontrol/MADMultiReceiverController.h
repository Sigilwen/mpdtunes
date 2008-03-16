//
//  MADMultiReceiverController.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MADEventForwarder.h"
#import "MADDeactivateableControl.h"
#import "MADObjectDictionary.h"

@interface MADMultiReceiverController : BRLayerController {
	MADObjectDictionary*	_deactivObjects;
}

- (id)initWithScene:(id)scene;
- (void)dealloc;

- (id)masterLayer;

- (void)addControl:(BRControl <MADEventForwarder>*)ctrl leftCtrl:(BRControl <MADEventForwarder>*)leftCtrl rightCtrl:(BRControl <MADEventForwarder>*)rightCtrl;
- (void)addControl:(BRControl <MADEventForwarder>*)ctrl topCtrl:(BRControl <MADEventForwarder>*)topCtrl bottomCtrl:(BRControl <MADEventForwarder>*)bottomCtrl;


- (MADDeactivateableControl*)getDeactCtrlForControl:(BRControl*) ctrl;

@end
