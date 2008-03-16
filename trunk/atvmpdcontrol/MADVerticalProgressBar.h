//
//  MADVerticalProgressBar.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 06.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "MADVerticalSegmentedWidget.h"

@interface MADVerticalProgressBar : BRControl {
	MADVerticalSegmentedWidget*	_segmentOnLayer;
	MADVerticalSegmentedWidget*	_segmentOffLayer;
	
	BRRenderLayer *				_layer;
}

- (id)initWithScene:(BRRenderScene*)scene;
- (void)dealloc;

- (BRRenderLayer *) layer;
- (void)setFrame:(NSRect)frame;

- (void)setPercent:(float)percent;



@end
