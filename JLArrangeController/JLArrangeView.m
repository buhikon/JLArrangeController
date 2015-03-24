//
//  JLArrangeView.m
//
//  Created by Joey L. on 3/24/15.
//  Copyright 2015 Joey L. All rights reserved.
//  https://github.com/buhikon/JLArrangeController
//  v 1.0

#import "JLArrangeView.h"

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

typedef enum {
    JLArrangeViewShakeAnimationStateNormal,
    JLArrangeViewShakeAnimationStateNormalToRight,  // 가운데 (다음 동작은 오른쪽)
    JLArrangeViewShakeAnimationStateNormalToLeft,   // 가운데 (다음 동작은 왼쪽)
    JLArrangeViewShakeAnimationStateLeft,
    JLArrangeViewShakeAnimationStateRight
} JLArrangeViewShakeAnimationState;



@interface JLArrangeView ()
{
    BOOL _shouldStopShakeEffect;
    CGFloat _currentScale;
}

@property (assign, nonatomic) JLArrangeViewShakeAnimationState shakeAnimationState;

@end

@implementation JLArrangeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - accessor

- (void)setShakeMode:(BOOL)shakeMode
{
    if(_shakeMode != shakeMode) {
        _shakeMode = shakeMode;
        
        if(shakeMode) {
            self.animationView.userInteractionEnabled = NO;
            [self startShakeAnimation];
        }
        else {
            self.animationView.userInteractionEnabled = YES;
            [self stopShakeAnimation];
        }
    }
}

- (void)setHighlightedForDrag:(BOOL)highlightedForDrag
{
    if(_highlightedForDrag != highlightedForDrag) {
        _highlightedForDrag = highlightedForDrag;
        
        if(highlightedForDrag) {
            [self startSelectAnimation];
        }
        else {
            [self stopSelectAnimation];
        }
    }
}

#pragma mark - private methods

- (void)initialize
{
    _shakeAnimationDuration = 0.1;
    _shakeAnimationAngle = 5.0;
    _highlightScale = 1.1;
    _currentScale = 1.0;
    _shakeMode = NO;
    _highlightedForDrag = NO;
    _shakeAnimationState = JLArrangeViewShakeAnimationStateNormal;
}

- (void)startSelectAnimation
{
    _currentScale = 1.1;
    self.animationView.transform = CGAffineTransformMakeScale(_currentScale, _currentScale);
    self.animationView.alpha = 0.5;
}
- (void)stopSelectAnimation
{
    _currentScale = 1.0;
    self.animationView.transform = CGAffineTransformMakeScale(_currentScale, _currentScale);
    self.animationView.alpha = 1.0;
    
}
- (void)startShakeAnimation
{
    _shouldStopShakeEffect = NO;
    [self goToNextShakeMode];

}
- (void)stopShakeAnimation
{
    _shouldStopShakeEffect = YES;
}

- (void)setShakeAnimationState:(JLArrangeViewShakeAnimationState)shakeAnimationState animated:(BOOL)animated completion:(void(^)(void))completion
{
    self.shakeAnimationState = shakeAnimationState;
    
    
    CGFloat angle = 0.0;
    
    switch (shakeAnimationState) {
        case JLArrangeViewShakeAnimationStateNormal:
        case JLArrangeViewShakeAnimationStateNormalToRight:
        case JLArrangeViewShakeAnimationStateNormalToLeft:
            angle = 0.0;
            break;
        case JLArrangeViewShakeAnimationStateLeft:
            angle = ABS(self.shakeAnimationAngle) * (-1.0);
            break;
        case JLArrangeViewShakeAnimationStateRight:
            angle = ABS(self.shakeAnimationAngle);
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:animated ? self.shakeAnimationDuration * ((rand()%21-10)*0.01+1.0): 0.0
                     animations:^{
                         CATransform3D t = CATransform3DIdentity;
                         t = CATransform3DScale(t, _currentScale, _currentScale, _currentScale);
                         t = CATransform3DRotate(t, M_PI * angle / 180.0, 0, 0, 1);
                         self.animationView.layer.transform = t;
                     }
                     completion:^(BOOL finished) {
                         if(completion) completion();
                     }];
}


- (void)goToNextShakeMode
{
    if(_shouldStopShakeEffect) {
        [self setShakeAnimationState:JLArrangeViewShakeAnimationStateNormal animated:YES completion:nil];
        return;
    }
    
    
    JLArrangeViewShakeAnimationState nextAnimation = 0;
    
    switch (self.shakeAnimationState) {
        case JLArrangeViewShakeAnimationStateNormal:
            nextAnimation = JLArrangeViewShakeAnimationStateLeft;
            break;
        case JLArrangeViewShakeAnimationStateNormalToRight:
            nextAnimation = JLArrangeViewShakeAnimationStateRight;
            break;
        case JLArrangeViewShakeAnimationStateNormalToLeft:
            nextAnimation = JLArrangeViewShakeAnimationStateLeft;
            break;
        case JLArrangeViewShakeAnimationStateLeft:
            nextAnimation = JLArrangeViewShakeAnimationStateNormalToRight;
            break;
        case JLArrangeViewShakeAnimationStateRight:
            nextAnimation = JLArrangeViewShakeAnimationStateNormalToLeft;
            break;
        default:
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    [self setShakeAnimationState:nextAnimation animated:YES completion:^(void){
        [weakSelf performSelector:@selector(goToNextShakeMode) withObject:nil afterDelay:0.001];
    }];
    
    
}


#pragma mark - public methods



@end
