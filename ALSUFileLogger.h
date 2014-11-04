#import <Foundation/Foundation.h>

@interface ALSUFileLogger : NSObject

+(instancetype)sharedInstance;

- (void)log:(NSString *)format, ...;

@end
