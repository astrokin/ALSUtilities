#import <UIKit/UIKit.h>

@interface UIColor (ALSU)

+ (UIColor *)colorWithHex:(NSInteger)color;
+ (UIColor *)colorWithHex:(NSInteger)color alpha:(float)alpha;

+ (UIColor *)randomColor;
@end
