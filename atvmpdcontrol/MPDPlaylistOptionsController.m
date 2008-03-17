//
//  MPDPlaylistOptionsController.m
//  mpdctrl
//
//  Created by Marcus T on 7/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDPlaylistOptionsController.h"
#import "MPDPlayerRootController.h"
#import "MADFileItemLayer.h"
#import "MADVertLayout.h"

@implementation MPDPlaylistOptionsController

- (id) initWithScene:(BRRenderScene*)scene
{
	if( [super initWithScene:scene] == nil)
		return nil;

	float pt18 = (18.0/480)*[scene size].height;
	
	_mpdConnection = nil;
	
	[[self list]setDatasource:self];
	
    // we want to know when the list selection changes, so we can pass
    // that information on to the icon march layer
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(selectionChanged:)
                                                 name: @"ListControlSelectionChangedNotification"
                                               object: [self list]];	
	
	[self setListTitle:@"Edit Playlist"];
	
	_currentRootOption = -1;
	
	_currentPath = [[NSString stringWithString:@""]retain];
	
	
	[self createDescText];//[[BRParagraphTextControl alloc]initWithScene:scene];
	
	[self addControl:_descText];
	
	_layout = [[MADHorzLayout createSafeLayout:scene]retain];
	
	MADVertLayout* vertLayout = [[MADVertLayout alloc]init];
	
	[_layout addObject:vertLayout withConstraint:1.0];
	[_layout addObject:nil withConstraint:1.0];
	
	[vertLayout addObject:nil withConstraint:1.0];
	[vertLayout addObject:_descText];
	[vertLayout addObject:nil withConstraint:1.0];
																
	[_layout doLayout];
	
	_playerCtrl = [[MPDPlayerRootController alloc]initWithScene:scene];
	
	_textEntryController = [[MPDAddressEntryController alloc]initWithScene:scene ipOnly:NO];
	[_textEntryController setHeaderText:@"Enter playlist name:"];
	
	return (self);
}

- (void) createDescText
{
	_descText = [[BRTextControl alloc]initWithScene:[self scene]];

	// Create a new target Dictionay
	NSMutableDictionary * mutDict = [[[NSMutableDictionary alloc] init] autorelease];
	
	// Get the old attribtes
	NSDictionary *orgAttr = [_descText textAttributes];
	// Copy the old attributes to the new Dictionary
//	[mutDict setDictionary:orgAttr];
	// Create a new font
	NSFont *newFont = [NSFont boldSystemFontOfSize:18.0];//[NSFont fontWithName:@"Helvetica" size:20.0];
	// Set the new font
	[mutDict setValue:newFont forKey:NSFontAttributeName];
	
	float floatComps[4];
	floatComps[0] = 1.0;
	floatComps[1] = 1.0;
	floatComps[2] = 1.0;
	floatComps[3] = 1.0;

	
	CGColorRef newColor = CGColorCreate (CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB), floatComps);

	[mutDict setValue:newColor forKey:NSForegroundColorAttributeName];	
		
	[mutDict setValue:[NSNumber numberWithInt:4] forKey:@"CTTextAlignment"];
	
	// Set the new Attributes
	[_descText setTextAttributes: mutDict ];

	[_descText setMaxLines:20];

//	[[_descText layer] setColorText:YES];

	[_descText setText:@""];
}

- (void) dealloc
{
	[_textEntryController release];
	[_playerCtrl release];
	[_layout release];
	[_descText release];
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[_currentPath release];
	[super dealloc];
}

- (int)selectedRootOption
{
	return _currentRootOption;
}

- (void)setDescription:(NSString*)description
{
	if(description == nil)
		[_descText setText:@""];
	else
		[_descText setText:description];
	
	[[self scene]renderScene];
	[_layout doLayout];
}

- (void)setMpdConnection:(MPDConnection*)mpdConnection; 
{
	_mpdConnection = mpdConnection;
	
	[_playerCtrl setMpdConnection:mpdConnection];
}

- (void) onStatusChanged:(ChangedStatusType)what
{

}

- (void) onConnectionLost
{
	// Jump directly back to the root Controller
	[[self stack] popToControllerWithLabel:@"com.apple.frontrow.appliance.axxr.mpdctrl.rootController"];
}

- (id<BRMenuItemLayer>)createFileItemWithPath:(NSString*)path
{
	id item = [[MADFileItemLayer alloc]initWithScene:[self scene] withPath:[path lastPathComponent] withType:1];
	[item setArrowDisabled:YES];
	return [item autorelease];
}

- (id<BRMenuItemLayer>)createFolderItemWithPath:(NSString*)path
{
	id item = [[MADFileItemLayer alloc]initWithScene:[self scene] withPath:[path lastPathComponent] withType:0];
	
	return [item autorelease];
} 

