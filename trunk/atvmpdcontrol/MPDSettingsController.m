//
//  MPDSettingsController.m
//  mpdctrl
//
//  Created by Marcus T on 6/15/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDSettingsController.h"
#import "MPDDevice.h"

@implementation MPDSettingsController

- (id) initWithScene:(BRRenderScene*)scene
{
	if( [super initWithScene:scene] == nil)
		return nil;
	
	_mpdConnection = nil;
	_currentAudioDevice = 0;
	
	[[self list]setDatasource:self];
	
    // we want to know when the list selection changes, so we can pass
    // that information on to the icon march layer
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(selectionChanged:)
                                                 name: @"ListControlSelectionChangedNotification"
                                               object: [self list]];	
	
	[self setListTitle:@"Settings"];
	
	[self createDescText];//[[BRParagraphTextControl alloc]initWithScene:scene];
	
	[self addControl:_descText];
	
	_layout = [[MADHorzLayout createSafeLayout:scene]retain];
	
	MADVertLayout* vertLayout = [[MADVertLayout alloc]init];
	
	[_layout addObject:vertLayout withConstraint:1.0];
	[_layout addObject:nil withConstraint:1.0];
	
	[vertLayout addObject:nil withConstraint:1.0];
	[vertLayout addObject:_descText];
	[vertLayout addObject:nil withConstraint:1.0];
																
	[_layout doLayout];
	
				
	return (self);
}

- (void) dealloc
{
	[_layout release];
	[_descText release];
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[super dealloc];
}

- (void) createDescText
{
	_descText = [[BRTextControl alloc]initWithScene:[self scene]];

	// Create a new target Dictionay
	NSMutableDictionary * mutDict = [[[NSMutableDictionary alloc] init] autorelease];
	
	// Get the old attribtes
	NSDictionary *orgAttr = [_descText textAttributes];
	// Copy the old attributes to the new Dictionary
//	[mutDict setDictionary:orgAttr];
	// Create a new font
	NSFont *newFont = [NSFont boldSystemFontOfSize:18.0];//[NSFont fontWithName:@"Helvetica" size:20.0];
	// Set the new font
	[mutDict setValue:newFont forKey:NSFontAttributeName];
	
	float floatComps[4];
	floatComps[0] = 1.0;
	floatComps[1] = 1.0;
	floatComps[2] = 1.0;
	floatComps[3] = 1.0;

	
	CGColorRef newColor = CGColorCreate (CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB), floatComps);

	[mutDict setValue:newColor forKey:NSForegroundColorAttributeName];	
		
	[mutDict setValue:[NSNumber numberWithInt:4] forKey:@"CTTextAlignment"];
	
	// Set the new Attributes
	[_descText setTextAttributes: mutDict ];

	[_descText setMaxLines:20];

//	[[_descText layer] setColorText:YES];

	[_descText setText:@""];
}

- (void)setDescription:(NSString*)description
{
	if(description == nil)
		[_descText setText:@""];
	else
		[_descText setText:description];
	
	[[self scene]renderScene];
	[_layout doLayout];
}

- (void)setMpdConnection:(MPDConnection*)mpdConnection; 
{
	_mpdConnection = mpdConnection;
}

- (void) onStatusChanged:(ChangedStatusType)what
{
	bool doReload = NO;
	
	if(what & MPD_CST_UPDATING)
		doReload = YES;
	if(what & MPD_CST_REPEAT)
		doReload = YES;
	if(what & MPD_CST_RANDOM)
		doReload = YES;
	if(what & MPD_CST_CROSSFADE)
		doReload = YES;		

	if(doReload)
	{
		[[self list] reload];
		[[self scene] renderScene];	
	}
}

- (void) onConnectionLost
{
	// Jump directly back to the root Controller
	[[self stack] popToControllerWithLabel:@"com.apple.frontrow.appliance.axxr.mpdctrl.rootController"];
}

-(id<BRMenuItemLayer>)createItemWithText:(NSString*)text
{
	return [self createItemWithText:text rightJustifiedText:nil];
}

