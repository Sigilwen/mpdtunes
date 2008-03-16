//
//  MADLayout.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MADLayout : NSObject {
	NSMutableArray *	_controls;
	NSRect				_frame;
}


- (id)init;
- (void)dealloc;

- (void)doLayout;

- (void)setFrame:(NSRect)frame;
- (NSRect)frame;

@end
