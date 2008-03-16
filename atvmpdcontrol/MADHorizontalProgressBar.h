//
//  MADHorizontalProgressBar.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 08.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "MADHorizontalSegmentedWidget.h"

@interface MADHorizontalProgressBar : BRControl {
	MADHorizontalSegmentedWidget*	_segmentOnLayer;
	MADHorizontalSegmentedWidget*	_segmentOffLayer;
	
	BRRenderLayer *				_layer;
}

- (id)initWithScene:(BRRenderScene*)scene;
- (void)dealloc;

- (BRRenderLayer *) layer;
- (void)setFrame:(NSRect)frame;

- (void)setPercent:(float)percent;


@end
