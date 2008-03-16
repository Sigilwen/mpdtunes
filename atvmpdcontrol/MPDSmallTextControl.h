//
//  MPDCtrlListHeaderControl.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BRTextControl.h>

@interface MPDSmallTextControl : BRTextControl {

}

- (id)initWithScene: (BRRenderScene*)scene;
- (id)initWithScene: (BRRenderScene*)scene withFontSize:(float)size;
- (id)initWithScene: (BRRenderScene*)scene withFontSize:(float)size withColor:(NSColor*)color;

- (void)setFrame:(NSRect)frame;

@end
