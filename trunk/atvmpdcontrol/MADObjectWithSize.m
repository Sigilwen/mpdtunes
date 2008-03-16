//
//  MADObjectWithSize.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADObjectWithSize.h"


@implementation MADObjectWithSize

-(id)initWithObject:(id)object andSize:(int)size
{
	_object = [object retain];
	_size = size;
	
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

-(int)size;
{
	return _size;
}

@end
