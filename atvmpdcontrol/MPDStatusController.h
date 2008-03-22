//
//  MPDStatusController.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MPDConnection.h"
#import "MPDSmallTextControl.h"

#import "MPDVolumeCtrl.h"

#import "MADHorzLayout.h"
#import "MADVertLayout.h"

#import "MPDListControlPlaylistSource.h"
#import "MADPlaylistList.h"

#import "MADMultiReceiverController.h"
#import "MPDControlBar.h"
#import "MADHorizontalProgressBar.h"
#import "MPDControlBarDelegate.h"
#import "MPDSettingsController.h"

#import "MADGLControl.h"


@interface MPDStatusController : MADMultiReceiverController <MPDConnectionLostDelegate, MPDStatusChangedDelegate, MPDControlBarDelegate> {
	MPDControlBar*					_controlBar;
	MADPlaylistList*				_playlistCtrl;
	MPDConnection*					_mpdConnection;
	MPDSmallTextControl*			_songLabel;
	MPDSmallTextControl*			_timeLabel;
	MADHorizontalProgressBar*		_progressCtrl;
	
	MPDVolumeCtrl*					_volumeBar;
	MPDSmallTextControl*			_volumeLabel;
	
	MADVertLayout*					_volumeLayout;
	MADHorzLayout*					_timeLayout;

	MPDSettingsController*			_settingsController;
	
	MADGLControl*					_glControl;
}

- (id)initWithScene:(id)scene;
- (void)dealloc;

- (id)retain;
- (void)release;

- (void)setMpdConnection:(MPDConnection*)mpdConnection; 
- (void)onConnectionLost;
- (void)onStatusChanged:(ChangedStatusType)what;

- (void)updateProgressCtrl;

- (void)onAction;

- (void)willBePopped;
- (void)willBePushed;

@end
