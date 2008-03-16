//
//  MPDPlayerController.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDPlayerController.h"
#import "mpdctrlApplianceController.h"

#import "MADHorzLayout.h"

#import "MADListControlArtistSource.h"
#import "MADListControlAlbumSource.h"
#import "MADListControlSongSource.h"



#import "MADListControl.h"


@implementation MPDPlayerController

- (id)initWithScene:(id)scene
{
    if ( [super initWithScene: scene] == nil )
        return ( nil );

	_mpdConnection = nil;
	_currentSelectedArtist = 0;
	_currentSelectedAlbum = 0;
	

	////////////////////////////////////////////////////////////////////////////
	// Init Members

	_dataSrcArray = [[NSMutableArray alloc] init];
	_listCtrlArray = [[NSMutableArray alloc] init];
	_selectedSongIds = [[NSMutableArray alloc] init];

	// Create the List Sources
	id artistSrc = [[[MADListControlArtistSource alloc] initWithScene: [self scene]] autorelease];
	id albumSrc = [[[MADListControlAlbumSource alloc] initWithScene: [self scene]] autorelease];
	id songSrc = [[[MADListControlSongSource alloc] initWithScene: [self scene]] autorelease];
	
	[_dataSrcArray addObject:artistSrc];
	[_dataSrcArray addObject:albumSrc];
	[_dataSrcArray addObject:songSrc];
	
	// Create the list Controls
	id artistList =  [[[MADListControl alloc] initWithScene: [self scene]] autorelease];
	[artistList setDatasource: artistSrc];
	[artistList addDividerAtIndex:1];
	[_listCtrlArray addObject:artistList];
	
	id albumList =  [[[MADListControl alloc] initWithScene: [self scene]] autorelease];
	[albumList setDatasource: albumSrc];
	[albumList addDividerAtIndex:1];
	[_listCtrlArray addObject:albumList];
		
	id songList =  [[[MADListControl alloc] initWithScene: [self scene]] autorelease];
	[songList setDatasource: songSrc];
	[songList addDividerAtIndex:1];
	[_listCtrlArray addObject:songList];
	
	[artistList setPlayPauseTarget:self withSelector:@selector(onArtist)];
	[albumList setPlayPauseTarget:self withSelector:@selector(onAlbum)];
	[songList setPlayPauseTarget:self withSelector:@selector(onSong)];
	
	[self addControl: artistList leftCtrl:songList rightCtrl:albumList];
	[self addControl: albumList leftCtrl:artistList rightCtrl:songList];	
	[self addControl: songList leftCtrl:artistList rightCtrl:albumList];

	////////////////////////////////////////////////////////////////////////////
	// Create the UI

//	float pt41 = (41.0/720)*[scene size].height;

	// Resize font so it resizes with screenres
	float pt22 = (22.0/480)*[scene size].height;
//	float pt20 = (20.0/480)*[scene size].height;
//	float pt18 = (18.0/480)*[scene size].height;
//	float pt10 = (10.0/480)*[scene size].height;
	
	_layout = [[MADVertLayout createSafeLayout:scene] retain];
	
	
	MPDSmallTextControl* header = [[[MPDSmallTextControl alloc]initWithScene:scene withFontSize:pt22]autorelease];
	[header setText:@"Choose files to add to the playlist"];
	[self addControl:header];
	// Add the Header, centered on Top
	[_layout addObject:[MADHorzLayout createCenterLayout:header] withSizeFromObject:header];

	// Add Some space
	[_layout addObject:nil withSize:10];
	
	MADHorzLayout* artistAndAlbumLayout = [[[MADHorzLayout alloc]init]autorelease];

	[artistAndAlbumLayout addObject:artistList withConstraint:1.0];
	[artistAndAlbumLayout addObject:albumList withConstraint:1.0];

	[_layout addObject:artistAndAlbumLayout withConstraint:1.0];
	[_layout addObject:songList withConstraint:1.0];	
	
	[_layout doLayout];
	
	
	return ( self );
}

- (void)dealloc
{
	[_selectedSongIds release];
	[_layout release];
	[_header release];
	[_listCtrlArray release];
	[_dataSrcArray release];
	
    // always remember to deallocate your resources
    [super dealloc];
}

- (void) willBePushed
{
	int i=0;
	
	[_selectedSongIds removeAllObjects];
	
	for(i=0;i<[_dataSrcArray count];i++)
	{
		[[_dataSrcArray objectAtIndex:i] reset];
	}
	
	for(i=0;i<[_listCtrlArray count];i++)
	{
		[[_listCtrlArray objectAtIndex:i] reload];
	}	
	
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

	int i=0;
	
	for(i=0;i<[_dataSrcArray count];i++)
	{
		[[_dataSrcArray objectAtIndex:i] setMpdConnection:mpdConnection];
	}
}

- (void) onStatusChanged:(ChangedStatusType)what
{

}

- (void) onConnectionLost
{
	// Jump directly back to the root Controller
	[[self stack] popToControllerWithLabel:@"com.apple.frontrow.appliance.axxr.mpdctrl.rootController"];
}

- (void)onArtist
{
	MADListControl* list = [_listCtrlArray objectAtIndex:0];
	[list stopScrolling];
	int selected = [list selection];
	
	NSString * artist = nil;
									
	if(selected != 0)
		artist = [[_dataSrcArray objectAtIndex:0] titleForRow:selected];
		
	[[_dataSrcArray objectAtIndex:1] setArtist: artist];
	[[_dataSrcArray objectAtIndex:2] setArtist: artist];
	[[_dataSrcArray objectAtIndex:2] setAlbum: nil];
	
	_currentSelectedArtist = selected;
	
	[[_listCtrlArray objectAtIndex:1] reload];
	[[_listCtrlArray objectAtIndex:2] reload];

	[[_listCtrlArray objectAtIndex:1] setSelection:0];
	[[_listCtrlArray objectAtIndex:2] setSelection:0];
	
	[[self scene]renderScene];
}

- (void)onAlbum
{
	MADListControl* list = [_listCtrlArray objectAtIndex:1];
	[list stopScrolling];
	int selectedAlbum = [list selection];

	NSString * album = nil;
									
	if(selectedAlbum != 0)
		album = [[_dataSrcArray objectAtIndex:1] titleForRow:selectedAlbum];
	
	_currentSelectedAlbum = selectedAlbum; 
	
	[[_dataSrcArray objectAtIndex:2] setAlbum: album];
	
	[[_listCtrlArray objectAtIndex:2] reload];		
	[[_listCtrlArray objectAtIndex:2] setSelection:0];
	[[self scene]renderScene];
}

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

- (NSMutableArray*)getSelectedSongIds
{
	return _selectedSongIds;
}

- (BOOL)brEventAction:(BREvent *) brEvent
{	
	BOOL returnYes = NO;

	if(!returnYes)
		return [super brEventAction:brEvent];
		
	return returnYes;
}

@end
