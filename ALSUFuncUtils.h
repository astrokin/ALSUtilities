#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, ImageSizeType)
{
    ImageSizeFull = 0,
    ImageSizeThumb
};

FOUNDATION_EXPORT NSTimeInterval const kDefaultRequestTimeout;
FOUNDATION_EXPORT NSInteger const kPasswordMinLength;

FOUNDATION_EXPORT NSString * const kDefaultDomainName;
FOUNDATION_EXPORT NSString * const kDefaultSphereName;
FOUNDATION_EXPORT NSString * const kInternetCachedImagesFolderName;
FOUNDATION_EXPORT NSString * const kImagesFileUsingFormat;
FOUNDATION_EXPORT NSString * const kDateValueFormat;
FOUNDATION_EXPORT NSString * const kDateValueFormatFull;

////////////////////////////////////////////////////////////////////////////////

#pragma mark - Hardware info
extern NSString * platform();
extern NSString * freeDiskspace();
extern NSString * platformString();
extern NSString * devInfo();
extern NSString * CurrentApplicationVersion();
extern NSString * deviceUUID();

#pragma mark - Validations
extern BOOL isValidEmail (NSString* email);
extern BOOL isValidPassword (NSString* password);

#pragma mark - Override
extern NSMutableSet* AllocNotRetainedMutableSet();

#pragma mark - File managment
extern NSString * DocumentDirectory();
extern NSString * PathForCachesFolder();
extern NSString * PathInDocumentDirectory (NSString *fname);
extern NSString * ImagesCacheDirectory();
extern NSString * ImageFilePathFromUrl (NSString *url);
extern NSString * ImageFilePathInSandBox (ImageSizeType size);
extern BOOL CreateFileAtPath (NSString* path);

#pragma mark - Radians
extern double DegreesToRadians (double degrees);
extern double RadiansToDegrees (double radians);

extern NSError *LocalDomainErrorWithMessage (NSString* mess);

#pragma mark - Short
extern void postNotificationName (NSString*n);

void createCustomPhotoAlbumIfNeededAndWriteImage(UIImage *image);

@interface ALSUFuncUtils : NSObject

@end