//
//  MADObjectWithConstraint.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MADObjectWithConstraint : NSObject {
	id		_object;
	float	_constraint;
}

-(id)initWithObject:(id)object andConstraint:(float)constraint;
-(void)dealloc;

-(id)object;

-(float)constraint;

@end
