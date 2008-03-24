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

- (void)loadImageFromAlbum: (NSString *)album andArtist: (NSString *)artist
{
  NSString *lastPart = [NSString stringWithFormat:@"coverArtMatch?an=%@&pn=%@", urlEncodeValue(artist), urlEncodeValue(album)];
  NSString *urlStr = [NSString stringWithFormat:@"http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZSearch.woa/wa/%@", lastPart];
  printf("url=%s\n", [urlStr UTF8String]);
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
  
  //           $random  = sprintf( "%04X%04X", rand(0,0x10000), rand(0,0x10000) ); 
  //           $static  = base64_decode("ROkjAaKid4EUF5kGtTNn3Q=="); 
  //           $url_end = ( preg_match("|.*/.*/.*(/.+)$|",$url,$matches)) ? $matches[1] : '?'; 
  //           $digest  = md5(join("",array($url_end, 'iTunes/7.0 (Macintosh; U; PPC Mac OS X 10.4.7)', $static, $random)) ); 
  //           return $random . '-' . strtoupper($digest); 
  
  // calculate validation string:
//  NSString *userAgent = @"iTunes/7.0 (Macintosh; U; PPC Mac OS X 10.4.7)";
  NSString *userAgent = @"iTunes/7.4 (Macintosh; U; PPC Mac OS X 10.4.7)";
  NSString *random = [NSString stringWithFormat:@"%08X", album];   // I guess pointer string is good enough random #?
  NSString *digest = md5([NSString stringWithFormat:@"%@%@%@%@", lastPart, userAgent, @"Dé#¢¢w™µ3gÝ", random]);
  NSString *valid  = [NSString stringWithFormat:@"%@-%@", random, digest];
  
  printf("valid=%s\n", [valid UTF8String]);
  
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
  printf("loadImageFromUrl: %s\n", [url UTF8String]);
  
  if ( [mgr isImageAvailable: _imageName] == NO )
  {
    printf("starting download\n");
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
    printf("image already available\n");
    _image = (CGImageRef)[[mgr imageNamed: _imageName] retain];
    
    // XXX some way to notify that image has updated?
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
  printf("imageLoaded, my image\n");
  
  // we have our image, so we don't need any more notifications
  [[NSNotificationCenter defaultCenter] removeObserver: self 
                                                  name: @"BRAssetImageUpdated" object: nil];
  
  _image = (CGImageRef)[[userInfo objectForKey: @"BRImageKey"] retain];
  // XXX some way to notify that image has updated?
}


- (id)initWithAlbum: (NSString *)album andArtist: (NSString *)artist
{
  if( [super init] == nil )
    return nil;
  
  _album  = album;
  _artist = artist;
  _image  = defaultImage;
  
  if( (album != nil) && (artist != nil) )
  {
    NSString *url = getFromTable( _assetUrls, album, artist );
    if( url != nil )
      [self loadImageFromUrl:url];
    else
      [self loadImageFromAlbum:album andArtist:artist];
  }
  
  return self;
}

/* handlers for messages sent while downloading album info (which contains the
 * artwork URL
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  printf("didReceiveResponse\n");
  // this method is called when the server has determined that it
  // has enough information to create the NSURLResponse
  
  // it can be called multiple times, for example in the case of a
  // redirect, so each time we reset the data.
  // receivedData is declared as a method instance elsewhere
  [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  printf("didReceiveData\n");
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
  NSLog(@"Succeeded! Received %d bytes of data",[_receivedData length]);
  
  NSString *decoded = [NSString stringWithCString:[_receivedData bytes] length:[_receivedData length]];
  
  const char *buf = [decoded UTF8String];
  buf = strstr( buf, "<key>cover-art-url</key>" );
  char url[512];
  if( buf && sscanf( buf, "<key>cover-art-url</key> <string>%[^<]</string>", url) )
  {
    printf("found url: %s\n", url);
    NSString *nUrl = [NSString stringWithUTF8String: url];
    setInTable( _assetUrls, _album, _artist, nUrl );
    if( [NSKeyedArchiver archiveRootObject:_assetUrls toFile:IMGDB] == NO )
      NSLog(@"error writing %@ to %@", _assetUrls, IMGDB);
    [self loadImageFromUrl:nUrl];
  }
  
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

- (BOOL)waitingForUpdate
{
  return _image == defaultImage;
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


- (id)getAlbumAsset: (NSString *)album forArtist: (NSString *)artist
{
  if( (album == nil) || (artist == nil) )
  {
    if( _defaultAsset == nil )
      _defaultAsset = [[MPDAlbumArtworkAsset alloc] initWithAlbum:nil andArtist:nil];
    return _defaultAsset;
  }
  MPDAlbumArtworkAsset *asset = getFromTable( _assets, album, artist );
  if( asset == nil )
  {
    asset = [[MPDAlbumArtworkAsset alloc] initWithAlbum:album andArtist:artist];
    setInTable( _assets, album, artist, asset );
  }
  return asset;
}

@end
