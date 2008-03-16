//
//  MPDServerController.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 03.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MPDServerController.h"

#import "MADVertLayout.h"
#import "MADHorzLayout.h"


@implementation MPDServerController

- (id)initWithScene:(id)scene;
{
    if ( [super initWithScene: scene] == nil )
        return ( nil );

	_textEntryController = nil;
		
	MADVertLayout * layout = [MADVertLayout createSafeLayout:scene];

	// Add Header
	BRHeaderControl * header = [[[BRHeaderControl alloc] initWithScene: [self scene] ] autorelease];
	[header setTitle:@"Choose or add Server"];
	[layout addObject:header withSize:[[BRThemeInfo sharedTheme] listIconHeight] ];

	_serverListCtrl = [[MADAdvancedListControl alloc]initWithScene: [self scene] ];
	_serverListSource = [[MPDListControlServerSource alloc]
								initWithScene: [self scene] ];
								
	[_serverListCtrl setDatasource: _serverListSource];
	[_serverListCtrl addDividerAtIndex:2];
	[_serverListCtrl setTarget:self];
	
	int defServer = [_serverListSource defaultServer];
	
	if(defServer != -1)
		[_serverListCtrl setRenderSelection:defServer+1];
	
	
	MADHorzLayout * listLayout = [[[MADHorzLayout alloc] init] autorelease];
	
	
	[listLayout addObject:nil withConstraint:0.5];
	[listLayout addObject:_serverListCtrl withConstraint:1.0];
	[listLayout addObject:nil withConstraint:0.5];
	
	[layout addObject:listLayout withConstraint:1.0];
	
/*	NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	NSString *compositionPath = [thisBundle pathForResource:@"testcomp" ofType:@"qtz"];
	
	BRQuartzComposerControl* qControl = [[[BRQuartzComposerControl alloc] initWithScene:scene ]autorelease];
	[qControl setCompositionPath:compositionPath];
	[self addControl:qControl];
	[layout addObject:qControl withConstraint:0.5];
	
	NSSize size;
	size.width = masterFrame.size.width;
	size.height = 500;
		
	NSRect oldQuartzFrame = [qControl frame];
	oldQuartzFrame.size.width = 200;
	oldQuartzFrame.size.height=200;
	[qControl setFrame:oldQuartzFrame];
	[qControl startAnimation];
	[qControl setValue:@"0.5" forInputKey:@"Alpha"];
	*/
	
	[layout doLayout];
	
	[self addControl: header];
	[self addControl: _serverListCtrl];
	
	_selectedHost = nil;
	_selectedPort = 6600;
	_selectedPassword = nil;
	
	return ( self );
}

-(void)dealloc
{
	[_serverListSource release];
	[_textEntryController release];
	[_servers release];
	[super dealloc];
}

- (void)onKeyPressed:(BREventPageUsageHash)hash selectedItem:(int)selected
{
  if( selected >= [[_serverListSource getArray] count] )
    selected = [[_serverListSource getArray] count] - 1;
	if(selected == 0 && hash == kBREventTapPlayPause)
	{
		[_textEntryController release];
		_textEntryController = [[MPDAddressEntryController alloc] initWithScene: [self scene] ipOnly:NO];
		[[self stack]pushController:_textEntryController];
	}
	else if(selected == 1 && hash == kBREventTapPlayPause)
	{
		[_textEntryController release];
		_textEntryController = [[MPDAddressEntryController alloc] initWithScene: [self scene] ipOnly:YES];
		[[self stack]pushController:_textEntryController];
	}
	else if(hash == kBREventTapPlayPause)
	{
		_selectedHost = [[_serverListSource getArray] objectAtIndex:selected];
		
		[_serverListSource setDefaultServer:selected];
		
		// TODO: SelectedPort and password !
	}	
	if(selected > 0 && hash == kBREventTapLeft)
	{
		[[_serverListSource getArray] removeObjectAtIndex:selected];
		[_serverListCtrl reload];
		[_serverListSource store];	
		[[self scene] renderScene];	
	}
}

- (BOOL)brEventAction:(BREvent*) brEvent
{
	return [super brEventAction:brEvent];
}

- (void) wasPushed
{
	_selectedHost = nil;
	_selectedPort = 6600;
	_selectedPassword = nil;
	
	[super wasPushed];
}

- (void) wasExhumedByPoppingController: (BRLayerController *) controller
{
	[super wasExhumedByPoppingController: controller];

	if(controller == _textEntryController)
	{
		if([_textEntryController text ] != nil)
		{
			[[_serverListSource getArray] addObject: [_textEntryController text ]];
			[_serverListCtrl reload];
			[_serverListSource store];
			[[self scene] renderScene];
		}
	}
}

@end
