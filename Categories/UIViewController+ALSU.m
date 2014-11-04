#import "UIViewController+ALSU.h"
#import <objc/runtime.h>

@implementation UIViewController (ALSU)

+ (void)load
{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(swizzled_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod)
        {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else
        {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling
- (void)swizzled_viewWillAppear:(BOOL)animated
{
    [self swizzled_viewWillAppear:animated];
#ifndef DEBUG
    DLog(@"viewWillAppear: %@", self);
#endif
}

@end
