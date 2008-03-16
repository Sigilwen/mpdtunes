//
//  MADAlphaFriendlyRenderLayer.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

#import "MADDeactivateableControl.h"

@interface MADAlphaFriendlyRenderLayer : BRRenderLayer {
	NSMutableArray * _deactivatables;
}

-(id)initWithScene:(BRRenderScene*)scene;
-(void)setAlphaValue:(float)value;
- (void)dealloc;

- (void)addDeactivatable:(MADDeactivateableControl*)ctrl;

- (void)renderLayer;

@end
