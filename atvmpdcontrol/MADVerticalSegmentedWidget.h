//
//  MADVerticalSegmentedWidget.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 06.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface MADVerticalSegmentedWidget : BRRenderLayer {
	BRImageLayer*	_topEndLayer;
	BRImageLayer*	_centerLayer;
	BRImageLayer*	_bottomEndLayer;
	
	NSRect			_segmentFrame;

	float			_clipPercent;
}

- (id) initWithScene: (BRRenderScene *) scene;
- (void)dealloc;
- (void)setFrame:(NSRect)fp8;
- (void)setTopFile:(NSString*)topFile centerFile:(NSString*)centerFile bottomFile:(NSString*)bottomFile;
- (void)setClipPercent:(float)percent;


@end
