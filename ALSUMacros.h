//
//  ALSUMacros.h
//  SecureSpace
//
//  Created by Alexey Strokin on 11/10/14.
//  Copyright (c) 2014 ALPEIN Software LTD. All rights reserved.
//


#define IS_IOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height > 480)
#define IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

/*Logging*/
////////////////////////////////////////////////////////////////////////////////
#	define DLog(fmt, ...) \
{\
NSMutableString *__log_str__ = [[NSMutableString alloc]\
initWithFormat:fmt, ##__VA_ARGS__];\
[[ALSUFileLogger sharedInstance] log:[NSString stringWithFormat:@"\r%s %s", __PRETTY_FUNCTION__, [__log_str__ UTF8String]]];\
}

/*Concurrency*/
////////////////////////////////////////////////////////////////////////////////
#define dispatch_background_queue \
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)

#define dispatch_in_background(__dispatch_block__) \
dispatch_async(dispatch_background_queue, __dispatch_block__)

#define dispatch_in_main(__dispatch_block__) \
dispatch_async(dispatch_get_main_queue(), (__dispatch_block__))

#define AssertMain NSAssert([[NSThread currentThread] \
isEqual:[NSThread mainThread]], \
@"threading is going wrong, expected that this is main")
////////////////////////////////////////////////////////////////////////////////

/*Localizations*/
////////////////////////////////////////////////////////////////////////////////
#define STR(x) NSLocalizedString(x, nil)
