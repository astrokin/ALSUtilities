#import "ALSUFuncUtils.h"
#include <sys/sysctl.h>

NSTimeInterval const kDefaultRequestTimeout = 33;
NSInteger const kPasswordMinLength = 6;

NSString * const kDefaultDomainName = @"com.pocketspheres";
NSString * const kInternetCachedImagesFolderName = @"CachedImages";
NSString * const kCameraImagesFolderName = @"SBImages";
NSString * const kImagesFileUsingFormat = @"jpeg";
NSString * const kDateValueFormat = @"MM/dd/yyyy";
NSString * const kDateValueFormatFull = @"MM/dd/yyyy HH:mm:ss";

////////////////////////////////////////////////////////////////////////////////

NSString *platform()
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

NSString *freeDiskspace()
{
    NSString *result = nil;
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    __autoreleasing NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        result = [NSString stringWithFormat:@"Memory %llu of %llu Mb available.",((totalFreeSpace/1024ll)/1024ll), ((totalSpace/1024ll)/1024ll)];
    } else {
        result = [NSString stringWithFormat:@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]];
    }
    
    return result;
}
NSString *platformString()
{
    NSString *machineName = platform();
    
    //MARK: More official list is at
    //http://theiphonewiki.com/wiki/Models
    //MARK: You may just return machineName. Following is for convenience
    
    NSDictionary *commonNamesDictionary =
    @{
      @"i386":     @"iPhone Simulator",
      @"x86_64":   @"iPad Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone 3G",
      @"iPhone2,1":    @"iPhone 3GS",
      @"iPhone3,1":    @"iPhone 4",
      @"iPhone3,2":    @"iPhone 4(Rev A)",
      @"iPhone3,3":    @"iPhone 4(CDMA)",
      @"iPhone4,1":    @"iPhone 4S",
      @"iPhone5,1":    @"iPhone 5(GSM)",
      @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
      @"iPhone5,3":    @"iPhone 5c(GSM)",
      @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
      @"iPhone6,1":    @"iPhone 5s(GSM)",
      @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",
      
      @"iPhone7,1":    @"iPhone 6+ (GSM+CDMA)",
      @"iPhone7,2":    @"iPhone 6 (GSM+CDMA)",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini 1G (WiFi)",
      @"iPad2,6":  @"iPad Mini 1G (GSM)",
      @"iPad2,7":  @"iPad Mini 1G (GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      
      @"iPad4,1":  @"iPad Air(WiFi)",
      @"iPad4,2":  @"iPad Air(GSM)",
      @"iPad4,3":  @"iPad Air(GSM+CDMA)",
      
      @"iPad4,4":  @"iPad Mini 2G (WiFi)",
      @"iPad4,5":  @"iPad Mini 2G (GSM)",
      @"iPad4,6":  @"iPad Mini 2G (GSM+CDMA)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",
      
      };
    
    NSString *deviceName = commonNamesDictionary[machineName];
    
    if (deviceName == nil) {
        deviceName = machineName;
    }
    
    return deviceName;
}

NSString *devInfo()
{
    return [NSString stringWithFormat:@"current device:%@ \rinfo: \rhardware: %@ \riOS ver: %@ \rdisk info: %@",
            [[UIDevice currentDevice] name],
            platformString(),
            [[UIDevice currentDevice] systemVersion],
            freeDiskspace()];
}

BOOL isValidEmail(NSString* email)
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

BOOL isValidPassword(NSString* password)
{
    BOOL result = NO;
    if (password.length >= kPasswordMinLength) result = YES;
    return result;
}

