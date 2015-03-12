//
//  JLArrangeController.m
//  DragMove
//
//  Created by Joey L. on 3/12/15.
//  Copyright 2015 Joey L. All rights reserved.
//  https://github.com/buhikon/JLArrangeController
//  v 1.0

#import "JLArrangeController.h"

@interface JLArrangeController ()
{
    NSInteger _startIndex;
    NSInteger _currentIndex;
}
@property (strong, nonatomic) NSMutableArray *arrangeViews;
@property (strong, nonatomic) NSArray *arrangeViewsOriginal; // 최초 들어온 값을 그대로 기억한다. (순서 변경 여부를 판별하기 위하여)

@property (strong, nonatomic) NSMutableArray *originOfArrangeView;  // origin값을 기억한다. (snap시 이 값이 사용 된다.)

// arrangeViews들 사이의 가운데 좌표(경계)를 기록해 놓는다. n개가 있다면 여기에는 n-1개가 기록 된다. (index 구할 때 이 값이 사용 된다.)
@property (strong, nonatomic) NSMutableArray *borderOfArrangeView;

@end

@implementation JLArrangeController

#pragma mark - accessor

- (NSMutableArray *)arrangeViews
{
    if(!_arrangeViews) {
        _arrangeViews = [[NSMutableArray alloc] init];
    }
    return _arrangeViews;
}

- (NSMutableArray *)originOfArrangeView
{
    if(!_originOfArrangeView) {
        _originOfArrangeView = [[NSMutableArray alloc] init];
    }
    return _originOfArrangeView;
    
}
- (NSMutableArray *)borderOfArrangeView
{
    if(!_borderOfArrangeView) {
        _borderOfArrangeView = [[NSMutableArray alloc] init];
    }
    return _borderOfArrangeView;
}

#pragma mark =

- (instancetype)initWithArrangeViews:(NSArray *)arrangeViews delegate:(id<JLArrangeControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        
        // (소스 가독성을 위해 for문을 여러번 돌림)
        
        [self.arrangeViews addObjectsFromArray:arrangeViews];
        self.arrangeViewsOriginal = [NSArray arrayWithArray:arrangeViews];
        self.delegate = delegate;
        
        // sort
        [self.arrangeViews sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            UIView *view1 = obj1;
            UIView *view2 = obj2;
            
            if(view1.frame.origin.x < view2.frame.origin.x)
                return NSOrderedAscending;
            else if(view1.frame.origin.x > view2.frame.origin.x)
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        }];
        
        // set origin of arrange view
        for(UIView *arrangeView in arrangeViews) {
            [self.originOfArrangeView addObject:[NSValue valueWithCGPoint:arrangeView.frame.origin]];
        }
        
        // set border of arrange view
        for(NSInteger i=0; i<self.arrangeViews.count-1; i++) {
            UIView *leftView = self.arrangeViews[i];
            UIView *rightView = self.arrangeViews[i+1];
            
            CGFloat leftCenterX = leftView.frame.origin.x + leftView.frame.size.width * 0.5;
            CGFloat rightCenterX = rightView.frame.origin.x + rightView.frame.size.width * 0.5;
            CGFloat centerX = (leftCenterX + rightCenterX) / 2.0;
            
            [self.borderOfArrangeView addObject:@(centerX)];
        }
        
        // add gesture recognizer
        for(UIView *arrangeView in arrangeViews) {
            UILongPressGestureRecognizer *longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(arrangeViewDidMove:)];
            [arrangeView addGestureRecognizer:longGestureRecognizer];
        }
        


    }
    return self;
}

#pragma mark - private methods

- (void)animateStartForView:(UIView *)arrangeView
{
    arrangeView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    arrangeView.alpha = 0.5;
}

- (void)animateFinishForView:(UIView *)arrangeView
{
    arrangeView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    arrangeView.alpha = 1.0;
}

- (NSInteger)indexForView:(UIView *)arrangeView
{
    CGFloat centerX = arrangeView.frame.origin.x + arrangeView.frame.size.width * 0.5;
    
    NSInteger index = self.arrangeViews.count-1;
    
    for(NSInteger i=0; i<self.borderOfArrangeView.count; i++) {
        CGFloat borderX = [self.borderOfArrangeView[i] floatValue];
        if(centerX < borderX) {
            index = i;
            break;
        }
    }
    
    return index;
}

- (void)moveViewFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    if(fromIndex == toIndex) return;
    
    // move data
    UIView *arrangeView = self.arrangeViews[fromIndex];
    [self.arrangeViews removeObjectAtIndex:fromIndex];
    if(toIndex < self.arrangeViews.count) {
        [self.arrangeViews insertObject:arrangeView atIndex:toIndex];
    }
    else {
        [self.arrangeViews addObject:arrangeView];
    }
    
    // change origin of arrange views
    [self snapViewsWithCurrentView:arrangeView];
}

- (void)snapViewsWithCurrentView:(UIView *)currentViewBeingMoved
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         for(NSInteger i=0; i<self.arrangeViews.count; i++) {
                             UIView *viewToMove = self.arrangeViews[i];
                             if(viewToMove == currentViewBeingMoved) continue; // 현재 이동중인 뷰는 제외
                             
                             CGRect frame = viewToMove.frame;
                             frame.origin = [self.originOfArrangeView[i] CGPointValue];
                             viewToMove.frame = frame;
                         }
                         
                     }
                     completion:nil];
}

- (BOOL)wasArrangeViewMoved
{
    BOOL result = NO;
    
    @try {
        for(NSInteger i=0; i<self.arrangeViews.count; i++) {
            UIView *view1 = self.arrangeViews[i];
            UIView *view2 = self.arrangeViewsOriginal[i];
            
            if(view1 != view2) {
                result = YES;
                break;
            }
        }
    }
    @catch (NSException *exception) {}
    
    return result;
}

#pragma mark - event

- (void)arrangeViewDidMove:(UILongPressGestureRecognizer *)longGestureRecognizer
{
    UIView *arrangeView = longGestureRecognizer.view;
    NSInteger index = [self indexForView:arrangeView];
    
    switch (longGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self animateStartForView:arrangeView];
            _startIndex = index;
            _currentIndex = index;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            // move view
            CGPoint touchLocation = [longGestureRecognizer locationInView:arrangeView.superview];
            CGPoint p = arrangeView.center;
            p.x = touchLocation.x;
            arrangeView.center = p;
            
            // animate
            if(_currentIndex != index) {
                [self moveViewFrom:_currentIndex to:index];
                _currentIndex = index;
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self animateFinishForView:arrangeView];
            [self snapViewsWithCurrentView:nil];
            
            // 순서 변경이 되었으면 delegate에 통보하고, 판별 기준값(self.arrangeViewsOriginal)을 리셋한다.
            if([self wasArrangeViewMoved]) {
                [self.delegate arrangeControllerDidRearrangeViews:self.arrangeViews];
                self.arrangeViewsOriginal = [NSArray arrayWithArray:self.arrangeViews]; //
            }
            break;
        }
        default:
            break;
    }
}

@end
