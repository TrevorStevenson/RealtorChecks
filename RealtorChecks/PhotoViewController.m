//
//  PhotoViewController.m
//  RealtorChecks
//
//  Created by Trevor Stevenson on 5/7/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import "PhotoViewController.h"
#import "AppDelegate.h"
#import <CoreText/CoreText.h>
#import "PDFController.h"
#import "SendViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController
{
    int numPhotos;
    NSManagedObject *check;
    NSManagedObjectContext *context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //intialize with 1 photo
    numPhotos = 1;
    
    //set up core data stack for saving checks
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    context = delegate.persistentContainer.viewContext;
    NSEntityDescription *descrip = [NSEntityDescription entityForName:@"Checks" inManagedObjectContext:context];
    check = [[NSManagedObject alloc] initWithEntity:descrip insertIntoManagedObjectContext:context];

    self.imgView1.image = self.myImage;
    self.imgView1.layer.masksToBounds = YES;
    self.imgView1.layer.cornerRadius = 10.0;
    self.imgView2.hidden = YES;
    
    UIAlertController *checkTypeAlert = [UIAlertController alertControllerWithTitle:@"Check Type" message:@"What type of check is this?" preferredStyle:UIAlertControllerStyleAlert];
    
    [checkTypeAlert addAction:[UIAlertAction actionWithTitle:@"Due Diligence" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.checkType1 = @"Due Diligence";
        
    }]];
    
    [checkTypeAlert addAction:[UIAlertAction actionWithTitle:@"Escrow" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.checkType1 = @"Escrow";
        
    }]];
    
    [self presentViewController:checkTypeAlert animated:YES completion:nil];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


- (IBAction)addPhoto:(id)sender
{
    numPhotos++;
    
    self.addPhoto.hidden = YES;
    self.imgView2.hidden = NO;
    
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
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //when done taking photo, go to PhotoViewController and send image to controller
    self.img2 = info[UIImagePickerControllerEditedImage];
    self.imgView2.image = self.img2;
    self.imgView2.layer.masksToBounds = YES;
    self.imgView2.layer.cornerRadius = 10.0;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIAlertController *checkTypeAlert = [UIAlertController alertControllerWithTitle:@"Check Type" message:@"What type of check is this?" preferredStyle:UIAlertControllerStyleAlert];
    
    [checkTypeAlert addAction:[UIAlertAction actionWithTitle:@"Due Diligence" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.checkType2 = @"Due Diligence";
        
    }]];
    
    [checkTypeAlert addAction:[UIAlertAction actionWithTitle:@"Escrow" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.checkType2 = @"Escrow";
        
    }]];
    
    [self presentViewController:checkTypeAlert animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //dismiss camera if canceled
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length + range.location > textField.text.length) return NO;
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 33;
}

- (IBAction)saveChecks:(id)sender
{
    [check setValue:self.propertyAddress.text forKey:@"propertyAddress"];
    [check setValue:self.buyer.text forKey:@"buyer"];
    [check setValue:self.seller.text forKey:@"seller"];
    [check setValue:self.checkType1 forKey:@"checkType1"];
    
    NSData *img1Data = UIImagePNGRepresentation(self.myImage);
    [check setValue:img1Data forKey:@"img1"];

    if (numPhotos == 2)
    {
        [check setValue:self.checkType2 forKey:@"checkType2"];
        NSData *img2Data = UIImagePNGRepresentation(self.img2);
        [check setValue:img2Data forKey:@"img2"];
    }
    
    NSError *error = nil;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate saveContext];

    if (error) NSLog(@"error");
    else [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)send
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
    
    PDFController *pdf = [[PDFController alloc] initWithAddress:self.propertyAddress.text buyer:self.buyer.text seller:self.seller.text check1:self.myImage check2:self.img2 type1:self.checkType1 type2:self.checkType2];
    
    SendViewController *svc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SVC"];
    
    svc.htmlString = pdf.htmlContent;
    svc.propertyAddress = self.propertyAddress.text;
    
    [self.navigationController showViewController:svc sender:self];
    
    [loadingView removeFromSuperview];
    [indicator stopAnimating];
}


- (IBAction)sendChecks:(id)sender
{
    if (self.propertyAddress.text.length == 0 || self.buyer.text.length == 0 || self.seller.text.length == 0)
    {
        UIAlertController *blankAlert = [UIAlertController alertControllerWithTitle:@"Blank Fields" message:@"One of the fields has been left blank. Are you sure you want to continue?" preferredStyle:UIAlertControllerStyleAlert];
        [blankAlert addAction:[UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleCancel handler:nil]];
        [blankAlert addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self send];
            
        }]];
        
        [self presentViewController:blankAlert animated:YES completion:nil];
    }
    else
    {
        [self send];
    }
}

- (IBAction)tap:(id)sender {
    
    [self.propertyAddress resignFirstResponder];
    [self.buyer resignFirstResponder];
    [self.seller resignFirstResponder];
}


@end
