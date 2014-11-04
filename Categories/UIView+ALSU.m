#import "UIView+ALSU.h"

@implementation UIView (ALSU)

+ (CAKeyframeAnimation*)dockBounceAnimationWithViewHeight:(CGFloat)viewHeight
{
    NSUInteger const kNumFactors    = 22;
    CGFloat const kFactorsPerSec    = 30.0f;
    CGFloat const kFactorsMaxValue  = 128.0f;
    CGFloat factors[kNumFactors]    = {0,  60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32, 0, 0, 18, 28, 32, 28, 18, 0};
    NSMutableArray* transforms = [NSMutableArray array];
    for(NSUInteger i = 0; i < kNumFactors; i++)
    {
        CGFloat positionOffset  = factors[i] / kFactorsMaxValue * viewHeight;
        CATransform3D transform = CATransform3DMakeTranslation(0.0f, -positionOffset, 0.0f);
        [transforms addObject:[NSValue valueWithCATransform3D:transform]];
    }
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.repeatCount           = 1;
    animation.duration              = kNumFactors * 1.0f/kFactorsPerSec;
    animation.fillMode              = kCAFillModeForwards;
    animation.values                = transforms;
    animation.removedOnCompletion   = YES; // final stage is equal to starting stage
    animation.autoreverses          = NO;
    return animation;
}
- (void)bounce:(float)bounceFactor
{
    CGFloat midHeight = self.frame.size.height * bounceFactor;
    CAKeyframeAnimation* animation = [[self class] dockBounceAnimationWithViewHeight:midHeight];
    [self.layer addAnimation:animation forKey:@"bouncing"];
}
-(void)lockAnimation
{
    CALayer *lbl = [self layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.1];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}
