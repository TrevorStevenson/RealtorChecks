//
//  PhotoViewController.h
//  RealtorChecks
//
//  Created by Trevor Stevenson on 5/7/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import "ViewController.h"

@interface PhotoViewController : ViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property UIImage *myImage;
@property UIImage *img2;
@property NSString *checkType1;
@property NSString *checkType2;

@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UITextField *propertyAddress;
@property (weak, nonatomic) IBOutlet UITextField *buyer;
@property (weak, nonatomic) IBOutlet UITextField *seller;
@property (weak, nonatomic) IBOutlet UIButton *addPhoto;

@end
