//
//  MPDServerController.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MPDAddressEntryController.h"
#import "MADAdvancedListControl.h"
#import "MPDListControlServerSource.h"
#import "MPDConnection.h"


@interface MPDServerController : BRLayerController <MADAdvancedListControlDelegate>
{
	NSMutableArray *				_servers;

	MPDAddressEntryController*		_textEntryController;

	MADAdvancedListControl*			_serverListCtrl;
	MPDListControlServerSource*		_serverListSource;
	
	NSString*						_selectedHost;
	int								_selectedPort;
	NSString*						_selectedPassword;
}

- (id)initWithScene:(id)scene;

- (BOOL)brEventAction:(BREvent*) brEvent;

- (void)onKeyPressed:(BREventPageUsageHash)hash selectedItem:(int)selected;

- (void) wasExhumedByPoppingController: (BRLayerController *) controller;

@end
