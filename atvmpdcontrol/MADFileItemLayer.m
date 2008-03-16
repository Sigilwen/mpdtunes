//
//  MADFileItemLayer.m
//  mpdctrl
//
//  Created by Marcus T on 7/5/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADFileItemLayer.h"


@implementation MADFileItemLayer

- (id)initWithScene:(BRRenderScene*)scene withPath:(NSString*)path withType:(int)type
{
	if( [super initWithScene:scene] == nil)
		return nil;
		
	[self setTitle:path centered:NO];	
	
	_fileName = [path retain];
	_type = type;
	
	return (self);
}

- (void)dealloc
{
	[_fileName release];
	[super dealloc];
}

- (int)type
{
	return _type;
}

- (NSString*)fileName
{
	return _fileName;
}

@end
