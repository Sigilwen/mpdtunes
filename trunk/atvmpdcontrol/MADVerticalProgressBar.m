//
//  MADVerticalProgressBar.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 06.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADVerticalProgressBar.h"


@implementation MADVerticalProgressBar

- (id)initWithScene:(BRRenderScene*)scene
{
	if( [super initWithScene:scene] == nil )
		return nil;

    _layer = [[BRRenderLayer alloc] initWithScene: scene];
		
	_segmentOnLayer = [[MADVerticalSegmentedWidget alloc] initWithScene:scene];
	_segmentOffLayer = [[MADVerticalSegmentedWidget alloc] initWithScene:scene];

	NSString * topOnPath = [[NSBundle bundleForClass: [BRControl class]] pathForResource: @"SW_Right_Cap_Selected_On" ofType: @"png"];

	NSString * centerOnPath = [[NSBundle bundleForClass: [BRControl class]]  pathForResource: @"SW_Center_Selected_On" ofType: @"png"];

	NSString * bottomOnPath = [[NSBundle bundleForClass: [BRControl class]] pathForResource: @"SW_Left_Cap_Selected_On" ofType: @"png"];


	NSString * topOffPath = [[NSBundle bundleForClass: [BRControl class]] pathForResource: @"SW_Right_Cap_Not_Selected_Off" ofType: @"png"];

	NSString * centerOffPath = [[NSBundle bundleForClass: [BRControl class]] pathForResource: @"SW_Center_Not_Selected_Off" ofType: @"png"];

	NSString * bottomOffPath = [[NSBundle bundleForClass: [BRControl class]] pathForResource: @"SW_Left_Cap_Not_Selected_Off" ofType: @"png"];
								
	[_segmentOnLayer	setTopFile:topOnPath 
						centerFile:centerOnPath
						bottomFile:bottomOnPath];
					
	[_segmentOffLayer	setTopFile:topOffPath 
						centerFile:centerOffPath
						bottomFile:bottomOffPath];

	

	[_layer addSublayer:_segmentOffLayer];
	[_layer addSublayer:_segmentOnLayer];

	return (self);
}

- (void)dealloc
{
	[_segmentOnLayer release];
	[_segmentOffLayer release];
	[_layer release];
	[super dealloc];
}

- (void)setPercent:(float)percent
{
	[_segmentOnLayer setClipPercent:percent];
}

- (void)setFrame:(NSRect)frame
{
    [super setFrame: frame];

    NSRect widgetFrame = NSZeroRect;
    widgetFrame.size.width = frame.size.width;
    widgetFrame.size.height = frame.size.height;
    [_segmentOnLayer setFrame: widgetFrame];	
    [_segmentOffLayer setFrame: widgetFrame];	
}

- (BRRenderLayer *) layer
{
	return _layer;
}

@end
