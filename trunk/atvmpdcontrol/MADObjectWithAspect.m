//
//  MADObjectWithAspect.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 06.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADObjectWithAspect.h"


@implementation MADObjectWithAspect

-(id)initWithObject:(id)object andAspect:(float)aspect;
{
	_object = [object retain];
	_aspect = aspect;
	
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

-(float)aspect;
{
	return _aspect;
}



@end
