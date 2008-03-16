//
//  MPDListControlServerSource.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <BackRow/BackRow.h>

#import "MPDListControlServerSource.h"


@implementation MPDListControlServerSource


- (id)initWithScene: (BRRenderScene *) scene
{
    if ( [super initWithScene: scene] == nil )
        return ( nil );
	
	[self reload];
	
	[self setItemTextCentered:YES];

	return ( self );
}

- (void)reset
{
	[self reload];
}

- (void)reload
{
	[_array removeAllObjects];
	
	[_array addObject: @"Add Server"];
	[_array addObject: @"Add Server by IP"];

	NSArray * servers = [[RUIPreferenceManager sharedPreferences]
							  objectForKey: @"servers"
							  forDomain: @"com.apple.frontrow.appliance.axxr.mpdctrl"];				  
	
	if(servers != nil)
	{
		int i=0;
		for(;i<[servers count];i++)
		{
			[_array addObject: [servers objectAtIndex:i]];
		}
	}
}

- (int)defaultServer
{
	NSNumber* num = [[RUIPreferenceManager sharedPreferences]
									objectForKey: @"defaultServer"
									forDomain: @"com.apple.frontrow.appliance.axxr.mpdctrl"];
									
	if(num != nil)
		return [num intValue]; 

	return -1;
}

- (void)setDefaultServer:(int)index
{
	[[RUIPreferenceManager sharedPreferences]
			setObject: [NSNumber numberWithInt:index] 
			forKey: @"defaultServer"
			forDomain: @"com.apple.frontrow.appliance.axxr.mpdctrl"
			sync: YES];
}

- (void)store
{
	NSRange range;
	
	range.location = 2;
	range.length = [_array count]-2;
	
	[[RUIPreferenceManager sharedPreferences]
		setObject: [_array subarrayWithRange:range] 
		forKey: @"servers"
		forDomain: @"com.apple.frontrow.appliance.axxr.mpdctrl"
		sync: YES];	
}
@end
