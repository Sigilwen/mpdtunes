//
//  MADGLControl.m
//  mpdctrl
//
//  Created by Marcus T on 6/17/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADGLControl.h"


@implementation MADGLControl

- (id) initWithScene: (BRRenderScene *) scene
{
    if ( [super initWithScene: scene] == nil )
        return ( nil );

//    _layer = [[BRRenderLayer alloc] initWithScene: scene];
    _layer = [[MADGLLayer alloc] initWithScene: scene];

//    [_layer addSublayer: _glLayer];


    return ( self );
}

- (void) dealloc
{
//    [_glLayer release];
    [_layer release];

    [super dealloc];
}

- (BRRenderLayer *) layer
{
    return ( _layer );
}

- (void) setFrame: (NSRect) frame
{
    [super setFrame: frame];

/*    NSRect widgetFrame = NSZeroRect;
    widgetFrame.size = frame.size;
	
    [_glLayer setFrame: widgetFrame];
*/
}

- (NSRect)frame
{
	return [super frame];
}

- (void)setAlphaValue: (float) alpha
{
	[super setAlphaValue:alpha];
}

- (float) alphaValue
{
	return [super alphaValue];
}

@end
