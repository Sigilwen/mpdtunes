//
//  MPDAlbumArtworkManager.m
//  mpdctrl
//
//  Created by Rob Clark on 3/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>             // contains declaration of CC_MD5 
#import "BackRowUtils.h"

#import "MPDAlbumArtworkManager.h"
#import "MPDConnection.h"


#define IMGDB @"/Users/frontrow/mpd/imgdb"


static MPDAlbumArtworkManager *instance;
static CGImageRef defaultImage;

static MPDAlbumArtworkAsset *_defaultAsset;

// maps  artist -> album -> asset
static NSMutableDictionary  *_assets;

// maps  artist -> album -> asset-url
static NSMutableDictionary  *_assetUrls;



NSString * md5( NSString *str )
{
  const char *cStr = [str UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  MD5( cStr, strlen(cStr), result );
  return [NSString 
    stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
    result[0], result[1],
    result[2], result[3],
    result[4], result[5],
    result[6], result[7],
    result[8], result[9],
    result[10], result[11],
    result[12], result[13],
    result[14], result[15]
  ];
}

NSString *urlEncodeValue( NSString *str )
{
  NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
  return [result autorelease];
}


void setInTable( NSMutableDictionary *dict, NSString *album, NSString *artist, id val )
{
  NSMutableDictionary *albums = [dict objectForKey:artist];
  if( albums == nil )
  {
    albums = [[NSMutableDictionary alloc] initWithCapacity: 5];
    [dict setObject:albums forKey:artist];
  }
  [albums setObject:val forKey:album];
}

id getFromTable( NSMutableDictionary *dict, NSString *album, NSString *artist )
{
  NSMutableDictionary *albums = [dict objectForKey:artist];
  if( albums == nil )
    return nil;
  return [albums objectForKey:album];
}


@implementation MPDAlbumArtworkAsset

- (id)initWithArtist: (NSString *)artist andAlbum: (NSString *)album
{
  if( [super init] == nil )
    return nil;
  
  _album  = album;
  _artist = artist;
  _image  = defaultImage;
  
  _listener = nil;
  
  if( (album != nil) && (artist != nil) )
  {
    NSString *url = getFromTable( _assetUrls, album, artist );
    if( url != nil )
    {
      if( ! [url hasPrefix:@"nak:"] )   // don't try to load if we've attempted but failed to find artwork before
        [self loadImageFromUrl:url];
    }
    else
    {
      [self loadImageFromAlbum:album andArtist:artist];
    }
  }
  
  return self;
}

- (void)setListener: (id)listener
{
  if( (_listener != nil) && (listener != nil) )
  {
    printf("hmm, this is bad\n%s\n", [[BRBacktracingException backtrace] UTF8String]);
  }
  _listener = listener;
}

- (void)loadImageFromAlbum: (NSString *)album andArtist: (NSString *)artist
{
  NSString *lastPart = [NSString stringWithFormat:@"coverArtMatch?an=%@&pn=%@", urlEncodeValue(artist), urlEncodeValue(album)];
  NSString *urlStr = [NSString stringWithFormat:@"http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZSearch.woa/wa/%@", lastPart];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
  
  //           $random  = sprintf( "%04X%04X", rand(0,0x10000), rand(0,0x10000) ); 
  //           $static  = base64_decode("ROkjAaKid4EUF5kGtTNn3Q=="); 
  //           $url_end = ( preg_match("|.*/.*/.*(/.+)$|",$url,$matches)) ? $matches[1] : '?'; 
  //           $digest  = md5(join("",array($url_end, 'iTunes/7.0 (Macintosh; U; PPC Mac OS X 10.4.7)', $static, $random)) ); 
  //           return $random . '-' . strtoupper($digest); 
  
  // calculate validation string:
//  NSString *userAgent = @"iTunes/7.0 (Macintosh; U; PPC Mac OS X 10.4.7)";
  NSString *userAgent = @"iTunes/7.4 (Macintosh; U; PPC Mac OS X 10.4.7)";
//  NSString *random = [NSString stringWithFormat:@"%08X", album];   // I guess pointer string is good enough random #?
//  NSString *digest = md5([NSString stringWithFormat:@"%@%@%@%@", lastPart, userAgent, @"Dé#¢¢w™µ3gÝ", random]);
//  NSString *valid  = [NSString stringWithFormat:@"%@-%@", random, digest];
  
//  printf("valid=%s\n", [valid UTF8String]);
  
/*
 request.UserAgent="iTunes/7.4 (Macintosh; U; PPC Mac OS X 10.4.7)"
 request.Headers.Add("X-Apple-Tz","-21600")
 request.Headers.Add("X-Apple-Store-Front","143441")
 request.Headers.Add("Accept-Language","en-us, en;q=0.50")
 request.Headers.Add("Accept-Encoding","gzip, x-aes-cbc")
*/  
  
  [req addValue:@"-21600"            forHTTPHeaderField: @"X-Apple-Tz"];
  [req addValue:@"143441"            forHTTPHeaderField: @"X-Apple-Store-Front"];
  [req addValue:userAgent            forHTTPHeaderField: @"User-Agent"];
  [req addValue:@"en-us, en;q=0.50"  forHTTPHeaderField: @"Accept-Language"];
//  [req addValue:valid                forHTTPHeaderField: @"X-Apple-Validation"];
  [req addValue:@"gzip, x-aes-cbc"   forHTTPHeaderField: @"Accept-Encoding"];
  [req addValue:@"close"             forHTTPHeaderField: @"Connection"];
  [req addValue:@"ax.phobos.apple.com.edgesuite.net" forHTTPHeaderField: @"Host"];
  
  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
  if(conn)
  {
    // Create the NSMutableData that will hold the received data
    // receivedData is declared as a method instance elsewhere
    _receivedData = [[NSMutableData data] retain];
  }
  else
  {
    NSLog(@"error creating connection");
  }
}

- (void)loadImageFromUrl: (NSString *)url
{
  BRImageManager *mgr = [BRImageManager sharedInstance];
  NSURL *imageURL = [NSURL URLWithString:url];
  _imageName = [[mgr imageNameFromURL: imageURL] retain];
  
  if ( [mgr isImageAvailable: _imageName] == NO )
  {
    printf("starting download from url: %s\n", [url UTF8String]);
    // register for notifications and start downloading
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(imageLoaded:)
                                                 name: @"BRAssetImageUpdated"
                                               object: nil];
    
    // this will begin the background download... we are lucky, because
    // writeEncryptedImageFromURL handles the encrypted high-resolution
    // album artwork
    [mgr writeEncryptedImageFromURL: imageURL];
  }
  else
  {
    printf("image already available: %s\n", [_imageName UTF8String]);
    _image = (CGImageRef)[[mgr imageNamed: _imageName] retain];
    id listener = _listener;
    if(listener) [listener imageLoaded];
  }
}

