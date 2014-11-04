#import <Foundation/Foundation.h>

@interface NSDate (ALSU)

+(NSString *)currentTimeStamp;

+(NSDate*)dateFromString:(NSString*)string; //2013-12-02
+(NSDate*)dateFromStringFull:(NSString*)string; //2013-12-02 05:26:31

@end
