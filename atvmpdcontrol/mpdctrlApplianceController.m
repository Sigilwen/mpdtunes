//
//  mpdctrlApplianceController.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 31.05.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "mpdctrlApplianceController.h"
#import <BackRow/BackRow.h>
#import <AppKit/NSFont.h>

#import "MADAlphaFriendlyRenderLayer.h"

#import "MADHorzLayout.h"
#import "MADVertLayout.h"




@implementation mpdctrlApplianceController

- (id) initWithScene: (BRRenderScene *) scene
{
    if ( [super initWithScene: scene] == nil )
        return ( nil );
		
	[self addLabel:@"com.apple.frontrow.appliance.axxr.mpdctrl.rootController"];
	
	_mpdConnection = [[MPDConnection alloc] init];

	_statusController = [[MPDStatusController alloc] initWithScene:scene];
	
	[_statusController setMpdConnection:_mpdConnection];

	_alertController = [BRAlertController alertOfType:2
			   titled:@""
			   primaryText:@"Couldn't connect to specified Server"
			   secondaryText:@"Check if your network is up and running"
			   withScene:scene];
			   
	[_alertController retain];
	
	
    return ( self );
}

- (void) dealloc
{
	[_mpdConnection release];
	[_alertController release];
	[_statusController release];
	
    // always remember to deallocate your resources
    [super dealloc];
}


- (void)onKeyPressed:(BREventPageUsageHash)hash selectedItem:(int)selected
{
	[super onKeyPressed:hash selectedItem:selected];

	if(hash == kBREventTapPlayPause && selected > 1)
	{
		MPDConnectionResult res =  [_mpdConnection	connectToHost:_selectedHost 
													withPort:_selectedPort 
													withPassword:_selectedPassword];

		if( res != MPDConnectionFailed )
		{
			[[self stack]pushController:_statusController];
		}
		else
			[[self stack]pushController:_alertController];
	
/*		_selectedServerAddress = [[_serverListSource getArray] objectAtIndex:selected];

		if(_mpdObj != nil)
			mpd_free(_mpdObj);
			
		_mpdObj = mpd_new((char*)[_selectedServerAddress cStringUsingEncoding:NSUTF8StringEncoding], 6600, 0);
	
		if( [_playerController setMpdObj:_mpdObj] ) 
			[[self stack]pushController:_playerController];
		else
		{
			[[self stack]pushController:_alertController];
		
		}
	*/
	}

}

- (void) willBePushed
{  
    // always call super
    [super willBePushed];
}

- (void) wasPushed
{
    // We've just been put on screen, the user can see this controller's content now

//	[[self stack]pushController:_serverController];
    
    // always call super
    [super wasPushed];
}

- (void) willBePopped
{
    // The user pressed Menu, but we've not been removed from the screen yet
    
    // always call super
    [super willBePopped];
}

- (void) wasPopped
{
    // The user pressed Menu, removing us from the screen
    
    // always call super
    [super wasPopped];
}

- (void) willBeBuried
{
    // The user just chose an option, and we will be taken off the screen
    
    // always call super
    [super willBeBuried];
}

- (void) wasBuriedByPushingController: (BRLayerController *) controller
{
    // The user chose an option and this controller os no longer on screen
    
    // always call super
    [super wasBuriedByPushingController: controller];
}

- (void) willBeExhumed
{
    // the user pressed Menu, but we've not been revealed yet
    
	[_mpdConnection disconnect];
    // always call super
    [super willBeExhumed];
}

- (void) wasExhumedByPoppingController: (BRLayerController *) controller
{
    // handle being revealed when the user presses Menu
	
    // always call super
    [super wasExhumedByPoppingController: controller];
}

@end