- (void) imageLoaded: (NSNotification *) note
{
  // can check for nil _imageName here, and remove observer
  NSDictionary * userInfo = [note userInfo];
  
  if( [_imageName isEqualToString: [userInfo objectForKey:@"BRMediaAssetKey"]] == NO )
  {
    return;
  }
  
  // we have our image, so we don't need any more notifications
  [[NSNotificationCenter defaultCenter] removeObserver: self 
                                                  name: @"BRAssetImageUpdated" object: nil];
  
  _image = (CGImageRef)[[userInfo objectForKey: @"BRImageKey"] retain];
  id listener = _listener;
  if(listener) [listener imageLoaded];
}

/* handlers for messages sent while downloading album info (which contains the
 * artwork URL
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  // this method is called when the server has determined that it
  // has enough information to create the NSURLResponse
  
  // it can be called multiple times, for example in the case of a
  // redirect, so each time we reset the data.
  // receivedData is declared as a method instance elsewhere
  [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  // append the new data to the receivedData
  // receivedData is declared as a method instance elsewhere
  [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
  // release the connection, and the data object
  [connection release];
  // receivedData is declared as a method instance elsewhere
  [_receivedData release];
  _receivedData = nil;
  
  // inform the user
  NSLog(@"Connection failed! Error - %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  // do something with the data
  // receivedData is declared as a method instance elsewhere
  NSString *decoded = [NSString stringWithCString:[_receivedData bytes] length:[_receivedData length]];
  
  const char *buf = [decoded UTF8String];
  buf = strstr( buf, "<key>cover-art-url</key>" );
  char url[512];
  NSString *val;
  if( buf && sscanf( buf, "<key>cover-art-url</key> <string>%[^<]</string>", url) )
  {
    val = [NSString stringWithUTF8String: url];
    [self loadImageFromUrl:val];
  }
  else
  {
    val = [NSString stringWithFormat:@"nak:%08x", time(NULL)];  // negative cache (not a valid URL)
  }
  
  setInTable( _assetUrls, _album, _artist, val );
  if( [NSKeyedArchiver archiveRootObject:_assetUrls toFile:IMGDB] == NO )
    NSLog(@"error writing %@ to %@", _assetUrls, IMGDB);
  
  // release the connection, and the data object
  [connection release];
  [_receivedData release];
  _receivedData = nil;
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
  
  _assets = [[NSMutableDictionary alloc] initWithCapacity: 50];
  
  _assetUrls = [NSKeyedUnarchiver unarchiveObjectWithFile:IMGDB];
  
  if(!_assetUrls)
    _assetUrls = [[NSMutableDictionary alloc] initWithCapacity: 50];
  else
    _assetUrls = [_assetUrls mutableCopy];
  
  NSString *path = @"/System/Library/PrivateFrameworks/BackRow.framework/Resources/Music.png";
  NSURL *url = [NSURL fileURLWithPath:path];
  CGImageSourceRef  sourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
  if(sourceRef) {
    defaultImage = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
    CFRelease(sourceRef);
  }
  
  return self;
}

/**
 * at least one of artist or album must not be nil!
 */
