//
//  MADGLLayer.h
//  mpdctrl
//
//  Created by Marcus T on 6/17/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface MADGLLayer : BRRenderLayer {
	double _timeFreq; 
	double _prevTime;
	
	float _rot;
	
	BOOL _dirR;
	BOOL _dirG;
	BOOL _dirB;
	
	float _r;
	float _g;
	float _b;
}

- (id)initWithScene:(BRRenderScene*)scene;
- (void)dealloc;

- (void)renderQuad;

- (BOOL) updateFrameForTime: (const CVTimeStamp *) timeStamp;
- (void)renderLayer;


@end
