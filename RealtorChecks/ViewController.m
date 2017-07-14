//
//  ViewController.m
//  RealtorChecks
//
//  Created by Trevor Stevenson on 5/7/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import "ViewController.h"
#import "ChecksViewController.h"
#import "PhotoViewController.h"
#import "TutorialScreenViewController.h"

@interface ViewController ()
{
    //UI elements
    UILabel *titleLabel;
    UILabel *subLabel;
    UIButton *photoButton;
    UIButton *myChecksButton;
    
    //image to send to destination view controller
    UIImage *img;
    
    //tutorial images
    NSMutableArray *tutorialImages;
    
    NSMutableArray *viewControllers;
}

@property NSUInteger currentIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    viewControllers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 7; i++)
    {
        TutorialScreenViewController *VC = (TutorialScreenViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Tutorial"];
        VC.currentIndex = i;
        [viewControllers addObject:VC];
    }
    
    tutorialImages = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"Tutorial 1"], [UIImage imageNamed:@"Tutorial 2"], [UIImage imageNamed:@"Tutorial 3"], [UIImage imageNamed:@"Tutorial 4"], [UIImage imageNamed:@"Tutorial 5"], [UIImage imageNamed:@"Tutorial 6"], [UIImage imageNamed:@"Tutorial 7"], nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //when done taking photo, go to PhotoViewController and send image to controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    img = info[UIImagePickerControllerEditedImage];
    
    PhotoViewController *PVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PVC"];
    
    PVC.myImage = img;
    
    [self.navigationController showViewController:PVC sender:self];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //dismiss camera if canceled
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showMyChecks:(id)sender
{
    //go to TableViewController to show previous checks
    ChecksViewController *CVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"CVC"];
    
    [self.navigationController showViewController:CVC sender:self];
}

- (IBAction)takePhoto:(id)sender
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.hidesWhenStopped = YES;
    UIView *loadingView = [[UIView alloc] init];
    indicator.center = self.view.center;
    loadingView.frame = UIEdgeInsetsInsetRect(indicator.frame, UIEdgeInsetsMake(-10, -10, -10, -10));
    loadingView.layer.masksToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
    loadingView.backgroundColor = [UIColor blackColor];
    indicator.center = loadingView.center;
    [self.view addSubview:loadingView];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    //if camera is available, open camera UI
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *IVC = [[UIImagePickerController alloc] init];
        IVC.delegate = self;
        IVC.allowsEditing = YES;
        IVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:IVC animated:YES completion:^{
            
            [loadingView removeFromSuperview];
            [indicator stopAnimating];
            
        }];
    }
    else
    {
        [loadingView removeFromSuperview];
        [indicator stopAnimating];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No camera available." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (NSUInteger)indexOfViewController:(UIViewController *)VC
{
    TutorialScreenViewController *TVC = (TutorialScreenViewController *) VC;
    return TVC.currentIndex;
}

- (IBAction)showTutorial:(id)sender {
    
    UIPageViewController *PVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    PVC.view.backgroundColor = [UIColor blackColor];
    PVC.delegate = self;
    PVC.dataSource = self;
    self.currentIndex = 0;
    
    TutorialScreenViewController *TSVC = (TutorialScreenViewController *) [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Tutorial"];
    TSVC.currentIndex = 0;
    [PVC setViewControllers:@[viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self presentViewController:PVC animated:YES completion:nil];    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == 0) return nil;
    index--;
    return viewControllers[index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == 6) return nil;
    index++;
    return viewControllers[index];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 7;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
