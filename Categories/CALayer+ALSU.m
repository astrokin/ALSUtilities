#import "CALayer+ALSU.h"

@implementation CALayer (ALSU)

-(void)singleScaleLayerAnimation
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.18f;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.3f];
    [self addAnimation:scaleAnimation forKey:@"scale"];
}
-(void)singleScaleInvertLayerAnimation
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.18f;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.8f];
    [self addAnimation:scaleAnimation forKey:@"scale"];
}

@end
