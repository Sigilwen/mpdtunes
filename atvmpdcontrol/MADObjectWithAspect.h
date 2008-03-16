//
//  MADObjectWithAspect.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 06.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MADObjectWithAspect : NSObject {
	id		_object;
	float	_aspect;
}

-(id)initWithObject:(id)object andAspect:(float)aspect;
-(void)dealloc;

-(id)object;

-(float)aspect;

@end
