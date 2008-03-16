//
//  MADAdvancedListControl.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADAdvancedListControl.h"


@implementation MADAdvancedListControl

-(id)initWithScene:(BRRenderScene*)scene
{
    if ( [super initWithScene: scene] == nil )
        return ( nil );
		
	_target = nil;

	return ( self );
}

-(void)setTarget:(id <MADAdvancedListControlDelegate>)target
{
	_target = target;
}

-(id <MADAdvancedListControlDelegate>)target
{
	return _target;
}

-(BOOL)brEventAction:(BREvent*)brEvent
{
	BOOL returnYes = NO;
	BREventPageUsageHash hash = [brEvent pageUsageHash];


	if([brEvent value] == 1)
	{
		if(	hash == kBREventTapPlayPause ||
			hash == kBREventTapLeft ||
			hash == kBREventTapRight )
		{
			[_target onKeyPressed:hash selectedItem: (int)[self selection] ];
		}
	}
	
	
	if(!returnYes)
		return [super brEventAction:brEvent];
		
	return YES;
}

@end