-(id<BRMenuItemLayer>)createItemWithText:(NSString*)text rightJustifiedText:(NSString*)rText
{
	BRTextMenuItemLayer* item = [[BRTextMenuItemLayer alloc] initWithScene: _scene];
	
	if(rText != nil)
		[item setRightJustifiedText:rText];
	
	[item setTitle: text centered:NO];
	[item setArrowDisabled:YES];
	
	return [item autorelease];
}

- (long) itemCount
{
	if(_mpdConnection != nil)
		return 5;

	return 0;
}

- (NSArray*)getDeviceList
{
	NSMutableArray* array = [[[NSMutableArray alloc]init]autorelease];
	MpdData* pData = nil;
	
	for(pData = mpd_server_get_output_devices([_mpdConnection object] );
		pData != NULL; 
		pData = mpd_data_get_next(pData) )
	{
		if(pData->type == MPD_DATA_TYPE_OUTPUT_DEV)
		{
			MPDDevice* dev = [[MPDDevice alloc]initWithMpdOutputEnt:pData->output_dev];
			
			[array addObject:dev];
		}
	}
	
	return array;
}

- (id<BRMenuItemLayer>) itemForRow: (long) row
{
	/*
	* Audio Output
* Linear / Random
* Repeat 
* X-Fade / -time
* Update
	*/
	if(row == 0)
	{
		NSArray* devArray = [self getDeviceList];
		if(_currentAudioDevice >= [devArray count])
			_currentAudioDevice = [devArray count]-1;
			
		if(_currentAudioDevice >= 0)
		{
			NSString* enabled;
			if([[devArray objectAtIndex:_currentAudioDevice] isEnabled])
				enabled = @"Enabled";
			else
				enabled = @"Disabled";
			
			return [self createItemWithText:[[devArray objectAtIndex:_currentAudioDevice]getName] rightJustifiedText:enabled];
		}
	}
	else if(row == 1)
	{
		if(mpd_player_get_random([_mpdConnection object]))
			return [self createItemWithText:@"Random"];
		else
			return [self createItemWithText:@"Linear"];		
	}
	else if(row == 2)
	{
		if(mpd_player_get_repeat([_mpdConnection object]))
			return [self createItemWithText:@"Repeat"];
		else
			return [self createItemWithText:@"Once"];	
	}
	else if(row == 3)
	{
		int crossfadeTime = mpd_status_get_crossfade([_mpdConnection object]);
		
		if(crossfadeTime == 0)
			return [self createItemWithText:@"Crossfade" rightJustifiedText:@"disabled"];
		else
		{
			NSString * time = [NSString stringWithFormat:@"%i secs", crossfadeTime];
			
			return [self createItemWithText:@"Crossfade" rightJustifiedText:time];
		}
	}
	else if(row == 4)
	{
		if(mpd_status_db_is_updating([_mpdConnection object]) == NO)
		{
			unsigned long lastUpdate = mpd_server_get_database_update_time([_mpdConnection object]);
			
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
			[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
			[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
			 
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)lastUpdate];
			NSString *time = [dateFormatter stringFromDate:date];

			return [self createItemWithText:@"Update Database" rightJustifiedText:time];
		}
		else
		{
			return [self createItemWithText:@"Update Database" rightJustifiedText:@"updating ..."];
		}
	}
	else
		return [self createItemWithText:@"Not Implemented"];
	
	return nil;
}

