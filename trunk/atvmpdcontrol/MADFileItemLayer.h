//
//  MADFileItemLayer.h
//  mpdctrl
//
//  Created by Marcus T on 7/5/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface MADFileItemLayer : BRTextMenuItemLayer {
	int	_type;
	NSString* _fileName;
}

- (id)initWithScene:(BRRenderScene*)scene withPath:(NSString*)path withType:(int)type;
- (void)dealloc;

- (int)type;
- (NSString*)fileName;


@end
