//
//  MADObjectWithConstraint.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADObjectWithConstraint.h"


@implementation MADObjectWithConstraint


-(id)initWithObject:(id)object andConstraint:(float)constraint
{
	_object = [object retain];
	_constraint = constraint;
	
	return ( self );
}

-(void)dealloc
{
	[_object release];
	[super dealloc];
}

-(id)object
{
	return ( _object );
}

-(float)constraint;
{
	return _constraint;
}

@end
