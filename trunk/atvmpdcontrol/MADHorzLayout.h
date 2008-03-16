//
//  MADHorzLayout.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MADLayout.h"

@interface MADHorzLayout : MADLayout {
}

+ (id)createSafeLayout:(BRRenderScene*)scene;
+ (id)createCenterLayout:(id)centeredObject;

- (void)addObject:(id)object withConstraint:(float) horzConstraint;
- (void)addObject:(id)object withSize:(int) horzSize;
- (void)addObject:(id)object withSizeFromObject:(id) sizeObject;
- (void)addObject:(id)object withAspect:(float) aspect;
- (void)addObject:(id)object;

- (void)doLayout;


@end
