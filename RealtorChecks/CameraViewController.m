//
//  CameraViewController.m
//  RealtorChecks
//
//  Created by Trevor Stevenson on 6/27/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import "CameraViewController.h"
#import "IPDFCameraViewController.h"
#import "PhotoViewController.h"

@interface CameraViewController ()

@property (weak, nonatomic) IBOutlet IPDFCameraViewController *cameraView;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;

@end

@implementation CameraViewController
{
    UIButton *useButton;
    UIButton *retakeButton;
    UIImageView *captureImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.cameraView setupCameraView];
    [self.cameraView setEnableBorderDetection:YES];
    [self.cameraView setCameraViewType:IPDFCameraViewTypeNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.cameraView start];
}

- (void)dismissPreview:(UITapGestureRecognizer *)dismissTap
{
    [self.cameraView start];
    
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
         dismissTap.view.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
        
     } completion:^(BOOL finished) {
         
         [dismissTap.view removeFromSuperview];
         
     }];
}

- (void)usePhoto
{
    [self performSegueWithIdentifier:@"usePhoto" sender:self];
}

- (void)retakePhoto
{
    [self.cameraView start];
    self.captureButton.hidden = NO;
    
    [UIView animateWithDuration:1.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        captureImageView.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
        useButton.frame = CGRectOffset(useButton.frame, 0, self.view.bounds.size.height);
        retakeButton.frame = CGRectOffset(retakeButton.frame, 0, self.view.bounds.size.height);

    } completion:^(BOOL finished) {
        
        [captureImageView removeFromSuperview];
        
    }];
}

- (IBAction)takePhoto:(id)sender
{
    self.captureButton.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [self.cameraView captureImageWithCompletionHander:^(UIImage *imageFilePath) {
        
        [self.cameraView stop];
        
        captureImageView = [[UIImageView alloc] initWithImage:imageFilePath];
        captureImageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        captureImageView.frame = CGRectOffset(weakSelf.view.bounds, 0, -weakSelf.view.bounds.size.height);
        captureImageView.alpha = 1.0;
        captureImageView.contentMode = UIViewContentModeScaleAspectFit;
        captureImageView.userInteractionEnabled = YES;
        [weakSelf.view addSubview:captureImageView];
        
        int separator = (weakSelf.view.bounds.size.width - 2 * 100) / 3;
        
        useButton = [[UIButton alloc] initWithFrame:CGRectMake(separator, weakSelf.view.bounds.size.height, 100, 40)];
        [useButton setBackgroundImage:[UIImage imageNamed:@"useButton"] forState:UIControlStateNormal];
        [useButton addTarget:self action:@selector(usePhoto) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.view addSubview:useButton];
        
        retakeButton = [[UIButton alloc] initWithFrame:CGRectMake(2 * separator + 100, weakSelf.view.bounds.size.height, 100, 40)];
        [retakeButton setBackgroundImage:[UIImage imageNamed:@"retakeButton"] forState:UIControlStateNormal];
        [retakeButton addTarget:self action:@selector(retakePhoto) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.view addSubview:retakeButton];
        
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.7 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            captureImageView.frame = weakSelf.view.bounds;
            useButton.frame = CGRectOffset(useButton.frame, 0, -80);
            retakeButton.frame = CGRectOffset(retakeButton.frame, 0, -80);

        } completion:nil];
        
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"usePhoto"])
    {
        PhotoViewController *PVC = (PhotoViewController *)segue.destinationViewController;
        PVC.myImage = captureImageView.image;
    }
}

@end
