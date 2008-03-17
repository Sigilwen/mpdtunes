//
//  MPDPlayerGenresController.h
//  mpdctrl
//
//  Created by Rob Clark on 3/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MPDPlayerController.h"

@interface MPDPlayerGenresController : MPDPlayerController {
  NSMutableArray * _names;
}

- (id) initWithScene: (BRRenderScene *) scene;
- (void) dealloc;

- (long) itemCount;
- (id) itemForRow: (long) row;
- (NSString *) titleForRow: (long) row;

- (void) itemSelected: (long) row;

@end