void postNotificationName(NSString*n)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:n object:nil];
}
NSString *DocumentDirectory()
{
	NSArray *documentDirList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentDirList objectAtIndex:0];
	return documentDir;
};
NSString *PathInDocumentDirectory(NSString *fname)
{
	NSString *path = nil;
	NSString *documentDir = DocumentDirectory();
	path = [documentDir stringByAppendingPathComponent:fname];
	return path;
}
NSString *ImagesCacheDirectory()
{
	return PathInDocumentDirectory(kInternetCachedImagesFolderName);
}
NSString* ImageFilePathFromUrl(NSString *url)
{
	NSMutableString *path = [NSMutableString stringWithCapacity:512];
	NSArray *compenents = [url pathComponents];
	NSString *documentDir = DocumentDirectory();
	[path appendFormat:@"%@/%@", documentDir, kInternetCachedImagesFolderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError* error;
        if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error])
        {
            assert(@"Failed to create directory maybe out of disk space?");
        }
    }
	for (NSString *component in compenents)
	{
		if (!([component hasPrefix:@"http"] ||
              [component hasPrefix:@"www"]))
		{
			[path appendFormat:@"/%@", component];
		}
	}
	return path;
};
NSString* ImageFilePathInSandBox(ImageSizeType size)
{
    NSMutableString *path = [NSMutableString stringWithCapacity:512];
    NSString *documentDir = DocumentDirectory();
	[path appendFormat:@"%@/%@", documentDir, kInternetCachedImagesFolderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError* error;
        if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error])
        {
            assert(@"Failed to create directory maybe out of disk space?");
        }
    }
    [path appendFormat:@"/%@", kCameraImagesFolderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError* error;
        if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error])
        {
            assert(@"Failed to create directory maybe out of disk space?");
        }
    }
    [path appendFormat:@"/%@", [NSDate currentTimeStamp]];
    if (size == ImageSizeThumb) [path appendFormat:@"_thumb"];
    [path appendFormat:@".%@", kImagesFileUsingFormat];
    return path;
};
BOOL CreateFileAtPath(NSString* path)
{
	NSString *dirName = [path stringByDeletingLastPathComponent];
	return [[NSFileManager defaultManager]
     createDirectoryAtPath:dirName
     withIntermediateDirectories:YES
     attributes:nil
     error:nil];
}
double DegreesToRadians(double degrees)
{
    return degrees * M_PI / 180;
};
double RadiansToDegrees(double radians)
{
    return radians * 180 / M_PI;
};
NSString *CurrentApplicationVersion ()
{
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * versionBuildString = [NSString stringWithFormat:@"%@ (%@)", appVersionString, appBuildString];
    return versionBuildString;
}
NSString *deviceUUID()
{
    NSString *uID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
    if (uID) return uID;
    NSString *bundle = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *identifier = [NSString stringWithFormat:@"%@_uuid", bundle];
    ALSUKeychainItemWrapper *wrapper = [[ALSUKeychainItemWrapper alloc]
                                    initWithIdentifier:identifier accessGroup:nil];
    if (!uID || uID.length == 0)
    {
        [wrapper setObject:identifier forKey:(__bridge id)kSecAttrService];
        uID = [wrapper objectForKey:(__bridge id)kSecValueData];
        [[NSUserDefaults standardUserDefaults] setObject:uID forKey:@"UUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (!uID || uID.length == 0)
    {
        NSUUID *uuId = [[NSUUID alloc] init];
        uID = [uuId UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uID forKey:@"UUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [wrapper setObject:uID forKey:(__bridge id)kSecValueData];
        DLog(@"UUID CREATED: %@", uID);
    }
    return uID;
}
NSError *LocalDomainErrorWithMessage(NSString* mess)
{
    NSDictionary *info = [NSDictionary dictionaryWithObject:mess forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:kDefaultDomainName code:666 userInfo:info];
    return error;
}
////////////////////////////////////////////////////////////////////////////////

void createCustomPhotoAlbumIfNeededAndWriteImage(UIImage *image)
{
    assert(image);
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    __block typeof(ALAssetsLibrary) *weakLibrary = library;
    __block ALAssetsGroup* groupToAddTo = nil;
    
    void(^saveImageToPhotoLibrary)() = ^()
    {
        NSString *dispName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        [library addAssetsGroupAlbumWithName:dispName resultBlock:^(ALAssetsGroup *group) {
            [weakLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                       usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                           if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:dispName]) {
                                               groupToAddTo = group;
                                           }
                                       }
                                     failureBlock:^(NSError* error) {
                                         [ALSUIUtils showError:error];
                                     }];
            [weakLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
                if (error.code == 0)
                {
                    [weakLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [groupToAddTo addAsset:asset];
                    } failureBlock:^(NSError *error) {
                        [ALSUIUtils showError:error];
                    }];
                }
                else
                {
                    [ALSUIUtils showError:error];
                }
            }];
        } failureBlock:^(NSError *error) {
            //            [ALSUIUtils showError:error];
        }];
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        saveImageToPhotoLibrary();
    });
}

@implementation ALSUFuncUtils

@end