- (BOOL)brEventAction:(BREvent *) brEvent
{
	BREventPageUsageHash hash = [brEvent pageUsageHash];
	
	BOOL bReload = NO;
	BOOL returnYES = NO;

	if([brEvent value] == 1)
	{
		int selected = [(BRListControl*)[self list] selection];
		
		if(selected == 0)
		{
			if( hash == kBREventTapPlayPause )
			{
				NSArray* devArray = [self getDeviceList];
				if(_currentAudioDevice >= [devArray count])
					_currentAudioDevice = [devArray count]-1;
					
				if(_currentAudioDevice >= 0)
				{	
					mpd_server_set_output_device([_mpdConnection object], 
												 [[devArray objectAtIndex:_currentAudioDevice] getID],
												  [[devArray objectAtIndex:_currentAudioDevice] isEnabled] == NO );
				
					bReload = YES;
					returnYES = YES;
				}
			}
			else if(hash == kBREventTapLeft)
			{
				if(_currentAudioDevice > 0)
				{
					_currentAudioDevice -= 1;
					bReload = YES;
					returnYES = YES;
				}
			}
			else if(hash == kBREventTapRight)
			{
				_currentAudioDevice += 1;
				bReload = YES;
				returnYES = YES;	
			}
		}
		else if(selected == 1 && hash == kBREventTapPlayPause)
		{
			mpd_player_set_random([_mpdConnection object], !mpd_player_get_random([_mpdConnection object]));
			bReload = YES;
			returnYES = YES;			
		}
		else if(selected == 2 && hash == kBREventTapPlayPause)
		{
			mpd_player_set_repeat([_mpdConnection object], !mpd_player_get_repeat([_mpdConnection object]));
			bReload = YES;
			returnYES = YES;			
		}
		else if(selected == 3)
		{
			int crossfadeTime = mpd_status_get_crossfade([_mpdConnection object]);
			
			if( hash == kBREventTapPlayPause )
			{
				if(crossfadeTime == 0)
					mpd_status_set_crossfade([_mpdConnection object], 5);
				else
					mpd_status_set_crossfade([_mpdConnection object], 0);
			
				bReload = YES;
				returnYES = YES;
			}
			else if(hash == kBREventTapRight)
			{
				mpd_status_set_crossfade([_mpdConnection object], crossfadeTime+1);
				bReload = YES;
				returnYES = YES;
			}
			else if(hash == kBREventTapLeft)
			{
				if(crossfadeTime > 0)
				{
					mpd_status_set_crossfade([_mpdConnection object], crossfadeTime-1);
					bReload = YES;
					returnYES = YES;
				}
			}			
		}
		else if(selected == 4 && hash == kBREventTapPlayPause)
		{
			if(mpd_status_db_is_updating([_mpdConnection object]) == NO)
			{
				mpd_database_update_dir([_mpdConnection object], 0);
				bReload = YES;
				returnYES = YES;
			}
		}
	}
	
	if(bReload)
	{
		[[self list] reload];
		[[self scene] renderScene];
	}
	
	if(returnYES)
		return YES;

	return [super brEventAction:brEvent];
}

- (NSString *) titleForRow: (long) row
{
	return nil;
}

- (long) rowForTitle: (NSString *) title
{
	return -1;
}

- (void) selectionChanged: (NSNotification *) note
{
    int selected = [[note object] renderSelection];
	
	NSString* newdesc = nil;
	
	if(selected == 0)
		newdesc = @"Press Play/Pause to enable/disable the Audio output. You can cycle through the available outputs with left/right.";
	else if(selected == 1)
		newdesc = @"Press Play/Pause to toggle random/linear traversal through the playlist.";
	else if(selected == 2)
		newdesc = @"Press Play/Pause to toggle between playing the playlist once or looping it.";
	else if(selected == 3)
		newdesc = @"Use left/right to set the crossfade time between consequtive songs. Crossfade can be completly disabled too.";
	else if(selected == 4)
		newdesc = @"Press Play/Pause to let the server update its media directory. When finished it shows the time of the last Update.";
		
	[self setDescription:newdesc];
}

- (void) willBePushed
{
	[_mpdConnection addConnectionLostReceiver:self];
	[_mpdConnection addStatusListener:self];
	
	[[self list]reload];
	
	[super willBePushed];
}

- (void) willBePopped
{	
	[_mpdConnection removeConnectionLostReceiver:self];
	[_mpdConnection removeStatusListener:self];
	
	[super willBePopped];
}


@end
