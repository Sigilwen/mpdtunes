//
//  MADObjectWithSizeFromObject.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADObjectWithSizeFromObject.h"


@implementation MADObjectWithSizeFromObject

-(id)initWithObject:(id)object sizeObject:(id)sizeObject;
{
	_object = [object retain];
	_sizeObject = [sizeObject retain];
	
	return ( self );
}

-(void)dealloc
{
	[_sizeObject release];
	[_object release];
	[super dealloc];
}

-(id)object
{
	return ( _object );
}

-(id)sizeObject;
{
	return ( _sizeObject );
}

@end
