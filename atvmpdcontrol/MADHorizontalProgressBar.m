//
//  MADHorizontalProgressBar.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 08.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADHorizontalProgressBar.h"


@implementation MADHorizontalProgressBar


- (id)initWithScene:(BRRenderScene*)scene
{
	if( [super initWithScene:scene] == nil )
		return nil;

    _layer = [[BRRenderLayer alloc] initWithScene: scene];
		
	_segmentOnLayer = [[MADHorizontalSegmentedWidget alloc] initWithScene:scene];
	_segmentOffLayer = [[MADHorizontalSegmentedWidget alloc] initWithScene:scene];

	NSString * leftOnPath = [[NSBundle bundleWithIdentifier: @"com.apple.frontrow.backrow"]
					   pathForResource: @"GrayProgress_LeftCap_ON"
								ofType: @"png"];

	NSString * centerOnPath = [[NSBundle bundleWithIdentifier: @"com.apple.frontrow.backrow"]
					   pathForResource: @"GrayProgress_Center_ON"
								ofType: @"png"];

	NSString * rightOnPath = [[NSBundle bundleWithIdentifier: @"com.apple.frontrow.backrow"]
					   pathForResource: @"GrayProgress_RightCap_ON"
								ofType: @"png"];


	NSString * leftOffPath = [[NSBundle bundleWithIdentifier: @"com.apple.frontrow.backrow"]
					   pathForResource: @"GrayProgress_LeftCap_OFF"
								ofType: @"png"];

	NSString * centerOffPath = [[NSBundle bundleWithIdentifier: @"com.apple.frontrow.backrow"]
					   pathForResource: @"GrayProgress_Center_OFF"
								ofType: @"png"];

	NSString * rightOffPath = [[NSBundle bundleWithIdentifier: @"com.apple.frontrow.backrow"]
					   pathForResource: @"GrayProgress_RightCap_OFF"
								ofType: @"png"];
								
	[_segmentOnLayer	setLeftFile:leftOnPath 
						centerFile:centerOnPath
						rightFile:rightOnPath];
	[_segmentOffLayer	setLeftFile:leftOffPath 
						centerFile:centerOffPath
						rightFile:rightOffPath];

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
