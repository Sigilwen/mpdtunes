//
//  MADObjectWithAutoSize.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADObjectWithAutoSize.h"


@implementation MADObjectWithAutoSize

-(id)initWithObject:(id)object
{
	_object = [object retain];
	
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

@end
