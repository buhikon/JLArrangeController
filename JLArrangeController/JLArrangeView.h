//
//  JLArrangeView.h
//
//  Created by Joey L. on 3/24/15.
//  Copyright 2015 Joey L. All rights reserved.
//  https://github.com/buhikon/JLArrangeController
//  v 1.0

#import <UIKit/UIKit.h>


@interface JLArrangeView : UIView

/*!
 * @property userInfo
 * @abstract set any data you want.
 */
@property (strong, nonatomic) id userInfo;


/*!
 * @property animationView
 * @abstract this view will be animated when user drag or JLArrangeController become edit mode. Be careful of that this view will ignore user event when self.shakeMode is set to YES.
 */
@property (weak, nonatomic) IBOutlet UIView *animationView;

@property (assign, nonatomic, getter=isShakeMode) BOOL shakeMode;
@property (assign, nonatomic, getter=isHighlightedForDrag) BOOL highlightedForDrag;


@property (assign, nonatomic) CGFloat shakeAnimationDuration;   // default : 0.1
@property (assign, nonatomic) CGFloat shakeAnimationAngle;      // default : 5.0
@property (assign ,nonatomic) CGFloat highlightScale;           // default : 1.1

@end
