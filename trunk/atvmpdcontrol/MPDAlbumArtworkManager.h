//
//  MPDAlbumArtworkManager.h
//  mpdctrl
//
//  Created by Rob Clark on 3/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import <NSDictionary.h>
#import <BackRow/BRSingleton.h>
#import <BackRow/BRImageManager.h>
#import <BackRow/BRRenderLayer.h>

@interface MPDAlbumArtworkAsset : BRSimpleMediaAsset {
  CGImageRef  _image;
  NSString   *_artist;
  NSString   *_album;
  
  /* used during step one of requesting artwork (querying for artwork
   * location):
   */
  NSMutableData *_receivedData;
  
  NSString      *_imageName;
  
  id _listener;
}

- (id)initWithArtist: (NSString *)artist andAlbum: (NSString *)album;

/**
 * add a object to have it's imageLoaded method called when image is loaded
 * (if the image was not loaded immediately on creation).  To unregister the
 * listener, call setListener:nil.
 * <p>
 * we are kinda lo-tech here... no supporting multiple listeners which can
 * specify their own selectors, but I think we only need one listener at a
 * time..
 */
- (void)setListener: (id)listener;

//@private
- (void)loadImageFromAlbum: (NSString *)album andArtist: (NSString *)artist;
- (void)loadImageFromUrl: (NSString *)url;

@end


@interface MPDAlbumArtworkManager : BRSingleton {
}

+ (id)singleton;
+ (void)setSingleton:(id)fp8;
- (id)init;

- (id)getAlbumAssetForArtist: (NSString *)artist andAlbum: (NSString *)album;


- (id)getAlbumAssetsForGenre: (NSString *)genre
                   andArtist: (NSString *)artist
                    andAlbum: (NSString *)album
                     andSong: (NSString *)song;


@end
