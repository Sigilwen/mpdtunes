//
//  MPDCtrlListHeaderControl.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDSmallTextControl.h"


@implementation MPDSmallTextControl


- (id)initWithScene: (BRRenderScene*)scene withFontSize:(float)size
{
	if( [super initWithScene:scene]  == nil )
		return nil;

	// Create a new target Dictionay
	NSMutableDictionary * mutDict = [[[NSMutableDictionary alloc] init] autorelease];
	// Get the old attribtes
	NSDictionary *orgAttr = [self textAttributes];
	// Copy the old attributes to the new Dictionary
	[mutDict setDictionary:orgAttr];
	// Create a new font
	NSFont *newFont = [NSFont boldSystemFontOfSize:size];//[NSFont fontWithName:@"Helvetica" size:20.0];
	// Set the new font
	[mutDict setValue:newFont forKey:NSFontAttributeName];
		
	// Set the new Attributes
	[self setTextAttributes: mutDict];	

	
	return ( self );
}

- (id)initWithScene: (BRRenderScene*)scene withFontSize:(float)size withColor:(NSColor*)color
{
	if( [super initWithScene:scene]  == nil )
		return nil;

	// Create a new target Dictionay
	NSMutableDictionary * mutDict = [[[NSMutableDictionary alloc] init] autorelease];
	// Get the old attribtes
	NSDictionary *orgAttr = [self textAttributes];
	// Copy the old attributes to the new Dictionary
	[mutDict setDictionary:orgAttr];
	// Create a new font
	NSFont *newFont = [NSFont boldSystemFontOfSize:size];//[NSFont fontWithName:@"Helvetica" size:20.0];
	// Set the new font
	[mutDict setValue:newFont forKey:NSFontAttributeName];
	
	float floatComps[4];
	floatComps[0] = [color redComponent];
	floatComps[1] = [color greenComponent];
	floatComps[2] = [color blueComponent];
	floatComps[3] = [color alphaComponent];

	
	CGColorRef newColor = CGColorCreate (CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB), floatComps);

	[mutDict setValue:newColor forKey:NSForegroundColorAttributeName];	
		
	// Paragraphs don't work atm
//	NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
//	[paragraph setAlignment:NSCenterTextAlignment];
//	[mutDict setValue:paragraph forKey:NSParagraphStyleAttributeName];

	// Set the new Attributes
	[self setTextAttributes: mutDict];	

	[_layer setColorText:YES];
	
	return ( self );
	



}

- (id)initWithScene: (BRRenderScene*)scene
{
	return [self initWithScene:scene withFontSize:18.0];
}

- (void)setFrame:(NSRect)frame
{
	[super setFrame:frame];
	
//	[super setMaximumSize:frame.size];

//	BOOL isMulti = [super isMultiLine];
	
//	int maxLines = [super maxLines];

	[super setMaxLines:20];

}

@end
