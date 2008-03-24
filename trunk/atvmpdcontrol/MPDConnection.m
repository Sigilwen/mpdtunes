//
//  MPDConnection.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 06.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDConnection.h"

void addConstraints( MPDConnection * mpdConnection, NSString *genre, NSString *artist, NSString *album, NSString *song );

@implementation MPDConnection

- (id)init
{
	_mpdObj = nil;
	_updateTimer = nil;
	
	_connectionLostReceiverArray = [[NSMutableArray alloc] init]; 
	_statusChangedListenerArray = [[NSMutableArray alloc] init];
	
	return ( self );
}

- (void)dealloc
{
	[_connectionLostReceiverArray release];
	[_statusChangedListenerArray release];
	
	if(_mpdObj != nil)
		mpd_free(_mpdObj);
	
	_mpdObj = nil;
	
	[super dealloc];
}

- (id)retain
{
	return [super retain];
}

- (void)release
{
	[super release];
}

- (MpdObj*)object
{
	return _mpdObj;
}


- (void)addConnectionLostReceiver:(id <MPDConnectionLostDelegate>)target
{
	[_connectionLostReceiverArray addObject:target];
}

- (void)removeConnectionLostReceiver:(id <MPDConnectionLostDelegate>)target
{
	[_connectionLostReceiverArray removeObject:target];
}

- (void)addStatusListener:(id <MPDStatusChangedDelegate>)target
{
	[_statusChangedListenerArray addObject:target];
}

- (void)removeStatusListener:(id <MPDStatusChangedDelegate>)target
{
	[_statusChangedListenerArray removeObject:target];
}

- (void)onUpdateTimer
{
	if(!_mpdObj)
		return;
	
	mpd_status_update(_mpdObj);
	
	if(mpd_check_connected(_mpdObj) != TRUE)
	{	
		int i=0;
		for(;i<[_connectionLostReceiverArray count];i++)
		{
			[(id <MPDConnectionLostDelegate>)[_connectionLostReceiverArray objectAtIndex:i] onConnectionLost];
		}
		
		[self removeTimer];
	}
}

- (void)removeTimer
{
	if(_updateTimer != nil)
	{
		[_updateTimer invalidate];
		[_updateTimer release];
	}
	
	_updateTimer = nil;
}

- (void)initTimer
{
	_updateTimer = 	[NSTimer	scheduledTimerWithTimeInterval:0.25 
								target:self
								selector:@selector(onUpdateTimer)
								userInfo: nil
								repeats:YES ];

	[_updateTimer retain];
}

- (BOOL)isConnected
{
	if(!_mpdObj)
		return NO;
		
	if(mpd_check_connected(_mpdObj) != TRUE)
		return NO;
	
	return YES;
}

- (BOOL)setPassword:(NSString*)password
{
	if(! [self isConnected] )
		return NO;
		
	if(mpd_set_password(_mpdObj, (char*)[password cStringUsingEncoding:NSUTF8StringEncoding]) != MPD_OK)
		return NO;
	
	return YES;
}

void _mpdErrorCallback(MpdObj *mi, int id, char *msg, void *userdata)
{
	NSString* errMsg = [NSString stringWithCString:msg encoding:NSUTF8StringEncoding];
	
	[(MPDConnection*)userdata onError:id withMsg:errMsg];
}

void _mpdStatusChangedCallback(MpdObj * mi, ChangedStatusType what, void *userdata)
{
	[(MPDConnection*)userdata onStatusChanged:what];
}

- (void)onError:(int)errorId withMsg:(NSString*)errorMsg
{
	NSLog(@"MPD Error occured: %i ( '%@' )", errorId, errorMsg);
}

- (void)onStatusChanged:(ChangedStatusType)what
{
	int i=0;
	
	for(i=0;i<[_statusChangedListenerArray count];i++)
	{
		[(id <MPDStatusChangedDelegate>)[_statusChangedListenerArray objectAtIndex:i] onStatusChanged:what];
	}
}

