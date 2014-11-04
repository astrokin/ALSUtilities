#import "ALSUIUtils.h"

@implementation ALSUIUtils

+(void)showError:(NSError*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:STR(@"LK_SORRY")
                                                      message:error.localizedDescription delegate:nil
                                            cancelButtonTitle:STR(@"LK_OK") otherButtonTitles:nil, nil];
    [alert show];
}

+(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                      message:message delegate:nil
                                            cancelButtonTitle:STR(@"LK_OK") otherButtonTitles:nil, nil];
    [alert show];
}
+(void)customKeyboardOnSearchBar:(UISearchBar *)searchBar
{
    for(UIView *subView in searchBar.subviews)
    {
        if([subView conformsToProtocol:@protocol(UITextInputTraits)])
        {
            [(UITextField *)subView setKeyboardAppearance:UIKeyboardAppearanceAlert];
            [(UITextField *)subView setReturnKeyType:UIReturnKeyDone];
        }
        else
        {
            for(UIView *subSubView in [subView subviews])
            {
                if([subSubView conformsToProtocol:@protocol(UITextInputTraits)])
                {
                    [(UITextField *)subSubView setReturnKeyType:UIReturnKeyDone];
                    [(UITextField *)subSubView setKeyboardAppearance:UIKeyboardAppearanceAlert];
                }
            }
        }
    }
}
static UIView *collectDataView = nil;

static const CGFloat xOffset = 10.0f;
static const CGFloat height = 40.0f;

static const CGFloat bounceOffset = 60.0f;

#define kMessageLabelTag 55

+(UIView*)collectDataView
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		collectDataView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, -height, [[UIScreen mainScreen] bounds].size.width - xOffset*2, height)];
        collectDataView.clipsToBounds = YES;
        collectDataView.layer.cornerRadius = 8.0f;
        collectDataView.backgroundColor = [UIColor redColor];
        UILabel *countLabel = [[UILabel alloc] initWithFrame:collectDataView.bounds];
        countLabel.tag = kMessageLabelTag;
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.font = [UIFont systemFontOfSize:14.0f];
        countLabel.adjustsFontSizeToFitWidth = YES;
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.textColor = [UIColor whiteColor];
        countLabel.numberOfLines = 2;
        [collectDataView addSubview:countLabel];
        [[[UIApplication sharedApplication] keyWindow] addSubview:collectDataView];
        collectDataView.hidden = YES;
	});
	return collectDataView;
}
+(void)showNotificationBubbleWithMessage:(NSString*)message
{
    if ([self collectDataView].hidden == NO) return;
    [self collectDataView].hidden = NO;
    CGRect frame = CGRectMake(xOffset, -height, [[UIScreen mainScreen] bounds].size.width - xOffset*2, height);
    [self collectDataView].frame = frame;
    if ([self collectDataView].superview == nil)
    {
        [[[UIApplication sharedApplication] keyWindow] addSubview:[self collectDataView]];
    }
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:[self collectDataView]];
    [(UILabel*)[[self collectDataView] viewWithTag:kMessageLabelTag] setText:message];
    __block UIView *w = [self collectDataView];
    __block typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = w.frame;
        frame.origin.y += bounceOffset;
        w.frame = frame;
        w.alpha = 1.0;
    } completion:^(BOOL finished) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf hideMessage];
        });
    }];
}
+(void)hideMessage
{
    __block UIView *w = [self collectDataView];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = w.frame;
        frame.origin.y = 0;
        w.alpha = 0;
        w.frame = frame;
    } completion:^(BOOL finished) {
        w.hidden = YES;
    }];
}
+(void)showUserHintWithMessage:(NSString*)message
{
    if ([self collectDataView].hidden == NO) return;
    [self collectDataView].hidden = NO;
    CGRect frame = CGRectMake(xOffset, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width - xOffset*2, height);
    [self collectDataView].frame = frame;
    if ([self collectDataView].superview == nil)
    {
        [[[UIApplication sharedApplication] keyWindow] addSubview:[self collectDataView]];
    }
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:[self collectDataView]];
    [(UILabel*)[[self collectDataView] viewWithTag:kMessageLabelTag] setText:message];
    __block UIView *w = [self collectDataView];
    __block typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = w.frame;
        frame.origin.y -= bounceOffset - 15;
        w.frame = frame;
        w.alpha = 1.0;
    } completion:^(BOOL finished) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf hideHint];
        });
    }];
}
+(void)hideHint
{
    __block UIView *w = [self collectDataView];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = w.frame;
        frame.origin.y = [[UIScreen mainScreen] bounds].size.height;
        w.alpha = 0;
        w.frame = frame;
    } completion:^(BOOL finished) {
        w.hidden = YES;
    }];
}
@end