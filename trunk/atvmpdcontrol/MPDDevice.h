//
//  MPDDevice.h
//  mpdctrl
//
//  Created by Marcus T on 6/15/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "libmpd/libmpd.h"
#import "MPDConnection.h"

@interface MPDDevice : NSObject {
	NSString*		_name;
	BOOL			_enabled;
	int				_id;
}

- (id) initWithMpdOutputEnt:(mpd_OutputEntity*)entity;
- (void)dealloc;

- (BOOL)isEnabled;
- (NSString*) getName;
- (int)getID;

@end
