//
//  MPDPlayerRootController.h
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BRLayerController.h>
#import <BackRow/BRListControl.h>
#import "libmpd/libmpd.h"

#import "MPDPlayerController.h"

#import "MPDServerController.h"
#import "MPDStatusController.h"

#import "MPDConnection.h"


@interface MPDPlayerRootController : MPDPlayerController {
  BRAlertController   *_alertController;
  MPDServerController *_serverController;
  MPDStatusController *_statusController;
}

- (id) initWithScene: (BRRenderScene *) scene;
- (id) itemForRow: (long) row;
- (void) itemSelected: (long) row;
- (void) updateConnectionState;

@end
