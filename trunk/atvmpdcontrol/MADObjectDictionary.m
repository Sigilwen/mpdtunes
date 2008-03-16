//
//  MADObjectDictionary.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADObjectDictionary.h"


@implementation MADObjectDictionary

- (id)init
{
	if( [super init] == nil)
		return nil;
		
	_valueArray = [[NSMutableArray alloc]init];
	_keyArray = [[NSMutableArray alloc]init];

	return ( self );
}
- (void)dealloc
{
	[_valueArray release];
	[_keyArray release];
	[super dealloc];
}

- (id)objectForKey:(id)key
{
	int index = [_keyArray indexOfObjectIdenticalTo:key];
	
	if(index == NSNotFound)
		return nil;
		
	return [_valueArray objectAtIndex:index];
}

- (void)setObject:(id)object forKey:(id)key
{
	int index = [_keyArray indexOfObjectIdenticalTo:key];

	if(index == NSNotFound)
	{
		index = [_keyArray count];
		[_keyArray addObject:key];
		[_valueArray addObject:object];
		return;
	}
	
	[_valueArray replaceObjectAtIndex:index withObject:object];
}

- (int)count
{
	return [_valueArray count];
}


@end