- (id)getAlbumAssetForArtist: (NSString *)artist andAlbum: (NSString *)album
{
  MpdData *data;
  MPDConnection *mpdConnection = [MPDConnection sharedInstance];
  if( (album == nil) && (artist != nil) )
  {
    for( data = [mpdConnection mpdSearchTag:MPD_TAG_ITEM_ALBUM forGenre:nil andArtist:artist andAlbum:album andSong:nil];
         data != NULL;
         data = [mpdConnection mpdSearchNext: data] )
    {
      if( data->type == MPD_DATA_TYPE_TAG )
      {
        album = str2nsstr(data->tag);
        [mpdConnection mpdSearchFree:data];
        break;
      }
    }
  }
  else if( (artist == nil) && (album != nil) )
  {
    for( data = [mpdConnection mpdSearchTag:MPD_TAG_ITEM_ARTIST forGenre:nil andArtist:artist andAlbum:album andSong:nil];
         data != NULL;
         data = [mpdConnection mpdSearchNext: data] )
    {
      if( data->type == MPD_DATA_TYPE_TAG )
      {
        artist = str2nsstr(data->tag);
        [mpdConnection mpdSearchFree:data];
        break;
      }
    }
  }
  
  if( (album == nil) || (artist == nil) )
  {
    if( _defaultAsset == nil )
      _defaultAsset = [[MPDAlbumArtworkAsset alloc] initWithArtist:nil andAlbum:nil];
    return _defaultAsset;
  }
  
  MPDAlbumArtworkAsset *asset = getFromTable( _assets, album, artist );
  if( asset == nil )
  {
    asset = [[MPDAlbumArtworkAsset alloc] initWithArtist:artist andAlbum:album];
    setInTable( _assets, album, artist, asset );
  }
  
  return asset;
}

// XXX maybe move to MPDPlayerController??
- (id)getAlbumAssetsForGenre: (NSString *)genre
                   andArtist: (NSString *)artist
                    andAlbum: (NSString *)album
                     andSong: (NSString *)song
{
  NSMutableArray *assets = [NSMutableArray array];
  int max = 20;
  MpdData *data;
  MPDConnection *mpdConnection = [MPDConnection sharedInstance];
  for( data = [mpdConnection mpdSearchTag:MPD_TAG_ITEM_ALBUM forGenre:genre andArtist:artist andAlbum:album andSong:song];
       data != NULL;
       data = [mpdConnection mpdSearchNext: data] )
  {
    if( data->type == MPD_DATA_TYPE_TAG )
    {
      NSString *album = str2nsstr(data->tag);
      
      // don't add albums that we know we don't have a cover for:
      NSString *url = getFromTable( _assetUrls, album, artist );
      if( url && ![url hasPrefix:@"nak:"] )
      {
        [assets addObject:[self getAlbumAssetForArtist:artist andAlbum:album]];
        if(!--max)
        {
          [mpdConnection mpdSearchFree:data];
          break;
        }
      }
    }
  }
  
  return assets;  // hmm, need to go thru and figure out where stuff is deallocated... darn that java garbage collection
}



@end
