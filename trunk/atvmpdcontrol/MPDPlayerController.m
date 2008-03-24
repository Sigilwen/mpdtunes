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


- (void) addToPlaylistGenre: (NSString *)genre
                  andArtist: (NSString *)artist
                   andAlbum: (NSString *)album
                    andSong: (NSString *)song
{
  MpdData *data;
  
  for( data = [_mpdConnection mpdSearchGenre:genre andArtist:artist andAlbum:album andSong:song];
       data != NULL;
       data = [_mpdConnection mpdSearchNext: data] )
  {
    if( data->type == MPD_DATA_TYPE_SONG )
    {
      printf("mpd_playlist_queue_add(%s)\n", data->song->file);
      mpd_playlist_queue_add([_mpdConnection object], data->song->file);
    }
  }
  // last mpdSearchNext: free's the search
  printf("mpd_playlist_queue_commit()\n");
  mpd_playlist_queue_commit([_mpdConnection object]);
}



- (id<BRMediaPreviewController>) previewControllerForArtist: (NSString *)artist andAlbum: (NSString *)album andSong:(NSString *)song;
{
  MpdData *data;
  
  if( album == nil )
  {
    for( data = [_mpdConnection mpdSearchTag:MPD_TAG_ITEM_ALBUM forGenre:nil andArtist:artist andAlbum:album andSong:nil];
         data != NULL;
         data = [_mpdConnection mpdSearchNext: data] )
    {
      if( data->type == MPD_DATA_TYPE_TAG )
      {
        album = str2nsstr(data->tag);
        [_mpdConnection mpdSearchFree:data];
        break;
      }
    }
  }
  else if( artist == nil )
  {
    for( data = [_mpdConnection mpdSearchTag:MPD_TAG_ITEM_ARTIST forGenre:nil andArtist:artist andAlbum:album andSong:nil];
         data != NULL;
         data = [_mpdConnection mpdSearchNext: data] )
    {
      if( data->type == MPD_DATA_TYPE_TAG )
      {
        artist = str2nsstr(data->tag);
        [_mpdConnection mpdSearchFree:data];
        break;
      }
    }
  }
  return [[[MPDAlbumArtworkPreviewController alloc] initWithScene: [self scene] forArtist:artist andAlbum:album andSong:song] autorelease];
}

@end
