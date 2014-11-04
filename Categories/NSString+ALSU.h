#import <Foundation/Foundation.h>

@interface NSString (ALSU)

+(NSString*)stringFromDate:(NSDate*)date;
+(NSString*)stringFromDateFull:(NSDate*)date;

+(NSString *)randomStringWithLenght:(NSInteger)length;

-(BOOL)containsString:(NSString *)string;

@end
