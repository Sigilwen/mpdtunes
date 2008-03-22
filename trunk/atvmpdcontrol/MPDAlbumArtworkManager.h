//
//  MPDAlbumArtworkManager.h
//  mpdctrl
//
//  Created by Rob Clark on 3/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BRSingleton.h>
#import <BackRow/BRImageManager.h>
#import <BackRow/BRRenderLayer.h>

@interface MPDAlbumArtworkAsset : BRSimpleMediaAsset {
  CGImageRef  _image;
}

- (id)initWithImage: (CGImageRef)image;

@end

@interface MPDAlbumArtworkManager : BRSingleton {
  BRImageManager *_mgr;
  CGImageRef      _defaultIcon;
}

+ (id)singleton;
+ (void)setSingleton:(id)fp8;
- (id)init;

//- (BRRenderLayer *)getIcon: (BRRenderScene *)scene withArtist: (NSString *)artist andAlbum: (NSString *)album;

- (id)getAlbumAsset: (NSString *)album forArtist: (NSString *)artist;

//- (CGImageRef)defaultIcon;

@end
