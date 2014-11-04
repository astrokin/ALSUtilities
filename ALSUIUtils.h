#if defined DEBUG
#import <QuartzCore/QuartzCore.h>
#endif

static inline UIColor * GetRandomUIColor ()
{
    CGFloat r = arc4random() % 255;
    CGFloat g = arc4random() % 255;
    CGFloat b = arc4random() % 255;
    UIColor *result = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
    return result;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
static inline void DebugViewBorder (UIView* view)
{
#if defined DEBUG
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = GetRandomUIColor().CGColor;
    view.layer.cornerRadius = 0.0f;
#endif
}
#pragma clang diagnostic pop

@interface ALSUIUtils : NSObject

+(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message;
+(void)showNotificationBubbleWithMessage:(NSString*)message; // will be shown as notification (from top of the screen)
+(void)showUserHintWithMessage:(NSString*)message; // will be shown as hint (from bottom of the screen)
+(void)showError:(NSError*)error; //show localizedDescription of error
+(void)customKeyboardOnSearchBar:(UISearchBar *)searchBar;

@end
