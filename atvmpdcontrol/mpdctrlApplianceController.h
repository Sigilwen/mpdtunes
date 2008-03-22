//
//  mpdctrlApplianceController.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 31.05.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BRLayerController.h>
#import <BackRow/BRListControl.h>
#import "libmpd/libmpd.h"


#import "MADListControl.h"
#import "MADVertLayout.h"



#import "MPDServerController.h"
#import "MPDStatusController.h"

#import "MPDConnection.h"

@class BRRenderScene, BRRenderLayer;

@interface mpdctrlApplianceController : MPDServerController
{
	BRAlertController *				_alertController;

	MPDStatusController *			_statusController;
}

- (id) initWithScene: (BRRenderScene *) scene;
- (void) dealloc;

- (void) willBePushed;
- (void) wasPushed;
- (void) willBePopped;
- (void) wasPopped;
- (void) willBeBuried;
- (void) wasBuriedByPushingController: (BRLayerController *) controller;
- (void) willBeExhumed;
- (void) wasExhumedByPoppingController: (BRLayerController *) controller;


@end
