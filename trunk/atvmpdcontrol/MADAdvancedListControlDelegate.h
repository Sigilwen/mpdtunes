/*
 *  MADAdvancedListControlDelegate.h
 *  mpdctrl
 *
 *  Created by Marcus Tillmanns on 03.06.07.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */
 
#import "MADAdvancedListControl.h"

@class MADAdvancedListControl;

@protocol MADAdvancedListControlDelegate
- (void)onKeyPressed:(BREventPageUsageHash)hash selectedItem:(int)selected;
@end
