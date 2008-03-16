//
//  MADHorizontalList.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 08.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADHorizontalList.h"
#import "MADHorzLayout.h"

#import "MADDebugSelector.h"

@implementation MADHorizontalList

- (id)initWithScene:(BRRenderScene*)scene
{
	if( [super initWithScene:scene] == nil )
		return nil;
		
	_selected = 0;
	
	_selectionAnim = nil;
		
	_itemArray = [[NSMutableArray alloc] init];
	
	_layer = [[BRRenderLayer alloc]initWithScene:scene];
	
	_selectionLayer = [[BRSelectionLozengeLayer alloc]initWithScene:scene];
	
	[_layer addSublayer:_selectionLayer];
	
	_beingReloaded = NO;
	
	return (self);
}

- (void)dealloc
{
	[_selectionAnim stop];
	[_selectionAnim release];

	if(_datasource != self)
		[_datasource release];
	[_selectionLayer release];
	[_itemArray release];
	[_layer release];
	
	[super dealloc];
}

- (BRRenderLayer*)layer
{
	return _layer;
}

- (void)setDatasource:(id)datasource
{
	if(datasource != self)
		[datasource retain];
		
	if(_datasource != self)
		[_datasource release];
	
	_datasource = datasource;
}

- (id)datasource
{
	return _datasource;
}

- (NSSize)sizeForSelectionLayer
{
	NSSize s = [self frame].size;
	
	if([_itemArray count] > 0)
	{
		s.width /= [_itemArray count];
	
//		int overhang = [_selectionLayer overHangForRowHeight:s.height];
//		s.width -= overhang / 4;
	}
	
	return s;	
}

- (void)setSelected:(int)selection
{
	_selected = selection;
	
	if(_selected < 0 || _selected > [_itemArray count]-1)
		return;
	
	if(_selectionAnim != nil)
	{
		[_selectionAnim stop];
		[_selectionAnim release];
	}

	_selectionAnim = [[BRFrameAnimation alloc]initWithScene:[self scene]];

	NSRect newframe = NSZeroRect;
	newframe.size = [self sizeForSelectionLayer];
	newframe.origin.x = _selected * ([self frame].size.width / [_itemArray count]);

	[_selectionAnim setRenderLayer: _selectionLayer];
	[_selectionAnim setTargetFrame: newframe];
	[_selectionAnim setDuration: 0.25];
	[_selectionAnim setAsynchronous:YES];
	
	[_selectionAnim run];
}

- (int)selected
{
	return _selected;
}

- (void)setFrame:(NSRect)frame
{
	int i=0;
	_frame = frame;
	
	MADHorzLayout* layout = [[[MADHorzLayout alloc]init]autorelease];
	
	NSRect layerRect = NSZeroRect;
	layerRect.size = frame.size;
	[layout setFrame:layerRect];
	
	for(i=0;i<[_itemArray count];i++)
	{
		id item = [_itemArray objectAtIndex:i];
		[layout addObject:[MADHorzLayout createCenterLayout:item] withConstraint:1.0];
	}	
	
	[layout doLayout];	
	
	NSRect selectionFrame = NSZeroRect;
	
	selectionFrame.size = [self sizeForSelectionLayer];
	
	if(_selected <= [_itemArray count]-1)
		selectionFrame.origin.x = _selected * ([self frame].size.width / [_itemArray count]);
	
	[_selectionLayer setFrame:selectionFrame];
	
	[super setFrame:frame];
}

- (NSRect)frame
{
	return _frame;
}

- (void)reload
{	
	int i=0;
	
	if(_beingReloaded)
		return;
	
	@synchronized(self)
	{
		_beingReloaded = YES;
	
		for(i=0;i<[_itemArray count];i++)
		{
			[(BRRenderLayer*)[_itemArray objectAtIndex:i] removeFromSuperlayer];
		}
		
		[_itemArray removeAllObjects];
		
		if(!_datasource)
			return;
		
		for(i=0;i<[_datasource itemCount];i++)
		{
			id item = [_datasource itemForRow:i];
			[_itemArray addObject:item];
			[_layer addSublayer:item];
		}
		
		// Update sizes
		[self setFrame:[self frame]];
		
		_beingReloaded = NO;
	}
}

- (BOOL)brEventAction:(BREvent*)brEvent
{
	if([brEvent value] == 1)
	{
		if([brEvent pageUsageHash] == kBREventTapLeft)
		{
			if(_selected > 0)
				[self setSelected:_selected-1];
			return YES;
		}
		if([brEvent pageUsageHash] == kBREventTapRight)
		{
			if(_selected < [_itemArray count] - 1)
				[self setSelected:_selected+1];
			return NO;
		}
	}

	return [super brEventAction:brEvent];
}


@end
