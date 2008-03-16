//
//  MPDPlayerPage.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "libmpd/libmpd.h"

#import "MPDConnection.h"
#import "MADVertLayout.h"
#import "MADMultiReceiverController.h"

@interface MPDPlayerController : MADMultiReceiverController <MPDConnectionLostDelegate, MPDStatusChangedDelegate> 
{	
	MPDConnection*					_mpdConnection;
	BRHeaderControl *				_header;
	MADVertLayout*					_layout;
		
	int								_currentSelectedArtist;
	int								_currentSelectedAlbum;
	
	NSMutableArray *				_dataSrcArray;
	NSMutableArray *				_listCtrlArray;	
	
	NSMutableArray*					_selectedSongIds;
}

- (id)initWithScene:(id)scene;
- (void)dealloc;

- (void)setMpdConnection:(MPDConnection*)mpdConnection; 
- (void)onConnectionLost;
- (void)onStatusChanged:(ChangedStatusType)what;

- (void)onArtist;
- (void)onAlbum;
- (void)onSong;

- (NSMutableArray*)getSelectedSongIds;

- (BOOL)brEventAction:(BREvent *) brEvent;

- (void) willBePushed;
- (void) willBePopped;

@end
