//
//  SendViewController.h
//  RealtorChecks
//
//  Created by Trevor Stevenson on 5/12/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SendViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate>

@property NSString *htmlString;
@property (weak, nonatomic) IBOutlet UITextField *fileNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sendToTextField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)showMailControllerWithFile:(NSString *)fileName;

@end
