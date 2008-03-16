//
//  MADVolumeCtrl.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDVolumeCtrl.h"


@implementation MPDVolumeCtrl


- (id)initWithScene:(BRRenderScene*)scene
{
	if( [super initWithScene:scene] == nil)
		return nil;
		
	_eventReceiver = nil;
	_mpdConnection = nil;
		
	return ( self );
}

- (void)dealloc
{
	[super dealloc];
}

- (void)setDeactObject:(id)deactObject;
{
	_eventReceiver = (MADDeactivateableControl*)deactObject;
}

- (void)setMpdConnection:(MPDConnection*)mpdConnection
{
	_mpdConnection = mpdConnection;
}

- (void)update
{
	int volume = mpd_status_get_volume([_mpdConnection object]);
	
	if(volume > 0 && volume <= 100)
	{
		[self setPercent:volume/100.0];
	}
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
		if( hash == kBREventTapUp )
		{
			mpd_status_set_volume([_mpdConnection object], mpd_status_get_volume([_mpdConnection object]) + 10);
			[self update];
			[[self scene]renderScene];
			return YES;
		}
		if( hash == kBREventTapDown )
		{
			mpd_status_set_volume([_mpdConnection object],  mpd_status_get_volume([_mpdConnection object]) - 10);
			[self update];
			[[self scene]renderScene];
			return YES;
		}		
	}	
	

	return [super brEventAction:event];
}

@end
