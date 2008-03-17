//
//  MPDPlayerController.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDPlayerController.h"
#import "mpdctrlApplianceController.h"


@implementation MPDPlayerController

- (id) initWithScene: (id)scene
{
  if ( [super initWithScene: scene] == nil )
    return ( nil );

	_mpdConnection = nil;
	
	return ( self );
}

- (void) dealloc
{
  [_names release];
  [super dealloc];
}

- (long) itemCount
{
  return [_names count];
}

- (id) itemForRow: (long) row
{
  return nil;
}

- (NSString *) titleForRow: (long) row
{
  if( row > [_names count] )
    return nil;
  return [_names objectAtIndex: row];
}

- (long) rowForTitle: (NSString *) title
{
  long result = -1;
  
  long i, count = [self itemCount];
  for( i=0; i<count; i++ )
  {
    if ( [[self titleForRow: i] isEqualToString: title] )
    {
      result = i;
      break;
    }
  }
  
  return result;
}

- (void) itemSelected: (long) row {}
- (void) itemPlay: (long) row {}

- (BOOL) brEventAction:(BREvent *)event
{
	BREventPageUsageHash hashVal = [event pageUsageHash];
	int selected = [(BRListControl*)[self list] selection];
  
	switch (hashVal)
	{
		case kBREventTapRight:
      [self itemSelected:selected];
      return YES;
    case kBREventTapPlayPause:
      [self itemPlay:selected];
      return YES;
	}
	return [super brEventAction:event];
}

- (void) willBePushed
{
	[_mpdConnection addConnectionLostReceiver:self];
	
	[super willBePushed];
}

- (void) willBePopped
{	
	[_mpdConnection removeConnectionLostReceiver:self];
	
	[super willBePopped];
}

- (void)setMpdConnection:(MPDConnection*)mpdConnection; 
{
	_mpdConnection = mpdConnection;
}

- (void) onStatusChanged:(ChangedStatusType)what
{

}

- (void) onConnectionLost
{
	// Jump directly back to the root Controller
	[[self stack] popToControllerWithLabel:@"com.apple.frontrow.appliance.axxr.mpdctrl.rootController"];
}


- (void) addToPlaylist: (MPDConnection *)mpdConnection
    genre: (NSString *)genre
    artist: (NSString *)artist
    album: (NSString *)album
    song: (NSString *)song
{
  printf("addToPlaylist: genre=%s artist=%s album=%s song=%s\n", genre, artist, album, song);
}


@end
