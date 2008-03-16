//
//  MADGLLayer.m
//  mpdctrl
//
//  Created by Marcus T on 6/17/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADGLLayer.h"
#import <QuartzCore/CVBase.h>

@implementation MADGLLayer

- (id)initWithScene:(BRRenderScene*)scene
{
	if( [super initWithScene:scene] == nil )
		return nil;
		
	_timeFreq = 1000000000; //CVGetHostClockFrequency( );
	
	srand([[NSDate date] timeIntervalSince1970]);
	
	_rot = 0.0;
	
	_r = 0.0;
	_g = 0.5;
	_b = 1.0;
	
	_dirR = NO;
	_dirG = NO;
	_dirB = NO;
	
	[self setNeedsUpdates: YES];	
		
	return (self);
}

- (void)dealloc
{
	[super dealloc];
}

- (BOOL) updateFrameForTime: (const CVTimeStamp *) time
{
    BOOL result = NO;
	 
	@synchronized(self) 
	{ 
		double curTime = ((double) time->hostTime) / _timeFreq; 
		if ( curTime >= (_prevTime + (1.0/30.0)) ) 
		{ 
			_prevTime = curTime; 
					
			result = YES; 
		} 
	} 
 
	return ( result ); 
}


- (void)renderQuad
{
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	
	glBegin(GL_QUADS);							// Start Drawing Quads
		// Bottom Face

		if(_dirR)
			_r = _r + (rand()%1000)/800000.0;
		else
			_r = _r - (rand()%1000)/800000.0;
		
		if(_r > 1.0)
			_dirR = NO;
		else if(_r < 0.0)
			_dirR = YES;
			

		if(_dirG)
			_g = _g + (rand()%1000)/800000.0;
		else
			_g = _g - (rand()%1000)/800000.0;
		
		if(_g > 1.0)
			_dirG = NO;
		else if(_g < 0.0)
			_dirG = YES;

		if(_dirB)
			_b = _b + (rand()%1000)/800000.0;
		else
			_b = _b - (rand()%1000)/800000.0;
		
		if(_b > 1.0)
			_dirB = NO;
		else if(_b < 0.0)
			_dirB = YES;
		
		glColor4f(_r,_g,_b,[self alphaValue]);
		glTexCoord2f(1.0f, 1.0f); glVertex3f(-1.0f, -1.0f, -1.0f);	// Top Right Of The Texture and Quad
		glTexCoord2f(0.0f, 1.0f); glVertex3f( 1.0f, -1.0f, -1.0f);	// Top Left Of The Texture and Quad
		glTexCoord2f(0.0f, 0.0f); glVertex3f( 1.0f, -1.0f,  1.0f);	// Bottom Left Of The Texture and Quad
		glTexCoord2f(1.0f, 0.0f); glVertex3f(-1.0f, -1.0f,  1.0f);	// Bottom Right Of The Texture and Quad
		// Top Face
//		glColor4f(1.0, 0.0, 0.0, [self alphaValue]);
		glTexCoord2f(1.0f, 1.0f); glVertex3f(-1.0f, 1.0f, -1.0f);	// Top Right Of The Texture and Quad
		glTexCoord2f(0.0f, 1.0f); glVertex3f( 1.0f, 1.0f, -1.0f);	// Top Left Of The Texture and Quad
		glTexCoord2f(0.0f, 0.0f); glVertex3f( 1.0f, 1.0f,  1.0f);	// Bottom Left Of The Texture and Quad
		glTexCoord2f(1.0f, 0.0f); glVertex3f(-1.0f, 1.0f,  1.0f);	// Bottom Right Of The Texture and Quad
		// Front Face
//		glColor4f(0.0, 1.0, 0.0, [self alphaValue]);
		glTexCoord2f(0.0f, 0.0f); glVertex3f(-1.0f, -1.0f,  1.0f);	// Bottom Left Of The Texture and Quad
		glTexCoord2f(1.0f, 0.0f); glVertex3f( 1.0f, -1.0f,  1.0f);	// Bottom Right Of The Texture and Quad
		glTexCoord2f(1.0f, 1.0f); glVertex3f( 1.0f,  1.0f,  1.0f);	// Top Right Of The Texture and Quad
		glTexCoord2f(0.0f, 1.0f); glVertex3f(-1.0f,  1.0f,  1.0f);	// Top Left Of The Texture and Quad
		// Back Face
//		glColor4f(0.0, 0.0, 1.0, [self alphaValue]);
		glTexCoord2f(1.0f, 0.0f); glVertex3f(-1.0f, -1.0f, -1.0f);	// Bottom Right Of The Texture and Quad
		glTexCoord2f(1.0f, 1.0f); glVertex3f(-1.0f,  1.0f, -1.0f);	// Top Right Of The Texture and Quad
		glTexCoord2f(0.0f, 1.0f); glVertex3f( 1.0f,  1.0f, -1.0f);	// Top Left Of The Texture and Quad
		glTexCoord2f(0.0f, 0.0f); glVertex3f( 1.0f, -1.0f, -1.0f);	// Bottom Left Of The Texture and Quad
		// Right face
//		glColor4f(1.0, 1.0, 0.0, [self alphaValue]);
		glTexCoord2f(1.0f, 0.0f); glVertex3f( 1.0f, -1.0f, -1.0f);	// Bottom Right Of The Texture and Quad
		glTexCoord2f(1.0f, 1.0f); glVertex3f( 1.0f,  1.0f, -1.0f);	// Top Right Of The Texture and Quad
		glTexCoord2f(0.0f, 1.0f); glVertex3f( 1.0f,  1.0f,  1.0f);	// Top Left Of The Texture and Quad
		glTexCoord2f(0.0f, 0.0f); glVertex3f( 1.0f, -1.0f,  1.0f);	// Bottom Left Of The Texture and Quad
		// Left Face
//		glColor4f(0.0, 0.5, 1.0, [self alphaValue]);
		glTexCoord2f(0.0f, 0.0f); glVertex3f(-1.0f, -1.0f, -1.0f);	// Bottom Left Of The Texture and Quad
		glTexCoord2f(1.0f, 0.0f); glVertex3f(-1.0f, -1.0f,  1.0f);	// Bottom Right Of The Texture and Quad
		glTexCoord2f(1.0f, 1.0f); glVertex3f(-1.0f,  1.0f,  1.0f);	// Top Right Of The Texture and Quad
		glTexCoord2f(0.0f, 1.0f); glVertex3f(-1.0f,  1.0f, -1.0f);	// Top Left Of The Texture and Quad
	glEnd();	
}

- (void)renderLayer
{
	int oldMatMode;
	glGetIntegerv(GL_MATRIX_MODE, &oldMatMode);

	glPushAttrib(GL_ALL_ATTRIB_BITS);

	glViewport(_frame.origin.x, _frame.origin.y,_frame.size.width,_frame.size.height);

	glEnable(GL_DEPTH_TEST);
	glDisable(GL_CULL_FACE);

	glMatrixMode(GL_PROJECTION);
	glPushMatrix();	
	glLoadIdentity();
	gluPerspective(45.0, _frame.size.width / _frame.size.height, 0.1, 100.0);
	
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	
	glMatrixMode(GL_MODELVIEW);
	glPushMatrix();
	glLoadIdentity();
	gluLookAt(	0.0,0.0,5.0,
				0.0,0.0,0.0,
				0.0,1.0,0.0 );
	
	_rot += 0.9;
	
	glRotatef(_rot,0.5,1.0,0.25);
	
	[self renderQuad];
	
	glPopMatrix();
	glMatrixMode(GL_PROJECTION);
	glPopMatrix();
	
	glFlush();
	
	glPopAttrib();
	
	glMatrixMode(oldMatMode);
	
}

@end
