//
//  MADAdvancedListControl.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

#import "MADAdvancedListControlDelegate.h"

@interface MADAdvancedListControl : BRListControl 
{
	id <MADAdvancedListControlDelegate> _target;
}

-(id)initWithScene:(BRRenderScene*)scene;

-(void)setTarget:(id <MADAdvancedListControlDelegate>)target;
-(id <MADAdvancedListControlDelegate>)target;

-(BOOL)brEventAction:(BREvent*)brEvent;
@end
