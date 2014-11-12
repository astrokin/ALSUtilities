//
//  ALSUFileLogger+SendLogs.m
//  Spheres
//
//  Created by Alexey Strokin on 11/13/14.
//  Copyright (c) 2014 Pocketspheres LLC. All rights reserved.
//

#import "ALSUFileLogger.h"
#import "PleaseWaitAlertView.h"
#import "ZipFile.h"
#import "ZipWriteStream.h"
#import <MessageUI/MessageUI.h>

@implementation ALSUFileLogger (SendLogs)

-(void)sendLogs
{
    [PleaseWaitAlertView show];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale* enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale: enUS];
    [formatter setLenient: YES];
    [formatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    
    NSString *archiveName = [NSString stringWithFormat:@"Logs_%@.zip", [formatter stringFromDate:[NSDate date]]];
    NSString *archivePath = [PathForCachesFolder() stringByAppendingPathComponent:archiveName];
    
    self.archivePath = archivePath;
    
    NSThread *zipThread= [[NSThread alloc] initWithTarget:self selector:@selector(zipFilesToFile:) object:archivePath];
    [zipThread start];
    
}
- (void)zipFilesToFile:(NSString *)archivePath
{
    @autoreleasepool {
        @try {
            ZipFile *zipFile= [[ZipFile alloc] initWithFileName:archivePath mode:ZipFileModeCreate];
            NSString *logPath = PathForCachesFolder();
            NSArray *logFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logPath error:nil];
            for (NSString *logFileName in logFiles)
            {
                if ([logFileName hasSuffix:@"log"])
                {
                    NSString *filePath = [logPath stringByAppendingPathComponent:logFileName];
                    
                    ZipWriteStream *stream= [zipFile writeFileInZipWithName:logFileName compressionLevel:ZipCompressionLevelBest];
                    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
                    
                    [stream writeData:data];
                    [stream finishedWriting];
                }
            }
            [zipFile close];
            [self performSelectorOnMainThread:@selector(finishZip) withObject:nil waitUntilDone:NO];
        }
        @catch (NSException *e)
        {
            [self performSelectorOnMainThread:@selector(failZip) withObject:nil waitUntilDone:NO];
        }
    }
}
- (void)finishZip
{
    [PleaseWaitAlertView dismiss];
    [self emailLogs];
}
-(void)failZip
{
    [PleaseWaitAlertView dismiss];
    DLog(@"Zipping error");
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Zipping error", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil] show];
}
- (void)emailLogs
{
    if (![MFMailComposeViewController canSendMail])
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Setup email client", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil] show];
        return;
    }
    
    if (self.archivePath != nil)
    {
        NSString *name = [self.archivePath lastPathComponent];
        MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
        mailPicker.mailComposeDelegate = self;
        NSData *attachmentData = [[NSData alloc] initWithContentsOfFile:self.archivePath];
        [mailPicker addAttachmentData:attachmentData mimeType:@"application/zip" fileName:name];
        [mailPicker setSubject:@"PocketSpheres iOS logs"];
        [mailPicker setBccRecipients:[NSArray arrayWithObjects:@"ale.stro.ios.dev@gmail.com", nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController
            presentViewController:mailPicker animated:YES completion:NULL];
    }
}
#pragma mark -     MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *message = nil;
    if (error)
    {
        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
        message = error.localizedDescription;
    }
    else if (result == MFMailComposeResultSent)
    {
        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
        message = NSLocalizedString(@"Logs have been successfully sent. Thank you.", nil);
    }
    else if (result == MFMailComposeResultFailed)
    {
        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
        message = error.localizedDescription;
    }
    else if (result == MFMailComposeResultSaved)
    {
        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
        message = NSLocalizedString(@"Saved successfully", nil);
    }
    else if (result == MFMailComposeResultCancelled)
    {
        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
        message = NSLocalizedString(@"Deleted successfully", nil);
    }
    DLog(@"Email: %@", message);
    double delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil] show];
    });
}

@end
