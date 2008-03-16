//
//  MADVertLayout.m
//  mpdctrl
//
//  Created by Marcus Tillmanns on 02.06.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MADVertLayout.h"
#import "MADObjectWithConstraint.h"
#import "MADObjectWithSize.h"
#import "MADObjectWithAspect.h"
#import "MADObjectWithAutoSize.h"
#import "MADObjectWithSizeFromObject.h"


@implementation MADVertLayout

+ (id)createSafeLayout:(BRRenderScene*)scene
{
	NSRect masterFrame = NSZeroRect;
	masterFrame.size = [scene size];

	masterFrame = NSInsetRect( masterFrame, [scene size].width * 0.05f, [scene size].height * 0.05f );

	MADVertLayout* innerLayout = [[[MADVertLayout alloc]init]autorelease];
	
	[innerLayout setFrame:masterFrame];
	
	return innerLayout;
}

- (void)addObject:(id)object withConstraint:(float) vertConstraint
{
	MADObjectWithConstraint * ob = [[[MADObjectWithConstraint alloc] 
									initWithObject:object andConstraint:vertConstraint] autorelease];
	
	[_controls addObject:ob];
}

- (void)addObject:(id)object withSize:(int) vertSize
{
	MADObjectWithSize * ob = [[[MADObjectWithSize alloc] 
								initWithObject:object andSize:vertSize] autorelease];
	
	[_controls addObject:ob];
}

- (void)addObject:(id)object withAspect:(float) aspect
{
	MADObjectWithAspect * ob = [[[MADObjectWithAspect alloc] 
								initWithObject:object andAspect:aspect] autorelease];
	
	[_controls addObject:ob];
}

- (void)addObject:(id)object
{
	if( ! [object respondsToSelector:@selector(renderedSize) ] )
		@throw @"Object has to support selector 'renderedSize'";
		
	MADObjectWithAutoSize * ob = [[[MADObjectWithAutoSize alloc ]
									initWithObject:object ] autorelease];
									
	[_controls addObject:ob];
}

- (void)addObject:(id)object withSizeFromObject:(id) sizeObject
{
	if( ! [sizeObject respondsToSelector:@selector(renderedSize) ] )
		@throw @"Object has to support selector 'renderedSize'";
		
	MADObjectWithSizeFromObject * ob = [[[MADObjectWithSizeFromObject alloc ]
									initWithObject:object sizeObject:sizeObject ] autorelease];
									
	[_controls addObject:ob];	
}

-(void)doLayout
{
	int i;
	int allFixSize = 0;
	float allConstraints = 0.0;
	
	for(i=0;i<[_controls count];i++)
	{
		id curCtrl = [_controls objectAtIndex:i];

		if( [curCtrl isKindOfClass:[MADObjectWithSize class]] )
			allFixSize += [((MADObjectWithSize*)curCtrl) size];
		else if( [curCtrl isKindOfClass:[MADObjectWithConstraint class]] )
			allConstraints += [((MADObjectWithConstraint*)curCtrl) constraint];
		else if( [curCtrl isKindOfClass:[MADObjectWithAspect class]] )
			allFixSize += _frame.size.width * [((MADObjectWithAspect*)curCtrl) aspect];
		else if( [curCtrl isKindOfClass:[MADObjectWithAutoSize class]] )
			allFixSize += [[((MADObjectWithAutoSize*)curCtrl) object] renderedSize].height;
		else if( [curCtrl isKindOfClass:[MADObjectWithSizeFromObject class]] )
			allFixSize += [[((MADObjectWithSizeFromObject*)curCtrl) sizeObject] renderedSize].height;
	}
	
	if(allFixSize > _frame.size.height)
		return;	// FIXME: Throw LayoutError

	int constraintedSize = _frame.size.height - allFixSize;

	// Start at Top
	int y = _frame.origin.y + _frame.size.height;
		
	for(i=0;i<[_controls count];i++)
	{
		id curCtrl = [_controls objectAtIndex:i];
		
		NSRect curFrame;
		
		curFrame.origin.x = _frame.origin.x;
		curFrame.size.width = _frame.size.width;
		
		int curSize = 0;
		id theObject = nil;
		
		if( [curCtrl isKindOfClass:[MADObjectWithAutoSize class]] )
		{
			theObject = [((MADObjectWithSize*)curCtrl) object];
			NSSize rSize = [theObject renderedSize];
			
			curSize = rSize.height; 		
		}
		else if( [curCtrl isKindOfClass:[MADObjectWithSize class]] )
		{
			theObject = [((MADObjectWithSize*)curCtrl) object];
			curSize = [((MADObjectWithSize*)curCtrl) size];
		}
		else if( [curCtrl isKindOfClass:[MADObjectWithAspect class]] )
		{
			theObject = [((MADObjectWithAspect*)curCtrl) object];
			curSize = [((MADObjectWithAspect*)curCtrl) aspect] * _frame.size.width;							
		}
		else if( [curCtrl isKindOfClass:[MADObjectWithConstraint class]] )
		{
			theObject = [((MADObjectWithConstraint*)curCtrl) object];
			float curPart = [((MADObjectWithConstraint*)curCtrl) constraint]/allConstraints;
			curSize = constraintedSize * curPart;
		}
		else if( [curCtrl isKindOfClass:[MADObjectWithSizeFromObject class]] )
		{
			theObject = [((MADObjectWithSizeFromObject*)curCtrl) object];
			id theSizeObject = [((MADObjectWithSizeFromObject*)curCtrl) sizeObject];
			NSSize rSize = [theSizeObject renderedSize];
			curSize = rSize.height;
		}
		else
			@throw @"Impossible error, as long as you didn't tempered with protected stuff"; 
		
		y -= curSize;

		curFrame.origin.y = y;
		curFrame.size.height = curSize;
		
		if( [theObject respondsToSelector:@selector(setFrame:)] )
			[theObject setFrame:curFrame];	
		
		if( [ theObject respondsToSelector:@selector(doLayout)] )
			[ theObject doLayout];		
	}
}

@end
