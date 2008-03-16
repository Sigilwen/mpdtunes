//
//  MADHorizontalSegmentedWidget.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 08.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface MADHorizontalSegmentedWidget : BRRenderLayer {
	BRImageLayer*	_leftEndLayer;
	BRImageLayer*	_centerLayer;
	BRImageLayer*	_rightEndLayer;
	
	NSRect			_segmentFrame;

	float			_clipPercent;
}

- (id) initWithScene: (BRRenderScene *) scene;
- (void)dealloc;
- (void)setFrame:(NSRect)frame;
- (void)setLeftFile:(NSString*)leftFile centerFile:(NSString*)centerFile rightFile:(NSString*)rightFile;
- (void)setClipPercent:(float)percent;

@end
