//
//  ViewController.m
//  DragMove
//
//  Created by Joey L. on 3/12/15.
//  Copyright (c) 2015 Joey L, All rights reserved.
//

#import "ViewController.h"
#import "JLArrangeController.h"

@interface ViewController () <JLArrangeControllerDelegate>

@property (strong, nonatomic) JLArrangeController *arrangeController;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrangeViews;

@end

@implementation ViewController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrangeController = [[JLArrangeController alloc] initWithArrangeViews:self.arrangeViews delegate:self];
}

#pragma mark - JLArrangeControllerDelegate

- (void)arrangeControllerDidRearrangeViews:(NSArray *)arrangeViews
{
    NSLog(@"did change!");
}

@end
