#import "NSString+ALSU.h"

@implementation NSString (ALSU)

#pragma mark - Random
static NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";

+(NSString *)randomStringWithLenght:(NSInteger)length
{
    NSMutableString *s = [NSMutableString stringWithCapacity:length];
    for (NSUInteger i = 0U; i < length; i++)
    {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}
#pragma mark - Dates
+(NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateValueFormat];
    NSString * ret = [dateFormatter stringFromDate:(date == nil) ? [NSDate date] : date];
    return ret;
}
+(NSString*)stringFromDateFull:(NSDate*)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateValueFormatFull];
    NSString * ret = [dateFormatter stringFromDate:(date == nil) ? [NSDate date] : date];
    return ret;
}
#pragma mark - Contain
- (BOOL)containsString:(NSString *) string
                options:(NSStringCompareOptions) options
{
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *) string
{
    return [self containsString:string options:0];
}

@end
