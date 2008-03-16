//
//  mpdctrlAppliance.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 31.05.07.
//  Copyright (c) 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BackRow/BRAppliance.h>

@class BRLayerController, BRRenderScene;

@interface mpdctrlAppliance : BRAppliance 
{
}

+ (void) initialize;

+ (NSString *) className;

- (NSString *) moduleName;
+ (NSString *) moduleKey;
- (NSString *) moduleKey;

- (BRLayerController *) applianceControllerWithScene: (BRRenderScene *) scene;

@end
