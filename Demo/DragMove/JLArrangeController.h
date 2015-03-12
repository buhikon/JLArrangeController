//
//  JLArrangeController.h
//  DragMove
//
//  Created by Joey L. on 3/12/15.
//  Copyright 2015 Joey L. All rights reserved.
//  https://github.com/buhikon/JLArrangeController
//  v 1.0
//
// [사용법]
// 1. UIView(superview) 생성 후, 안에 UIView를 여러개 생성해 놓는다.
// 2. initWithArrangeViews:delegate:를 호출해서 초기화
// 3. 순서 변경이 있으면 delegate로 응답이 온다.
// (참고)초기화 전에 view에 tag값을 미리 넣어 놓으면, 이 후 로직(e.g. 관련 DATA 변경)시 도움이 된다.
//
// [주의]
// - 이동하는 뷰들의 크기(size)는 같아야 한다.
// - 가로만 사용 가능 (세로는 차후 개발?)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol JLArrangeControllerDelegate

- (void)arrangeControllerDidRearrangeViews:(NSArray *)arrangeViews;

@end


@interface JLArrangeController : NSObject

@property (weak, nonatomic) id<JLArrangeControllerDelegate> delegate; // weak reference

- (instancetype)initWithArrangeViews:(NSArray *)arrangeViews delegate:(id<JLArrangeControllerDelegate>)delegate;

@end
