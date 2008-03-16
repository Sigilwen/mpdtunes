//
//  MPDStatusChangedDelegate.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 06.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "libmpd/libmpd.h"

@protocol MPDStatusChangedDelegate
- (void)onStatusChanged:(ChangedStatusType)what;
@end
