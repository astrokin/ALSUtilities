#import "PleaseWaitAlertView.h"

@implementation PleaseWaitAlertView

+ (PleaseWaitAlertView*)sharedView
{
    static dispatch_once_t once;
    static PleaseWaitAlertView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[self alloc] initWithTitle:NSLocalizedString(@"Loading", nil)
                                         message:NSLocalizedString(@"Please wait...", nil)
                                        delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:nil];
        sharedView.delegate = sharedView;
    });
    return sharedView;
}

+ (void) show
{
    if (![self sharedView].isVisible)
    {
        [[self sharedView] show];
    }
}
+ (void) dismiss
{
    if ([self sharedView].isVisible)
    {
        [[self sharedView] dismissWithClickedButtonIndex:0 animated:YES];
    }
}
#pragma mark -     UIAlertViewDelegate
- (void)willPresentAlertView:(UIAlertView *)alertView  // before animation and showing view
{
    alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y + 25.5, alertView.frame.size.width, 90.0);
}

@end
