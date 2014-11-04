#import "UIColor+ALSU.h"

@implementation UIColor (ALSU)

+ (UIColor *)colorWithHex:(NSInteger)color
{
    return [UIColor colorWithHex:color alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)color alpha:(float)alpha
{
    return [UIColor colorWithRed:(((color & 0xFF0000) >> 16)) / 255.0f
                           green:(((color & 0xFF00) >> 8)) / 255.0f
                            blue:((color & 0xFF)) / 255.0f
                           alpha:alpha];
}

+ (UIColor *)randomColor
{
    return GetRandomUIColor();
}
@end