- (id<BRMenuItemLayer>)createFolderItemWithText:(NSString*)text
{
	id item = [self createItemWithText:text];
	[item setArrowDisabled:NO];	
	
	return item;
} 

- (id<BRMenuItemLayer>)createItemWithText:(NSString*)text
{
	return [self createItemWithText:text rightJustifiedText:nil];
}

- (id<BRMenuItemLayer>)createItemWithText:(NSString*)text rightJustifiedText:(NSString*)rText
{
	BRTextMenuItemLayer* item = [[BRTextMenuItemLayer alloc] initWithScene: _scene];
	
	if(rText != nil)
		[item setRightJustifiedText:rText];
	
	[item setTitle: text centered:NO];
	[item setArrowDisabled:YES];
	
	return [item autorelease];
}

- (long) itemCount
{
	if(_currentRootOption == 0 || _currentRootOption == 2)
		return [_itemArray count];
		
	return 5;
}

- (id<BRMenuItemLayer>) itemForRow: (long) row
{	
	if(_currentRootOption == -1)
	{
		if(row == 0)
			return [self createFolderItemWithText:@"Add songs by filename"];
		else if(row == 1)
			return [self createFolderItemWithText:@"Add songs by Tag"];
		else if(row == 2)
			return [self createFolderItemWithText:@"Load Playlist"];
		else if(row == 3)
			return [self createFolderItemWithText:@"Save Playlist"];
		else if(row == 4)
			return [self createFolderItemWithText:@"Clear Playlist"];
	}
	else if(_currentRootOption == 0)
	{
		return [_itemArray objectAtIndex:row];
	}
	else if(_currentRootOption == 2)
		return [_itemArray objectAtIndex:row];
	return nil;
}

- (void)dirItemsFromPath:(NSString*)path
{
	[_itemArray release];
	_itemArray = [[NSMutableArray alloc]init];
	
	MpdData* pData = 0;
	
	for(pData = mpd_database_get_directory([_mpdConnection object], (char*)[_currentPath cStringUsingEncoding:NSUTF8StringEncoding] );
		pData != NULL; 
		pData = mpd_data_get_next(pData) )
    {
		if(_currentRootOption == 0)
		{
			if(pData->type == MPD_DATA_TYPE_DIRECTORY)
			{
				[_itemArray addObject:[self createFolderItemWithPath:[NSString stringWithCString:pData->directory encoding:NSUTF8StringEncoding]]];
			}
			else if(pData->type == MPD_DATA_TYPE_SONG)
			{
				[_itemArray addObject:[self createFileItemWithPath:[NSString stringWithCString:pData->song->file encoding:NSUTF8StringEncoding]]];
			}
		}
		else if(_currentRootOption == 2)
		{
			if(pData->type == MPD_DATA_TYPE_PLAYLIST)
			{
				[_itemArray addObject:[self createFileItemWithPath:[NSString stringWithCString:pData->playlist encoding:NSUTF8StringEncoding]]];
			}
		}
	}	
}

