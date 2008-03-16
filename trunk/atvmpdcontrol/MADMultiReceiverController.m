//
//  MADMultiReceiverController.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 07.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADMultiReceiverController.h"
#import "MADAlphaFriendlyRenderLayer.h"
#import "MADDeactivateableControl.h"

@implementation MADMultiReceiverController

- (id)initWithScene:(id)scene
{
    if ( [super initWithScene: scene] == nil )
        return ( nil );
	
	_deactivObjects = [[MADObjectDictionary alloc]init];
	
	return ( self );
}

- (void)dealloc
{
	[_deactivObjects release];
    // always remember to deallocate your resources
    [super dealloc];
}

- (MADDeactivateableControl*)getDeactCtrlForControl:(BRControl*) ctrl
{
	if(ctrl == nil)
		return nil;
		
	MADDeactivateableControl* deactCtrl = [_deactivObjects objectForKey:ctrl];
	
	if(deactCtrl == nil)
	{
		deactCtrl = [[[MADDeactivateableControl alloc] initWithControl:ctrl deactivated:[_deactivObjects count ] > 0 ] autorelease];
		[_deactivObjects setObject:deactCtrl forKey:ctrl];
	}
		
	return deactCtrl;
}

- (void)addControl:(BRControl <MADEventForwarder>*)ctrl leftCtrl:(BRControl <MADEventForwarder>*)leftCtrl rightCtrl:(BRControl <MADEventForwarder>*)rightCtrl
{
	[self addControl:ctrl];
	
	MADDeactivateableControl * deact = [self getDeactCtrlForControl:ctrl];
	[deact setLeftCtrl:[self getDeactCtrlForControl:leftCtrl]];
	[deact setRightCtrl:[self getDeactCtrlForControl:rightCtrl]];

	[(MADAlphaFriendlyRenderLayer*)_master addDeactivatable:deact];
}

- (void)addControl:(BRControl <MADEventForwarder>*)ctrl topCtrl:(BRControl <MADEventForwarder>*)topCtrl bottomCtrl:(BRControl <MADEventForwarder>*)bottomCtrl
{
	[self addControl:ctrl];

	MADDeactivateableControl * deact = [self getDeactCtrlForControl:ctrl];
	[deact setTopCtrl:[self getDeactCtrlForControl:topCtrl]];
	[deact setBottomCtrl:[self getDeactCtrlForControl:bottomCtrl]];

	[(MADAlphaFriendlyRenderLayer*)_master addDeactivatable:deact];
}

- (id)masterLayer
{
	if(_master == nil)
	{
		_master = [[MADAlphaFriendlyRenderLayer alloc] initWithScene:[self scene]];
		[_master setFrame: [self masterLayerFrame]];
	}
	
	return _master;
}



@end
