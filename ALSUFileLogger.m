#import "ALSUFileLogger.h"

@interface ALSUFileLogger()
{
    NSFileHandle *logFile;
    dispatch_queue_t serialQ;
}
@end

@implementation ALSUFileLogger

+(instancetype)sharedInstance
{
    static ALSUFileLogger *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self subscribeNotifications];
        serialQ = dispatch_queue_create("com.alsu.serialqueue", DISPATCH_QUEUE_SERIAL);
        NSString *filePath = [PathForCachesFolder() stringByAppendingPathComponent:@"application.log"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL shouldAppendInitData = NO;
        if (![fileManager fileExistsAtPath:filePath])
        {
            [fileManager createFileAtPath:filePath
                                 contents:nil
                               attributes:nil];
            shouldAppendInitData = YES;
        }
        logFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [logFile seekToEndOfFile];
        NSAssert(logFile, @"ALSUFileLogger NSFileHandle error");
        if (shouldAppendInitData)
        {
            [self log:devInfo()];
        }
    }
    return self;
}
- (void)dealloc
{
    [self unsubscribeNotifications];
}
#pragma mark - NSNotificationCenter
-(void)subscribeNotifications
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(applicationWillTerminateNotification:)
               name:UIApplicationWillTerminateNotification object:nil];
    [nc addObserver:self selector:@selector(applicationWillResignActiveNotification:)
               name:UIApplicationWillResignActiveNotification object:nil];
    [nc addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:)
               name:UIApplicationDidEnterBackgroundNotification object:nil];
    [nc addObserver:self selector:@selector(applicationWillEnterForegroundNotification:)
               name:UIApplicationWillEnterForegroundNotification object:nil];
    [nc addObserver:self selector:@selector(applicationDidBecomeActiveNotification:)
               name:UIApplicationDidBecomeActiveNotification object:nil];
    [nc addObserver:self selector:@selector(applicationDidFinishLaunchingNotification:)
               name:UIApplicationDidFinishLaunchingNotification object:nil];
}
-(void)unsubscribeNotifications
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [nc removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [nc removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [nc removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [nc removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [nc removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
}
#pragma mark - UIApplication NSNotifications
-(void)applicationWillResignActiveNotification:(NSNotification*)notification
{
    [self saveFile];
}
-(void)applicationWillEnterForegroundNotification:(NSNotification*)notification
{
    DLog(@"");
}
-(void)applicationDidBecomeActiveNotification:(NSNotification*)notification
{
    DLog(@"");
}
-(void)applicationDidEnterBackgroundNotification:(NSNotification*)notification
{
    DLog(@"");
}
-(void)applicationWillTerminateNotification:(NSNotification*)notification
{
    DLog(@"");
}
-(void)applicationDidFinishLaunchingNotification:(NSNotification*)notification
{
    DLog(@"");
}
- (void)log:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    __block NSString *message = [[NSString alloc] initWithFormat:format arguments:ap];
    dispatch_async(serialQ, ^{
        [[NSThread currentThread] setName:NSStringFromClass([self class])];
#if defined DEBUG
        NSLog(@"%@", message);
#endif
        [logFile writeData:[[[NSString stringWithFormat:@"%@ >> %@", [NSDate date], message] stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [logFile synchronizeFile];
    });
}

#pragma mark - file handling
- (void)closeFile
{
    if (logFile!= nil)
    {
        [logFile closeFile];
        logFile= nil;
    }
}
- (void)saveFile
{
    [logFile synchronizeFile];
    [self closeFile];
}

@end