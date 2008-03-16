//
//  MPDConnectionLostDelegate.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 06.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDConnectionLostDelegate.h"


@protocol MPDConnectionLostDelegate
- (void) onConnectionLost;
@end
