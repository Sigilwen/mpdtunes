//
//  MADAlphaFriendlyRenderLayer.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADAlphaFriendlyRenderLayer.h"

@implementation MADAlphaFriendlyRenderLayer

-(id)initWithScene:(BRRenderScene*)scene
{
	if( [super initWithScene:scene] == nil)
		return nil;
		
	_deactivatables = [[NSMutableArray alloc]init];

	
	return ( self );
}

- (void)dealloc
{
	[_deactivatables release];
	[super dealloc];
}

- (void)addDeactivatable:(MADDeactivateableControl*)ctrl;
{	
	[_deactivatables addObject:ctrl];
}

-(void)setAlphaValue:(float)value
{
	int i=0;
	
	[super setAlphaValue:value];

	if(_deactivatables != nil)
	{
		for(;i<[_deactivatables count];i++)
		{
			MADDeactivateableControl* obj = (MADDeactivateableControl*)[_deactivatables objectAtIndex:i];
			
			if( [obj deactivated] )
				[ [obj control] setAlphaValue:value*0.5];
		}
	}
// for _deactivatables
}

- (void)renderLayer
{			
	[super renderLayer];
}


@end
