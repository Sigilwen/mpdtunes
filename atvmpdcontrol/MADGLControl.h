//
//  MADGLControl.h
//  mpdctrl
//
//  Created by Marcus T on 6/17/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h> 
#import "MADGLLayer.h"

@interface MADGLControl : BRControl {
//	BRRenderLayer*		_layer;
	MADGLLayer*			_layer;
}

- (id)initWithScene: (BRRenderScene *) scene;
- (void) dealloc;

- (BRRenderLayer *) layer;

- (void) setFrame: (NSRect) frameRect;
- (NSRect) frame;

- (void)setAlphaValue: (float) alpha;
- (float) alphaValue;


@end
