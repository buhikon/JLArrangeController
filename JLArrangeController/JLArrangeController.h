//
//  JLArrangeController.h
//
//  Created by Joey L. on 3/12/15.
//  Copyright 2015 Joey L. All rights reserved.
//  https://github.com/buhikon/JLArrangeController
//  v 1.0
//
// [사용법]
// 1. UIView(superview) 생성 후, 안에 UIView를 여러개 생성해 놓는다.
// 2. initWithArrangeViews:delegate:를 호출해서 초기화
// 3. delegate로 응답을 받아 본다.
// * 중간에 arrangeViews가 변경되면 resetArrangeViews를 호출
//
// [주의]
// - 이동하는 뷰들의 크기(size)는 같아야 한다.
// - 가로만 사용 가능 (세로는 차후 개발?)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JLArrangeView.h"

@protocol JLArrangeControllerDelegate

- (void)arrangeControllerDidStartEditMode;
- (void)arrangeControllerDidFinishEditMode;

- (void)arrangeControllerDidRearrangeViews:(NSArray *)rearrangedViews
                             originalViews:(NSArray *)originalViews
                                 fromIndex:(NSInteger)fromIndex
                                   toIndex:(NSInteger)toIndex;
@end

@interface JLArrangeController : NSObject

@property (weak, nonatomic) id<JLArrangeControllerDelegate> delegate; // weak reference
@property (assign, nonatomic, getter=isEditMode) BOOL editMode;

- (instancetype)initWithArrangeViews:(NSArray *)arrangeViews delegate:(id<JLArrangeControllerDelegate>)delegate;

// call this when arrangeViews are changed.
- (void)resetArrangeViews:(NSArray *)arrangeViews;


@end
