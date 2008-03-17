//
//  MPDPlayerController.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDPlayerController.h"
#import "mpdctrlApplianceController.h"
#import "libmpd/libmpd.h"


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
  MpdData *data;
  const char *cGenre;
  const char *cArtist;
  const char *cAlbum;
  const char *cSong;
  
  mpd_database_search_start([mpdConnection object], TRUE);
  if( genre != NULL )
  {
    cGenre = [genre UTF8String];
    mpd_database_search_add_constraint([mpdConnection object], MPD_TAG_ITEM_GENRE, cGenre);
  }
  if( artist != NULL )
  {
    cArtist = [artist UTF8String];
    mpd_database_search_add_constraint([mpdConnection object], MPD_TAG_ITEM_ARTIST, cArtist);
  }
  if( album != NULL )
  {
    cAlbum = [album UTF8String];
    mpd_database_search_add_constraint([mpdConnection object], MPD_TAG_ITEM_ALBUM, cAlbum);
  }
  if( song != NULL )
  {
    cSong = [song UTF8String];
    mpd_database_search_add_constraint([mpdConnection object], MPD_TAG_ITEM_TITLE, cSong);
  }
  for( data = mpd_database_search_commit([mpdConnection object]);
      data != NULL;
      data = mpd_data_get_next(data) )
  {
    if( data->type == MPD_DATA_TYPE_SONG )
    {
      printf("mpd_playlist_queue_add(%s)\n", data->song->file);
      mpd_playlist_queue_add([mpdConnection object], data->song->file);
    }
  }
  // last mpd_data_get_next() free's the search
  printf("mpd_playlist_queue_commit()\n");
  mpd_playlist_queue_commit([mpdConnection object]);
}

/*
 [_currentSongIds addObject: [NSString stringWithCString:pData->song->file encoding:NSUTF8StringEncoding] ];
- (void)onSong
{
        int i;
        MADListControl* list = [_listCtrlArray objectAtIndex:2];
        [list stopScrolling];
        int selectedSong = [list selection];
        
        if(selectedSong == 0)
        {
                [_selectedSongIds addObjectsFromArray: [[_dataSrcArray objectAtIndex:2] getCurrentSongIds ] ];
        }
        else
        {
                NSMutableArray* songIds = [[_dataSrcArray objectAtIndex:2] getCurrentSongIds ];
                [_selectedSongIds addObject:[songIds objectAtIndex:selectedSong-1 ] ];
        }
        
        for(i=0;i<[_selectedSongIds count];i++)
        {
                NSString * sFile = [_selectedSongIds objectAtIndex:i];
                mpd_playlist_queue_add([_mpdConnection object],(char*)[sFile cStringUsingEncoding:NSUTF8StringEncoding]);
        }
        
        mpd_playlist_queue_commit([_mpdConnection object]);
                
        [[self stack]popController];
}
*/

@end
