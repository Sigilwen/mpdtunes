//
//  MPDAddressEntryController.m
//  CustomControllerExample
//
//  Created by Alan Quatermain on 08/05/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//

#import "MPDAddressEntryController.h"
#import <BackRow/BackRow.h>


@implementation MPDAddressEntryController

- (id) initWithScene: (BRRenderScene *) scene ipOnly:(BOOL)ip
{
    if ( [super initWithScene: scene] == nil )
        return ( nil );
		
	_string = nil;
	
	NSRect masterFrame = [[self masterLayer] frame];

    // Setup the Header Control with default contents
    _header = [[BRHeaderControl alloc] initWithScene: scene];
    [_header setTitle: @"Enter Server address:"];

    NSRect frame = masterFrame;
    frame.origin.y = frame.size.height * 0.82f;
    frame.size.height = [[BRThemeInfo sharedTheme] listIconHeight];
    [_header setFrame: frame];

    // setup the text entry control
	if(!ip)
	{
		_entry = [[BRTextEntryControl alloc] initWithScene: scene];
		[_entry setFrameFromScreenSize: masterFrame.size];
		[_entry setTextFieldLabel: @"New Title"];
		[_entry setInitialText: @""];
		[_entry setTextEntryCompleteDelegate: self];
    }
	else
	{
		NSRect frame = masterFrame;
		_entry = [[BRIPv4AddressEntryControl alloc] initWithScene: scene];
		
		frame.size = [((BRIPv4AddressEntryControl*)_entry) preferredSizeFromScreenSize:frame.size];
		
		frame.origin.x = (masterFrame.size.width - frame.size.width)/4;
		frame.origin.y = (masterFrame.size.height / 2) - (frame.size.height/2);
		
		[_entry setFrame:frame];
		
		[((BRIPv4AddressEntryControl*)_entry) setLabel:@"IP Address of Server"];
		[((BRIPv4AddressEntryControl*)_entry) setDelegate:self];
		
/*		NSHost* localHost = [NSHost currentHost];
		
		NSArray* localAdresses = [localHost addresses];
		
		int x = 0;
		
		NSString * firstIPv4Net = nil;
		
		for(x=0;x<[localAdresses count];x++)
		{
			NSString* str = [localAdresses objectAtIndex:x];
			
			if([str rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@":"]].location == NSNotFound)
			{
				NSCharacterSet* decimalSet = [NSCharacterSet decimalDigitCharacterSet];
				// This is not an ipv4 adress.
				if([str compare:@"127.0.0.1"] != NSOrderedSame &&
					[str rangeOfCharacterFromSet:[decimalSet invertedSet]].location == NSNotFound)
				{
					firstIPv4Net = str;
					break;
				}
			}
		}
		*/
	}	

    // add controls
    [self addControl: _header];
    [self addControl: _entry];

    return ( self );
}

- (void) dealloc
{
	if( [_entry isKindOfClass:[BRTextEntryControl class]] )
		[_entry setTextEntryCompleteDelegate: nil];
	else
		[((BRIPv4AddressEntryControl*)_entry) setDelegate:nil];
		
    [_header release];
    [_entry release];

    [super dealloc];
}

- (void)setHeaderText:(NSString*)headerText
{
    [_header setTitle:headerText];
}

- (void) textDidChange: (id<BRTextContainer>) sender
{
    // do nothing for now
}

- (void) textDidEndEditing: (id<BRTextContainer>) sender
{
	_string = [sender stringValue];
    [[self stack] popController];
}

- (void) wasPushed
{
    // We've just been put on screen, the user can see this controller's content now

	if([_entry respondsToSelector:@selector(setInitialText:)])
		[_entry setInitialText: @""];
	else
		[_entry reset];
		
	_string = nil;

    // always call super
    [super wasPushed];
}

- (NSString*)text
{
	return _string;
}


@end
