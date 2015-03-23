JLArrangeController
======================

Rearrange icons, images or any views as you want.



## Usage

Copy `JLArrangeController.h` and `JLArrangeController.m` to your project. 

Just use it like below:

```
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

- (void)arrangeControllerDidRearrangeViews:(NSArray *)rearrangedViews
                             originalViews:(NSArray *)originalViews
                                 fromIndex:(NSInteger)fromIndex
                                   toIndex:(NSInteger)toIndex
{
    NSLog(@"did change!");
}

@end

```

[![](https://raw.github.com/buhikon/JLArrangeController/master/demo.gif)](https://raw.github.com/buhikon/JLArrangeController/master/demo.gif)


## License

Licensed under the MIT license. You can use the code in your commercial and non-commercial projects.