- (BOOL)commandAllowed:(NSString*)commandName
{
	if(! [self isConnected] )
		return NO;
		
	// Servers below 0,12,0 cannot return wich commands are allowed !
	if(! mpd_server_check_version( _mpdObj,
									0,
									12,
									0 ) )
		return YES;		

	return mpd_server_check_command_allowed(_mpdObj, [commandName cStringUsingEncoding:NSUTF8StringEncoding] ) == TRUE;
}

- (MPDConnectionResult)connectToHost:(NSString*)host
{
	return [self connectToHost:host withPort:6600];
}

- (MPDConnectionResult)connectToHost:(NSString*)host withPort:(int)port
{
	return [self connectToHost:host withPort:port withPassword:nil];
}

- (MPDConnectionResult)connectToHost:(NSString*)host withPort:(int)port withPassword:(NSString*)password
{
	[self removeTimer];
	
	if(_mpdObj != nil)
		mpd_free(_mpdObj);
	
	_mpdObj = nil;
	
	char* cPass = 0;
	
	if(password != nil)
		cPass = (char*)[password cStringUsingEncoding:NSUTF8StringEncoding];
	
	_mpdObj = mpd_new((char*)[host cStringUsingEncoding:NSUTF8StringEncoding], port, cPass);
	
	if(mpd_connect(_mpdObj) != MPD_OK)
	{
		return MPDConnectionFailed;
	}

	mpd_status_update(_mpdObj);

	mpd_signal_connect_error(_mpdObj, _mpdErrorCallback, (void*)self);
	mpd_signal_connect_status_changed(_mpdObj,_mpdStatusChangedCallback,(void*)self);

	[self initTimer];	

	if(! mpd_server_check_version( _mpdObj,
									0,
									12,
									0 ) )
		return MPDWrongServerVersion;
	
	return MPDOk;
}

- (void)disconnect
{
	if(_mpdObj)
	{
		mpd_disconnect(_mpdObj);
	}
}


- (MpdData *)mpdSearchTag: (mpd_TagItems)tag
                 forGenre: (NSString *)genre
                andArtist: (NSString *)artist
                 andAlbum: (NSString *)album
                  andSong: (NSString *)song
{
  mpd_database_search_field_start([self object], tag);
  addConstraints( self, genre, artist, album, song );
  return mpd_database_search_commit([self object]);
}

- (MpdData *)mpdSearchGenre: (NSString *)genre
                  andArtist: (NSString *)artist
                   andAlbum: (NSString *)album
                    andSong: (NSString *)song
{
  if( (genre == nil) && (artist == nil) && (album == nil) && (song == nil) )
    return mpd_database_get_complete([self object]);
  
  mpd_database_search_start([self object], TRUE);
  addConstraints( self, genre, artist, album, song );
  return mpd_database_search_commit([self object]);
}

- (MpdData *)mpdSearchNext: (MpdData *)data
{
  return mpd_data_get_next(data);
}

- (void)mpdSearchFree: (MpdData *)data
{
  mpd_data_free(data);
}

@end


NSString * str2nsstr( const char *str )
{
  return str ? [[NSString alloc] initWithCString: str encoding:NSUTF8StringEncoding] : @"";
}


void addConstraints( MPDConnection * mpdConnection, NSString *genre, NSString *artist, NSString *album, NSString *song )
{
  if( genre != nil )
  {
    const char *cGenre = [genre UTF8String];
    mpd_database_search_add_constraint([mpdConnection object], MPD_TAG_ITEM_GENRE, cGenre);
  }
  if( artist != nil )
  {
    const char *cArtist = [artist UTF8String];
    mpd_database_search_add_constraint([mpdConnection object], MPD_TAG_ITEM_ARTIST, cArtist);
  }
  if( album != nil )
  {
    const char *cAlbum = [album UTF8String];
    mpd_database_search_add_constraint([mpdConnection object], MPD_TAG_ITEM_ALBUM, cAlbum);
  }
  if( song != nil )
  {
    const char *cSong = [song UTF8String];
    mpd_database_search_add_constraint([mpdConnection object], MPD_TAG_ITEM_TITLE, cSong);
  }
}


