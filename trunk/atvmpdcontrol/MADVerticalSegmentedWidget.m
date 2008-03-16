//
//  MADVerticalSegmentedWidget.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 06.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADVerticalSegmentedWidget.h"


@implementation MADVerticalSegmentedWidget

- (id) initWithScene: (BRRenderScene *) scene
{
	if( [super initWithScene:scene] == nil)
		return nil;
		
	_topEndLayer = [[BRImageLayer alloc] initWithScene:scene];
	_centerLayer = [[BRImageLayer alloc] initWithScene:scene];
	_bottomEndLayer = [[BRImageLayer alloc] initWithScene:scene];
	
	[self addSublayer:_topEndLayer];
	[self addSublayer:_centerLayer];
	[self addSublayer:_bottomEndLayer];
	
	self->_clipsAtFrame = TRUE;
	
	_clipPercent = 1.0;
	
	return self;
}

- (void)dealloc
{
	[_topEndLayer release];
	[_centerLayer release];
	[_bottomEndLayer release];

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
	frame.size.height *= _clipPercent;
	
	[super setFrame:frame];	
}

- (void)setFrame:(NSRect)frame
{
	_segmentFrame = frame;
	
	NSSize topPixelSize = [_topEndLayer pixelBounds];
	NSSize bottomPixelSize = [_bottomEndLayer pixelBounds];
	
	float topAspect = topPixelSize.height / topPixelSize.width;
	float bottomAspect = bottomPixelSize.height / bottomPixelSize.width;
	
	NSRect bottomFrame = frame;
	bottomFrame.size.height = bottomFrame.size.width * bottomAspect;
		
	[_bottomEndLayer setFrame:bottomFrame];
	
	NSRect topFrame = frame;
	topFrame.size.height = topFrame.size.width * topAspect;
	topFrame.origin.y = (frame.origin.y + frame.size.height) - topFrame.size.height;
	
	[_topEndLayer setFrame:topFrame];
	
	NSRect centerFrame = frame;
	centerFrame.origin.y += bottomFrame.size.height;
	centerFrame.size.height = frame.size.height - topFrame.size.height - bottomFrame.size.height;
	
	[_centerLayer setFrame:centerFrame];
	
	frame.size.height *= _clipPercent;
	
	[super setFrame:frame];
	
}

- (void)setImageFromPath:(NSString*)path forImageLayer:(BRImageLayer*)imageLayer
{
	NSString* cacheName = [NSString stringWithFormat:@"%iROT_%@", 90, [[path lastPathComponent] stringByDeletingPathExtension] ];

	BRTexture* texture = [[self scene] cachedTextureForKey: cacheName];
	
	if(texture == nil)
	{
		NSURL * imageURL = [NSURL fileURLWithPath: path];
		CGImageRef image = CreateImageForURL( imageURL );

		CIImage* img = [CIImage imageWithCGImage:image];

		CGRect orgImgSize = [img extent];

		CIFilter *transform = [CIFilter filterWithName:@"CIAffineTransform"];
		[transform setValue:img forKey:@"inputImage"];

		NSAffineTransform *affineTransform = [NSAffineTransform transform];
		[affineTransform rotateByDegrees:90];
		[transform setValue:affineTransform forKey:@"inputTransform"];
		CIImage * result = [transform valueForKey:@"outputImage"];
		
		CGRect extent = [result extent];
		
		transform = [CIFilter filterWithName:@"CIAffineTransform"];
		affineTransform = [NSAffineTransform transform];
		[affineTransform translateXBy:-extent.origin.x
								  yBy:-extent.origin.y];
		[transform setValue:affineTransform forKey:@"inputTransform"];
		[transform setValue:result forKey:@"inputImage"];
		result = [transform valueForKey:@"outputImage"];
		
		transform = [CIFilter filterWithName:@"CICrop"];
		[transform setValue:[CIVector vectorWithX:0.0 Y:0.0 Z:orgImgSize.size.height W:orgImgSize.size.width] forKey:@"inputRectangle"];
		[transform setValue:result forKey:@"inputImage"];
		result = [transform valueForKey:@"outputImage"];
		
		extent = [result extent];	

		texture = [BRBitmapTexture textureWithCIImage:result context:[[self scene]resourceContext] mipmap:NO];
	
		[[self scene] setCachedTexture:texture forKey: cacheName];
		
		CFRelease( image );
	}
	
	[imageLayer setTexture:texture];
	
}

- (void)setTopFile:(NSString*)topFile centerFile:(NSString*)centerFile bottomFile:(NSString*)bottomFile
{
	[self setImageFromPath:topFile forImageLayer:_topEndLayer];
	[self setImageFromPath:centerFile forImageLayer:_centerLayer];
	[self setImageFromPath:bottomFile forImageLayer:_bottomEndLayer];	
}
@end
