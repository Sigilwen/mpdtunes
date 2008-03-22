//
//  MPDAlbumArtworkManager.m
//  mpdctrl
//
//  Created by Rob Clark on 3/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BackRowUtils.h"

#import "MPDAlbumArtworkManager.h"

static MPDAlbumArtworkManager *instance;


@implementation MPDAlbumArtworkManager

+(id)singleton
{
  return instance;
}

+(void)setSingleton:(id)singleton
{
  instance = (MPDAlbumArtworkManager *)singleton;
}


- (id)init
{
  if( [super init] == nil )
    return nil;
  
  printf("Initializing MPDAlbumArtworkManager\n");
  
  _mgr = [BRImageManager sharedInstance];
  
  NSString *path = [[[NSBundle bundleForClass:[self class]] bundlePath] stringByAppendingString:@"/Contents/Resources/DefaultPreview.png"];
  NSURL *url = [NSURL fileURLWithPath:path];
  CGImageSourceRef  sourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
  if(sourceRef) {
    _defaultIcon = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
    CFRelease(sourceRef);
  }
  
  return self;
}


- (id)getAlbumAsset: (NSString *)album forArtist: (NSString *)artist
{
  return [[[MPDAlbumArtworkAsset alloc] initWithImage: _defaultIcon] autorelease];
}


@end


@implementation MPDAlbumArtworkAsset

- (id)initWithImage: (CGImageRef)image
{
  if( [super init] == nil )
    return nil;
  _image = image;
  return self;
}


- (BOOL)hasCoverArt
{
  return YES;
}

- (CGImageRef)coverArt
{
  return _image;
}

@end

