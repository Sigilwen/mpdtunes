//
//  MPDPlayerController.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//


#import "MPDPlayerController.h"
#import "MPDAlbumArtworkPreviewController.h"
#import "libmpd/libmpd.h"

@implementation MPDPlayerController

- (id) initWithScene: (id)scene
{
  if ( [super initWithScene: scene] == nil )
    return ( nil );
  
	_mpdConnection = nil;
  _visible = TRUE;
	
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

- (void) willBeBuried
{
  _visible = FALSE;
  [super willBeBuried];
}

- (void) willBeExhumed
{
  _visible = TRUE;
  [super willBeExhumed];
}

- (void) itemSelected: (long) row {}
- (void) itemPlay: (long) row {}
- (void) itemRemove: (long) row {}

- (BOOL) brEventAction:(BREvent *)event
{
  if(_visible)
  {
//printf("got event: 0x%08x 0x%08x %s\n", [event value], [self selectedObject], [[self listTitle] UTF8String]);
//printf("%s\n", [[BRBacktracingException backtrace] UTF8String]);
    BREventPageUsageHash hashVal = [event pageUsageHash];
    int selected = [(BRListControl*)[self list] selection];
    
    switch (hashVal)
    {
      case kBREventTapRight:           /* descend */
      case kBREventTapPlayPause:
        printf("descend\n");
        [self itemSelected:selected];
        return YES;
      case kBREventTapLeft:            /* ascend */
        printf("ascend\n");
        [[self stack]popController];
        return YES;
      case kBREventFastForward:        /* add to playlist */
        printf("add to playlist\n");
        [self itemPlay:selected];
        [[self stack] popToControllerWithLabel:@"com.apple.frontrow.appliance.axxr.mpdctrl.rootController"];
        return YES;
      case kBREventRewind:             /* remove from playlist */
        printf("remove from playlist\n");
        [self itemRemove:selected];
        [[self stack] popToControllerWithLabel:@"com.apple.frontrow.appliance.axxr.mpdctrl.rootController"];
        return YES;
        
    }
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



- (id<BRMediaPreviewController>) previewControllerForAlbum: (NSString *)album andArtist: (NSString *)artist
{
  return [[[MPDAlbumArtworkPreviewController alloc] initWithScene: [self scene] forAlbum:album andArtist:artist] autorelease];
}


@end