-(void)singleScaleAnimationWithDelegate:(id)delegate
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.35f;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.3f];
    scaleAnimation.delegate = delegate;
    [self.layer addAnimation:scaleAnimation forKey:@"scale"];
}
////////////////////////////////////////////////////////////////////////////////
-(void)dropAnimationToPoint:(CGFloat)center
{
    self.layer.anchorPoint = CGPointMake(0.5f, 0.f);
    
    CGPoint newCenter = CGPointMake(self.bounds.size.width/2, center);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    {
        self.center = CGPointMake(newCenter.x, -CGRectGetHeight(self.frame));
        self.layer.opacity = 1.f;
        
        [self _executeShowAnimation:[self _dropAnimationIn:newCenter]];
    }
    [CATransaction commit];
}
- (void)_executeShowAnimation:(CAAnimation *)animation
{
    [animation setValue:@"mm-progress-hud-present-animation" forKey:@"name"];
    [CATransaction begin];
    [self.layer addAnimation:animation forKey:@"show"];
    [CATransaction commit];
}
- (void)_executeDismissAnimation:(CAAnimation *)animation
{
    [animation setValue:@"mm-progress-hud-dismiss-animation" forKey:@"name"];
    [CATransaction begin];
    [self.layer addAnimation:animation forKey:@"dismiss"];
    [CATransaction commit];
}
- (CAAnimation *)_dropAnimationIn:(CGPoint)center
{
    CGFloat initialAngle = M_2_PI/10.f + arc4random_uniform(1000)/1000.f*M_2_PI/5.f;
    CGPoint newCenter = center;
    
    CAKeyframeAnimation *dropInAnimation = [self _dropInAnimationPositionAnimationWithCenter:newCenter];
    CAKeyframeAnimation *rotationAnimation = [self _dropInAnimationRotationAnimationWithInitialAngle:initialAngle
                                                                                            keyTimes:dropInAnimation.keyTimes];
    
    CAAnimationGroup *showAnimation = [CAAnimationGroup animation];
    showAnimation.animations = @[dropInAnimation, rotationAnimation];
    showAnimation.duration = 0.6f;
    
    [self _executeShowAnimation:showAnimation];
    
    self.layer.position = newCenter;
    self.layer.transform = CATransform3DIdentity;
    
    return showAnimation;
}
- (CAKeyframeAnimation *)_dropInAnimationPositionAnimationWithCenter:(CGPoint)newCenter {
    CAKeyframeAnimation *dropInPositionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.center.x, self.center.y);
    CGPathAddLineToPoint(path, NULL, newCenter.x - 10.f, newCenter.y - 2.f);
    CGPathAddCurveToPoint(path, NULL,
                          newCenter.x, newCenter.y - 10.f,
                          newCenter.x + 10.f, newCenter.y - 10.f,
                          newCenter.x + 5.f, newCenter.y - 2.f);
    CGPathAddCurveToPoint(path, NULL,
                          newCenter.x + 7, newCenter.y - 7.f,
                          newCenter.x, newCenter.y - 7.f,
                          newCenter.x - 3.f, newCenter.y);
    CGPathAddCurveToPoint(path, NULL,
                          newCenter.x, newCenter.y - 4.f,
                          newCenter.x , newCenter.y - 4.f,
                          newCenter.x, newCenter.y);
    
    dropInPositionAnimation.path = path;
    dropInPositionAnimation.calculationMode = kCAAnimationCubic;
    dropInPositionAnimation.keyTimes = @[@0.0f,
                                         @0.25f,
                                         @0.35f,
                                         @0.55f,
                                         @0.7f,
                                         @1.0f];
    dropInPositionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CGPathRelease(path);
    
    return dropInPositionAnimation;
}
- (CAKeyframeAnimation *)_dropInAnimationRotationAnimationWithInitialAngle:(CGFloat)initialAngle keyTimes:(NSArray *)keyTimes {
    CAKeyframeAnimation *rotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.values = @[@(initialAngle),
                        @(-initialAngle * 0.85),
                        @(initialAngle * 0.6),
                        @(-initialAngle * 0.3),
                        @0.f];
    rotation.calculationMode = kCAAnimationCubic;
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotation.keyTimes = keyTimes;
    
    return rotation;
}
-(void)showWithShrinkAnimation:(CGFloat)center
{
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.layer.position = CGPointMake(self.bounds.size.width/2, center);
    self.alpha = 0.f;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    {
        self.layer.transform = CATransform3DIdentity;
        self.layer.opacity = 1.0f;
        
        [self _executeShowAnimation:[self _shrinkAnimation:YES animateOut:NO]];
    }
    [CATransaction commit];
}
-(void)dismissWithShrinkAnimation
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    {
        self.layer.transform = CATransform3DMakeScale(0.25, 0.25, 1.f);
        self.layer.opacity = 0.f;
        
        [self _executeDismissAnimation:[self _shrinkAnimation:YES animateOut:YES]];
    }
    [CATransaction commit];
}
- (CAAnimation *)_shrinkAnimation:(BOOL)shrink animateOut:(BOOL)fadeOut {
    CGFloat startingOpacity;// = fadeOut ? 1.0 : 0.f;
    CGFloat startingScale;// = shrink ? 0.25 : 1.0f;
    CGFloat endingOpacity;
    CGFloat endingScale;
    
    if (fadeOut) { //shrink & expand out
        startingOpacity = 1.f;
        startingScale = 1.f;
        endingOpacity = 0.f;
        
        if (shrink) {
            endingScale = 0.25f;
        }
        else {
            endingScale = 3.f;
        }
    }
    else {
        startingOpacity = 0.f;
        endingScale = 1.f;
        endingOpacity = 1.f;
        
        if (shrink) {//shrink in
            startingScale = 3.f;
        }
        else {//expand in
            startingScale = 0.25f;
        }
    }
    
    CAKeyframeAnimation *expand = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    if (fadeOut) {
        expand.keyTimes = @[@0.f,
                            @0.45f,
                            @1.0f];
        
        if (shrink) {
            expand.values = @[@(startingScale),
                              @(startingScale*1.2f),
                              @(endingScale)];
        }
        else {
            expand.values = @[@(startingScale),
                              @(startingScale*0.8f),
                              @(endingScale)];
        }
    }
    else {
        expand.keyTimes = @[@0.f,
                            @0.65f,
                            @0.80f,
                            @1.0f];
        
        if (shrink) {
            expand.values = @[@(startingScale),
                              @(endingScale*0.9f),
                              @(endingScale*1.1f),
                              @(endingScale)];
        }
        else {
            expand.values = @[@(startingScale),
                              @(endingScale*1.1f),
                              @(endingScale*0.9f),
                              @(endingScale)];
        }
    }
    
    expand.calculationMode = kCAAnimationCubic;
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = @(startingOpacity);
    fade.toValue = @(endingOpacity);
    fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[expand, fade];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animationGroup.duration = fadeOut ? 0.35f : 0.25f;
    
    return animationGroup;
}

@end
