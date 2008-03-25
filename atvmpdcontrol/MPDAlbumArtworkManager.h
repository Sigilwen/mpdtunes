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
  
  NSString  *_imageName;
}

- (id)initWithArtist: (NSString *)artist andAlbum: (NSString *)album;

- (BOOL)waitingForUpdate;

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
