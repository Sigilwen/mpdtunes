//
//  MADListControlArrayDataSource.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 01.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MADListControlArrayDataSource : NSObject {
	NSMutableArray * _array;
	NSMutableArray * _rightArray;
	BRRenderScene *  _scene;
	BOOL			 _centered;
}

- (void) dealloc;

- (NSMutableArray*) getArray;
- (NSMutableArray*) getRightAlignedArray;

- (id) initWithScene: (BRRenderScene *) scene;
- (void)setItemTextCentered:(BOOL) centered;
- (long) itemCount;
- (id<BRMenuItemLayer>) itemForRow: (long) row;
- (NSString *) titleForRow: (long) row;
- (long) rowForTitle: (NSString *) title;





@end
