//
//  MADObjectWithSizeFromObject.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MADObjectWithSizeFromObject : NSObject {
	id		_object;
	id		_sizeObject;
}

-(id)initWithObject:(id)object sizeObject:(id)sizeObject;
-(void)dealloc;

-(id)object;
-(id)sizeObject;

@end
