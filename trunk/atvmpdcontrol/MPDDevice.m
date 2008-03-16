//
//  MPDDevice.m
//  mpdctrl
//
//  Created by Marcus T on 6/15/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDDevice.h"


@implementation MPDDevice

- (id) initWithMpdOutputEnt:(mpd_OutputEntity*)entity
{
	if([self init] == nil)
		return nil;
		
	_id = entity->id;
	_name = [[NSString stringWithCString: entity->name encoding:NSUTF8StringEncoding]retain];
	_enabled = entity->enabled;
	
	return self;
}

- (void)dealloc
{
	[_name release];
	[super dealloc];
}


- (BOOL)isEnabled
{
	return _enabled;
}
- (NSString*) getName
{
	return _name;
}
- (int)getID
{
	return _id;
}
@end
