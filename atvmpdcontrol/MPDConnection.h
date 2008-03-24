//
//  MPDConnection.h
//  mpdctrl
//
//  Created by Marcus Tillmanns on 06.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "libmpd/libmpd.h"

#import "MPDConnectionLostDelegate.h"
#import "MPDStatusChangedDelegate.h"


typedef enum
{
	MPDConnectionFailed = -1,
	MPDOk = 0,
	MPDWrongServerVersion = 1
} MPDConnectionResult;


@interface MPDConnection : NSObject {
	MpdObj*			_mpdObj;
	NSTimer*		_updateTimer;
	NSMutableArray*	_connectionLostReceiverArray;
	NSMutableArray* _statusChangedListenerArray;
}

- (id)init;
- (void)dealloc;

- (id)retain;
- (void)release;

- (MPDConnectionResult)connectToHost:(NSString*)host;
- (MPDConnectionResult)connectToHost:(NSString*)host withPort:(int)port;
- (MPDConnectionResult)connectToHost:(NSString*)host withPort:(int)port withPassword:(NSString*)password;

- (void)disconnect;

- (BOOL)setPassword:(NSString*)password;

- (BOOL)isConnected;

- (BOOL)commandAllowed:(NSString*)commandName;

- (MpdObj*)object;

- (void)addConnectionLostReceiver:(id <MPDConnectionLostDelegate>)target;
- (void)removeConnectionLostReceiver:(id <MPDConnectionLostDelegate>)target;

- (void)addStatusListener:(id <MPDStatusChangedDelegate>)target;
- (void)removeStatusListener:(id <MPDStatusChangedDelegate>)target;


- (MpdData *)mpdSearchTag: (mpd_TagItems)tag
                 forGenre: (NSString *)genre
                andArtist: (NSString *)artist
                 andAlbum: (NSString *)album
                  andSong: (NSString *)song;
- (MpdData *)mpdSearchGenre: (NSString *)genre
                  andArtist: (NSString *)artist
                   andAlbum: (NSString *)album
                    andSong: (NSString *)song;
- (MpdData *)mpdSearchNext: (MpdData *)data;
- (void)mpdSearchFree: (MpdData *)data;


// Private Functions, do not call ( or tell me how to protect them ;)
- (void)onUpdateTimer;
- (void)onError:(int)errorId withMsg:(NSString*)errorMsg;
- (void)onStatusChanged:(ChangedStatusType)what;

- (void)removeTimer;
- (void)initTimer;

@end

NSString * str2nsstr( const char *str );
