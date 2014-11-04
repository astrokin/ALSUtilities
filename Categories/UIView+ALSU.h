#import <UIKit/UIKit.h>

@interface UIView (ALSU)

-(void)bounce:(float)bounceFactor;
-(void)lockAnimation;
-(void)singleScaleAnimationWithDelegate:(id)delegate;
-(void)dropAnimationToPoint:(CGFloat)center;
-(void)showWithShrinkAnimation:(CGFloat)center;
-(void)dismissWithShrinkAnimation;

@end
