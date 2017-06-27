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
    
}

@property NSUInteger currentIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    tutorialImages = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"screen1"], nil];
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No camera available." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)showTutorial:(id)sender {
    
    UIPageViewController *PVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    TutorialScreenViewController *TSVC = (TutorialScreenViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Tutorial"];
    [PVC setViewControllers:@[TSVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    PVC.delegate = self;
    PVC.dataSource = self;
    self.currentIndex = 0;
    [self.navigationController showViewController:PVC sender:self];
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.currentIndex == 0) return nil;
    
    TutorialScreenViewController *TSVC = (TutorialScreenViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Tutorial"];
    TSVC.imgView.image = tutorialImages[self.currentIndex - 1];
    self.currentIndex--;
    return TSVC;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.currentIndex == tutorialImages.count) return nil;
    
    TutorialScreenViewController *TSVC = (TutorialScreenViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Tutorial"];
    TSVC.imgView.image = tutorialImages[self.currentIndex + 1];
    self.currentIndex++;
    return TSVC;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return tutorialImages.count;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
