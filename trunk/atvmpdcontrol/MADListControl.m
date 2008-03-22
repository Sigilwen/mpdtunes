//
//  BRDeactivateableListControl.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 01.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADListControl.h"


@implementation MADListControl

- (id)initWithScene:(BRRenderScene*) scene
{
	if( [super initWithScene:scene] == nil )
		return nil;
		
	_eventReceiver = nil;

	
	return ( self );
}

- (void)dealloc
{

	[super dealloc];
}

- (void)setPlayPauseTarget:(id)target withSelector:(SEL)selector
{
	_playPauseTarget = target;
	_playPauseSelector = selector;
}

- (void)setDeactObject:(id)deactObject;
{
	_eventReceiver = (MADDeactivateableControl*)deactObject;
}

- (BOOL)brEventAction:(BREvent*) brEvent
{
	BOOL returnYes = NO;
	int ret =  [_eventReceiver processEvent:brEvent];
  
	if(ret == -1)
		return NO;
	
	if(ret == 1)
		return YES;
		
	BREventPageUsageHash hash = [brEvent pageUsageHash];

	if([brEvent value] == 1 && hash == kBREventTapPlayPause)
	{
		if(_playPauseTarget != nil && _playPauseSelector != nil)
		{
			[_playPauseTarget performSelector:_playPauseSelector];
			returnYes = YES;
		}
	}
	
	if(returnYes == YES)
		return YES;
	return [super brEventAction:brEvent];
}


@end
