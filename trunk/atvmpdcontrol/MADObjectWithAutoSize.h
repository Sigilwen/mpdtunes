//
//  MADObjectWithAutoSize.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MADObjectWithAutoSize : NSObject {
	id		_object;
}

-(id)initWithObject:(id)object;
-(void)dealloc;

-(id)object;

@end
