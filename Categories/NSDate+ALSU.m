#import "NSDate+ALSU.h"

@implementation NSDate (ALSU)

+(NSString *)currentTimeStamp
{
    NSDate *curDate = [NSDate date];
    NSTimeInterval ti = [curDate timeIntervalSince1970];
    NSString *result = [NSString stringWithFormat:@"%ld", (long)ti];
    return result;
}

+(NSDate*)dateFromString:(NSString*)string
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateValueFormat];
    NSDate * date = [dateFormatter dateFromString:string];
    return date;
}

+(NSDate*)dateFromStringFull:(NSString*)string
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateValueFormatFull];
    NSDate * date = [dateFormatter dateFromString:string];
    return date;
}

@end
