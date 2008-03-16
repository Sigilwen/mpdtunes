//
//  MPDAddressEntryController.h
//  CustomControllerExample
//
//  Created by Alan Quatermain on 08/05/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BackRow/BRLayerController.h>
#import <BackRow/BRTextEntryDelegateProtocol.h>

@class BRRenderScene, BRControl, BRHeaderControl, BRTextEntryControl, BRButtonControl;
@protocol BRTextContainer;

@interface MPDAddressEntryController : BRLayerController <BRTextEntryDelegate>
{
    BRHeaderControl *       _header;
    BRTextEntryControl *    _entry;
	NSString*				_string;
}

- (id) initWithScene: (BRRenderScene *) scene ipOnly:(BOOL)ip;
- (void) dealloc;

- (void)setHeaderText:(NSString*)headerText;

- (NSString*)text;
- (void) textDidChange: (id<BRTextContainer>) sender;
- (void) textDidEndEditing: (id<BRTextContainer>) sender;

- (void) wasPushed;

@end
