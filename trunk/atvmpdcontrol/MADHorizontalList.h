//
//  MADHorizontalList.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 08.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface MADHorizontalList : BRControl {
    BRRenderLayer*				_selectionLayer;	// 104 = 0x68
	BRRenderLayer*				_layer;
	BRFrameAnimation*			_selectionAnim;
	
	
	NSRect						_frame;
	NSMutableArray*				_itemArray;
	id							_datasource;
	int							_selected;
	BOOL						_beingReloaded;
}

- (id)initWithScene:(BRRenderScene*)scene;
- (void)dealloc;

- (void)setDatasource:(id)fp8;
- (id)datasource;

- (void)setSelected:(int)selection;
- (int)selected;

- (BRRenderLayer*)layer;

- (void)reload;
- (BOOL)brEventAction:(BREvent*)brEvent;

- (void)setFrame:(NSRect)frame;
- (NSRect)frame;

@end
