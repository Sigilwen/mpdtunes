//
//  MADDebugSelector.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 08.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADDebugSelector.h"


@implementation MADDebugSelector

-(id)initWithScene:(BRRenderScene*)scene
{
	if( [super initWithScene:scene] == nil)
		return nil;
		
	
	_drawFrameOutline = YES;
	_clipsAtFrame = YES;
	
	return (self);
}

@end
