//
//  MADObjectWithSize.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MADObjectWithSize : NSObject {
	id		_object;
	int		_size;
}

-(id)initWithObject:(id)object andSize:(int)size;
-(void)dealloc;

-(id)object;

-(int)size;

@end
