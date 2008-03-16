//
//  MPDListControlServerSource.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MADListControlArrayDataSource.h"

@interface MPDListControlServerSource : MADListControlArrayDataSource {

}

- (id)initWithScene: (BRRenderScene *) scene;

- (void)reload;
- (void)reset;

- (int)defaultServer;
- (void)setDefaultServer:(int)index;

- (void)store;

@end
