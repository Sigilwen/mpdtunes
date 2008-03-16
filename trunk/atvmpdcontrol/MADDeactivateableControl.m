//
//  MADDeactivateableControl.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADDeactivateableControl.h"


@implementation MADDeactivateableControl

- (id)initWithControl:(BRControl <MADEventForwarder>*)ctrl deactivated:(BOOL)deactivated
{
	if( [super init] == nil )
		return nil;
		
	_leftCtrl = nil;
	_rightCtrl = nil;
	_topCtrl = nil;
	_bottomCtrl = nil;
	
	_control = ctrl;
	
	_fadeAnim = nil;
	
	_deactivated = deactivated;
	
	if(deactivated)
		[_control setAlphaValue:0.5];
	
	[_control setDeactObject:self];
	
	return ( self );
}

- (void)dealloc
{
	if(_fadeAnim != nil)
	{	
		[_fadeAnim stop];
		[_fadeAnim release];	
	}
	
	[super dealloc];
}

- (BRControl*)control
{
	return ( _control );
}

- (void)setLeftCtrl:(MADDeactivateableControl*)ctrl
{
	_leftCtrl = ctrl;
}

- (MADDeactivateableControl*)leftCtrl
{
	return _leftCtrl;
}

- (void)setRightCtrl:(MADDeactivateableControl*)ctrl
{
	_rightCtrl = ctrl;
}

- (MADDeactivateableControl*)rightCtrl
{
	return _rightCtrl;
}

- (void)setTopCtrl:(MADDeactivateableControl*)ctrl
{
	_topCtrl = ctrl;
}

- (MADDeactivateableControl*)topCtrl
{
	return _topCtrl;
}

- (void)setBottomCtrl:(MADDeactivateableControl*)ctrl
{
	_bottomCtrl = ctrl;
}

- (MADDeactivateableControl*)bottomCtrl
{
	return _bottomCtrl;
}

- (void)setDeactivated:(BOOL)deactivated
{
	_deactivated = deactivated;

	if(_fadeAnim)
	{
		[_fadeAnim stop];
		[_fadeAnim release];
		_fadeAnim = nil;
	}	
		
	_fadeAnim = [[BRValueAnimation animationWithScene: [_control scene] ] retain];
	[_fadeAnim setKey: @"alphaValue"];
	[_fadeAnim setDuration: 0.25];
	[_fadeAnim setTarget: _control];
	[_fadeAnim setAsynchronous:YES];
	
	[_fadeAnim setFromValue: [NSNumber numberWithFloat: [_control alphaValue]]];
	
	if(_deactivated)
		[_fadeAnim setToValue: [NSNumber numberWithFloat: 0.5f]];
	else
		[_fadeAnim setToValue: [NSNumber numberWithFloat: 1.0f]];
	
	[_fadeAnim run];
}
- (BOOL)deactivated
{
	return _deactivated;
}

- (int)processEvent:(BREvent*)brEvent
{
	if(_deactivated)
		return -1;
	
	BREventPageUsageHash hash = [brEvent pageUsageHash];
	int retVal = 0;

	if([brEvent value] == 1)
	{
		if(	hash == kBREventTapRight ||
			hash == kBREventTapLeft ||
			hash == kBREventTapUp ||
			hash == kBREventTapDown )
		{
			if(_leftCtrl != nil && hash == kBREventTapLeft)
			{
				[_leftCtrl setDeactivated:FALSE];
				[self setDeactivated:TRUE];
				retVal = 1;
			}
			if(_rightCtrl != nil && hash == kBREventTapRight)
			{
				[_rightCtrl setDeactivated:FALSE];
				[self setDeactivated:TRUE];
				retVal = 1;
			}
			if(_topCtrl != nil && hash == kBREventTapUp)
			{
				[_topCtrl setDeactivated:FALSE];
				[self setDeactivated:TRUE];
				retVal = 1;
			}
			if(_bottomCtrl != nil && hash == kBREventTapDown)
			{
				[_bottomCtrl setDeactivated:FALSE];
				[self setDeactivated:TRUE];
				retVal = 1;
			}									
		}
		
	}
	
	return retVal;
}

@end
