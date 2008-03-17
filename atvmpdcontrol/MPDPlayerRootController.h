//
//  MPDPlayerRootController.h
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MPDPlayerController.h"

@interface MPDPlayerRootController : MPDPlayerController {
}

- (id) initWithScene: (BRRenderScene *) scene;
- (id) itemForRow: (long) row;
- (void) itemSelected: (long) row;
- (void) itemPlay: (long)row;

@end