- (BOOL)brEventAction:(BREvent *) brEvent
{
	BREventPageUsageHash hash = [brEvent pageUsageHash];
	BOOL returnYES = NO;
	
	if(_currentRootOption == -1)
	{
		int selected = [(BRListControl*)[self list] selection];
			
		if([brEvent value] == 1)
		{			
			
			if(selected == 0 && hash == kBREventTapPlayPause )
			{
				_currentRootOption = 0;
				[self dirItemsFromPath:_currentPath];
				[[self list] reload];
				[self setListTitle:@"/"];
				[[self scene] renderScene];
				returnYES = YES;
			}
			else if(selected == 1 && hash == kBREventTapPlayPause)
			{
				[[self stack] pushController:_playerCtrl];
				returnYES = YES;
			}
			else if(selected == 2 && hash == kBREventTapPlayPause)
			{
				_currentRootOption = 2;
				[self dirItemsFromPath:_currentPath];
				[[self list] reload];
				[[self scene] renderScene];
				returnYES = YES;
			}
			else if(selected == 3 && hash == kBREventTapPlayPause)
			{
				[[self stack] pushController:_textEntryController];
				
				
				
				//mpd_database_save_playlist([_mpdConnection object], "testPlaylist");
				//[[self stack]popController];
				returnYES = YES;
			}
			else if(selected == 4 && hash == kBREventTapPlayPause)
			{
				if( hash == kBREventTapPlayPause )
				{
					[self clearPlaylist];
					[[self stack]popController];
					returnYES = YES;
				}
			}		
		}
	}
	else if(_currentRootOption == 2)
	{
		if([brEvent value] == 1)
		{			
			int selected = [(BRListControl*)[self list] selection];
			
			if(hash == kBREventTapPlayPause)
			{
				id item = [_itemArray objectAtIndex:selected];
								
				mpd_playlist_queue_load([_mpdConnection object], [[item fileName] cStringUsingEncoding:NSUTF8StringEncoding]);
				mpd_playlist_queue_commit([_mpdConnection object]);
				[[self stack]popController];
				returnYES = YES;
			}
			else if(hash == kBREventTapMenu)
			{
				_currentRootOption = -1;
				[[self list] reload];
				[[self scene] renderScene];
				returnYES = YES;				
			}
		}
	}
	else if(_currentRootOption == 0)
	{
		if([brEvent value] == 1)
		{			
			int selected = [(BRListControl*)[self list] selection];
			
			if(hash == kBREventTapRight)
			{
				id item = [_itemArray objectAtIndex:selected];
				
				if([item type] == 0)
				{
					NSString* filePath = [_currentPath stringByAppendingPathComponent:[item fileName]];
					
					mpd_playlist_add([_mpdConnection object],(char*)[filePath cStringUsingEncoding:NSUTF8StringEncoding]);
					returnYES = YES;					
				}
			}
			else if(hash == kBREventTapPlayPause)
			{
				id item = [_itemArray objectAtIndex:selected];
				
				if([item type] == 0)
				{
					[_currentPath autorelease];
					_currentPath = [[_currentPath stringByAppendingPathComponent:[item fileName]] retain];
					
					[self setListTitle:[@"/" stringByAppendingString:_currentPath]];
					
					[self dirItemsFromPath:_currentPath];
					[[self list] reload];
					[[self scene] renderScene];
					returnYES = YES;
				}
				else if((int)[item type] == 1)
				{
					NSString* filePath = [_currentPath stringByAppendingPathComponent:[item fileName]];
					
					mpd_playlist_add([_mpdConnection object],(char*)[filePath cStringUsingEncoding:NSUTF8StringEncoding]);
					returnYES = YES;
				}
			}
			if(hash == kBREventTapMenu)
			{
				if([_currentPath length] != 0)
				{
					[_currentPath autorelease];
					_currentPath = [[_currentPath stringByDeletingLastPathComponent] retain];
					[self setListTitle:[@"/" stringByAppendingString:_currentPath]];					
					[self dirItemsFromPath:_currentPath];
					[[self list] reload];
					[[self scene] renderScene];
					returnYES = YES;
				}
				else
				{
					[self setListTitle:@"Edit Playlist"];
				
					_currentRootOption = -1;
					[[self list] reload];
					[[self scene] renderScene];
					returnYES = YES;
				}
			}
		}	
	}
	
	if(returnYES)
	{
		return YES;
	}	
	return [super brEventAction:brEvent];
}

- (void) selectionChanged: (NSNotification *) note
{
    int selected = [[note object] renderSelection];
	
	NSString* newdesc = nil;

	if(_currentRootOption == -1)
	{
		if(selected == 0)
			newdesc = @"Add songs by their path and filename.\nOpens a recursive view of the media directory of the server";
		else if(selected == 1)
			newdesc = @"Add songs based on their Informations (like Artist, Album and title of the Song)";
		else if(selected == 2)
			newdesc = @"Add songs from a stored Playlist to the current Playlist";
		else if(selected == 3)
			newdesc = @"Save the current Playlist";
		else if(selected == 4)
			newdesc = @"Clear the current playlist";
	}
	if(_currentRootOption == 0)
	{
		if( [[_itemArray objectAtIndex:[[note object] renderSelection] ] type ] == 0)
		{
			newdesc = @"Press play/pause to enter directory.\nPress 'right' to add the directory to the playlist.";
		}
		else
			newdesc = @"Press play/pause to add the file to the playlist.";
	}

	[self setDescription:newdesc];
}

- (NSString *) titleForRow: (long) row
{
	return nil;
}

- (long) rowForTitle: (NSString *) title
{
	return -1;
}

- (void) willBePushed
{
	[_mpdConnection addConnectionLostReceiver:self];
	[_mpdConnection addStatusListener:self];
	_currentRootOption = -1;

	
	[[self list]reload];
	
	[super willBePushed];
}

- (void) willBePopped
{	
	[_mpdConnection removeConnectionLostReceiver:self];
	[_mpdConnection removeStatusListener:self];
	
	
	[super willBePopped];
}

- (void) wasExhumedByPoppingController: (BRLayerController *) controller
{
	[super wasExhumedByPoppingController: controller];

	if(controller == _textEntryController)
	{
		if([_textEntryController text ] != nil)
		{
			mpd_database_save_playlist([_mpdConnection object], [[_textEntryController text ] cStringUsingEncoding:NSUTF8StringEncoding]);
			[self setDescription:[NSString stringWithFormat:@"Playlist saved as \"%@\"", [_textEntryController text ]]];
		}
	}
}

- (void)clearPlaylist
{
	mpd_playlist_clear([_mpdConnection object]);
}

@end
