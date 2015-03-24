//
//  ViewController.m
//  DragMove
//
//  Created by Joey L. on 3/12/15.
//  Copyright (c) 2015 Joey L, All rights reserved.
//

#import "ViewController.h"
#import "JLArrangeController.h"
#import "MyView.h"

@interface ViewController () <JLArrangeControllerDelegate>

@property (strong, nonatomic) JLArrangeController *arrangeController;
@property (strong, nonatomic) IBOutletCollection(MyView) NSArray *arrangeViews;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (assign, nonatomic) BOOL editMode;

@end

@implementation ViewController

- (void)setEditMode:(BOOL)editMode
{
    if(_editMode != editMode) {
        _editMode = editMode;
        
        if(editMode) {
            self.editButton.alpha = 0.0;
            self.doneButton.alpha = 1.0;
        }
        else {
            self.editButton.alpha = 1.0;
            self.doneButton.alpha = 0.0;
        }
    }
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.editMode = NO;
    self.editButton.alpha = 1.0;
    self.doneButton.alpha = 0.0;
    
    self.arrangeController = [[JLArrangeController alloc] initWithArrangeViews:self.arrangeViews delegate:self];
}

#pragma mark - IBAction

- (IBAction)editButtonTapped:(id)sender {
    self.editMode = YES;
    self.arrangeController.editMode = YES;
}
- (IBAction)doneButtonTapped:(id)sender {
    self.editMode = NO;
    self.arrangeController.editMode = NO;
}

#pragma mark - JLArrangeControllerDelegate

- (void)arrangeControllerDidStartEditMode
{
    self.editMode = YES;
}
- (void)arrangeControllerDidFinishEditMode
{
    self.editMode = NO;
}

- (void)arrangeControllerDidRearrangeViews:(NSArray *)rearrangedViews
                             originalViews:(NSArray *)originalViews
                                 fromIndex:(NSInteger)fromIndex
                                   toIndex:(NSInteger)toIndex
{
    NSLog(@"did change!");
}

@end
