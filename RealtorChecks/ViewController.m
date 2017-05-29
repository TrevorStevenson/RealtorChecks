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

@interface ViewController ()
{
    //UI elements
    UILabel *titleLabel;
    UILabel *subLabel;
    UIButton *photoButton;
    UIButton *myChecksButton;
    
    //image to send to destination view controller
    UIImage *img;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    
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
    //if camera is available, open camera UI
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *IVC = [[UIImagePickerController alloc] init];
        IVC.delegate = self;
        IVC.allowsEditing = YES;
        IVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:IVC animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No camera available." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)showTutorial:(id)sender {
}

@end
