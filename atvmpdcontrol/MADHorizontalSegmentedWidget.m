//
//  MADHorizontalSegmentedWidget.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 08.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADHorizontalSegmentedWidget.h"


@implementation MADHorizontalSegmentedWidget


- (id) initWithScene: (BRRenderScene *) scene
{
	if( [super initWithScene:scene] == nil)
		return nil;
		
	_leftEndLayer = [[BRImageLayer alloc] initWithScene:scene];
	_centerLayer = [[BRImageLayer alloc] initWithScene:scene];
	_rightEndLayer = [[BRImageLayer alloc] initWithScene:scene];
	
	[self addSublayer:_leftEndLayer];
	[self addSublayer:_centerLayer];
	[self addSublayer:_rightEndLayer];
	
	self->_clipsAtFrame = TRUE;
	
	_clipPercent = 1.0;
	
	return self;
}

- (void)dealloc
{
	[_leftEndLayer release];
	[_centerLayer release];
	[_rightEndLayer release];

	[super dealloc];
}

- (void)setClipPercent:(float)percent
{
	if(percent < 0.0)
		percent = 0;
	if(percent > 1.0)
		percent = 1.0;
		
	_clipPercent = percent;
	
	NSRect frame = _segmentFrame;
	
	// We wan't the left part be always visible, it looks ugly otherwise
	frame.size.width = [_leftEndLayer frame].size.width + 
						((frame.size.width - [_leftEndLayer frame].size.width)*_clipPercent);
	
	[super setFrame:frame];	
}

- (void)setFrame:(NSRect)frame
{
	_segmentFrame = frame;
	
	NSSize leftPixelSize = [_leftEndLayer pixelBounds];
	NSSize rightPixelSize = [_rightEndLayer pixelBounds];
	
	float leftAspect = leftPixelSize.width / leftPixelSize.height;
	float rightAspect = rightPixelSize.width / rightPixelSize.height;
	
/*	NSRect rightFrame = frame;
	rightFrame.size.width = rightFrame.size.height * rightAspect;
		
	[_rightEndLayer setFrame:rightFrame];
*/	
	NSRect leftFrame = frame;
	leftFrame.size.width = leftFrame.size.height * leftAspect;
		
	[_leftEndLayer setFrame:leftFrame];

	NSRect rightFrame = frame;
	rightFrame.size.width = rightFrame.size.height * rightAspect;
	rightFrame.origin.x = (frame.origin.x + frame.size.width) - rightFrame.size.width;
	
	[_rightEndLayer setFrame:rightFrame];
	
	NSRect centerFrame = frame;
	centerFrame.origin.x += rightFrame.size.width;
	centerFrame.size.width = frame.size.width - leftFrame.size.width - rightFrame.size.width;
	
	[_centerLayer setFrame:centerFrame];
	
	frame.size.height *= _clipPercent;
	
	[super setFrame:frame];
	
}

- (void)setImageFromPath:(NSString*)path forImageLayer:(BRImageLayer*)imageLayer
{
	NSURL * imageURL = [NSURL fileURLWithPath: path];
	CGImageRef image = CreateImageForURL( imageURL );
	[imageLayer setImage:image];
	CFRelease( image );
}

- (void)setLeftFile:(NSString*)leftFile centerFile:(NSString*)centerFile rightFile:(NSString*)rightFile
{
	[self setImageFromPath:leftFile forImageLayer:_leftEndLayer];
	[self setImageFromPath:centerFile forImageLayer:_centerLayer];
	[self setImageFromPath:rightFile forImageLayer:_rightEndLayer];	
}

@end
