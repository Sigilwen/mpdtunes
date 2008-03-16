//
//  MPDControlBar.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDControlBar.h"


@implementation MPDControlBar

- (id)initWithScene:(BRRenderScene*)scene
{
	if( [super initWithScene:scene] == nil )
		return nil;
		
	[self setDatasource:self];
		
	return ( self );
}

- (void)setDeactObject:(id)deactObject;
{
	_eventReceiver = (MADDeactivateableControl*)deactObject;
}

- (void)setSettingsTarget:(id)target
{
	_target = target;
}

- (BOOL)brEventAction:(BREvent*)event
{
	int ret =  [_eventReceiver processEvent:event];
	
	if(ret == -1)
		return NO;
	
	if(ret == 1)
		return YES;
		
	BREventPageUsageHash hash = [event pageUsageHash];

	if([event value] == 1)
	{
		if( hash == kBREventTapPlayPause )
		{
			if([self selected] == 0)
			{
				if(mpd_player_get_state([_mpdConnection object]) == MPD_PLAYER_STOP)
					mpd_player_play([_mpdConnection object]);
				else
					mpd_player_stop([_mpdConnection object]);
			}
			else if([self selected]  == 1)
			{
				mpd_player_pause([_mpdConnection object]);
			}
			else if([self selected]  == 2)
				mpd_player_next([_mpdConnection object]);
			else if([self selected]  == 3)
				mpd_player_prev([_mpdConnection object]);		
			if([self selected] == 4)
				[_target onAction];
				//mpd_player_set_random([_mpdConnection object], !mpd_player_get_random([_mpdConnection object]));
					
			[self reload]; 
			[[self scene] renderScene];
		}
	}
		

	return [super brEventAction:event];
}

- (void)setMpdConnection:(MPDConnection*)mpdConnection
{
	_mpdConnection = mpdConnection;
}

-(id<BRMenuItemLayer>)createItemWithText:(NSString*)text
{
	BRTextMenuItemLayer* item = [[BRTextMenuItemLayer alloc] initWithScene: _scene];
		
	[item setTitle: text centered:YES];
	[item setArrowDisabled:YES];
	[item setAlphaValue:[self alphaValue]];
	return [item autorelease];
}


- (id) itemForRow: (long) row
{
	if(!_mpdConnection || ![_mpdConnection isConnected] )
		return 0;

	MpdState state = mpd_player_get_state([_mpdConnection object]);
	
	if(row == 0)
	{
		if(state == MPD_PLAYER_STOP)
			return [self createItemWithText:@"Play"];
		else
			return [self createItemWithText:@"Stop"];
	}
	if(row == 1)
	{
		if(state == MPD_PLAYER_PAUSE)
			return [self createItemWithText:@"Resume"];
		else
			return [self createItemWithText:@"Pause"];
	}
	if(row == 2)
		return [self createItemWithText:@"Next"];
	if(row == 3)
		return [self createItemWithText:@"Previous"];

	if(row == 4)
		return [self createItemWithText:@"Settings"];
		
		
/*		if(mpd_player_get_random([_mpdConnection object]))
			return [self createItemWithText:@"Random"];
		else
			return [self createItemWithText:@"Linear"];
*/		
	return nil;
}

- (long) itemCount
{
	int count = 0;
	if(!_mpdConnection || ![_mpdConnection isConnected] )
		return count;
		
	count += 5;
	return count;
}

- (NSString *) titleForRow: (long) row
{
	return nil;
}

- (long) rowForTitle: (NSString *) title
{
	return -1;
}

@end
