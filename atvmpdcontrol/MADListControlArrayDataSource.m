//
//  MADListControlArrayDataSource.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 01.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADListControlArrayDataSource.h"


@implementation MADListControlArrayDataSource

- (id) initWithScene: (BRRenderScene *) scene;
{
	_scene = scene; 
	_array = [[NSMutableArray alloc] init];
	_rightArray = [[NSMutableArray alloc] init];
	_centered = NO;

	return ( self );
}

- (void) dealloc
{
	[_array release];
	[_rightArray release];
	[super dealloc];
}

- (NSMutableArray*) getArray
{
	return (_array);
}

- (NSMutableArray*) getRightAlignedArray
{
	return (_rightArray);
}

- (void)setItemTextCentered:(BOOL) centered
{
	_centered = centered;
}

- (id<BRMenuItemLayer>) itemForRow: (long) row
{
	if([_array count] <= row)
		return nil;
		
	BRTextMenuItemLayer* item = [[BRTextMenuItemLayer alloc] initWithScene: _scene];
	
	if([_rightArray count ] > row)
		[item setRightJustifiedText:[_rightArray objectAtIndex:row]];
	
	[item setTitle: [_array objectAtIndex:row ] centered:_centered];
	[item setArrowDisabled:YES];
	
	return [item autorelease];
}

- (NSString *) titleForRow: (long) row
{
    // return the title for the list item at the given index here
    return ( [_array objectAtIndex:row] );
}

- (long) rowForTitle: (NSString *) title
{
    long result = -1;
    long i, count = [self itemCount];
    for ( i = 0; i < count; i++ )
    {
        if ( [title isEqualToString: [_array objectAtIndex:i]] )
        {
            result = i;
            break;
        }
    }
    
    return ( result );
}


- (long) itemCount
{
	long count = [_array count];
	return count;
}

- (void) itemSelected: (long) row
{
    // This is called when the user presses play/pause on a list item
}

@end
