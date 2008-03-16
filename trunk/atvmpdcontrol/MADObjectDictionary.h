//
//  MADObjectDictionary.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MADObjectDictionary : NSObject {
	NSMutableArray* _valueArray;
	NSMutableArray* _keyArray;
}

- (id)init;
- (void)dealloc;

- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;

- (int)count;

@end
