#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ALSUFileLogger : NSObject

<
    MFMailComposeViewControllerDelegate
>

@property (nonatomic, strong) NSString * archivePath;

+(instancetype)sharedInstance;

- (void)log:(NSString *)format, ...;

@end

@interface ALSUFileLogger (SendLogs)

-(void)sendLogs;
-(UIButton*)sendLogsButton;

@end