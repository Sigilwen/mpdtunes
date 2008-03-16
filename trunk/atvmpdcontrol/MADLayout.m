//
//  MADLayout.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADLayout.h"


@implementation MADLayout

- (id)init
{
	_controls = [[NSMutableArray alloc] init];
	
	return ( self );
}

- (void)dealloc
{
	[_controls release];
	
	[super dealloc];
}

- (void)addControlOrLayout:(id) ctrl
{
	[_controls addObject:ctrl];
}

- (NSArray*)controls
{
	return _controls;
}

- (void)setFrame:(NSRect)frame
{
	_frame = frame;
}
- (NSRect)frame
{
	return ( _frame );
}

@end
