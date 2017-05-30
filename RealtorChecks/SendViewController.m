//
//  SendViewController.m
//  RealtorChecks
//
//  Created by Trevor Stevenson on 5/12/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import "SendViewController.h"
#import "PDFController.h"
#import <MessageUI/MessageUI.h>
#import "CustomPDFRenderer.h"

@interface SendViewController ()


@end

@implementation SendViewController
{
    PDFController *pdfController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    self.webView.alpha = 0.0;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *check1File = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"check1.png"];
    NSString *check2File = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"check2.png"];
    NSString *logoFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"MWRC.png"];
    [fileManager removeItemAtPath:check1File error:nil];
    [fileManager removeItemAtPath:check2File error:nil];
    [fileManager removeItemAtPath:logoFile error:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CustomPDFRenderer *CPR = [[CustomPDFRenderer alloc] init];
    
    [CPR addPrintFormatter:self.webView.viewPrintFormatter startingAtPageAtIndex:0];
    
    NSData *pdfData = [pdfController drawPDFWithRenderer:CPR];
    
    [pdfData writeToFile:pdfController.fileName atomically:YES];
    
    [self showMailControllerWithFile:pdfController.fileName];
}

- (IBAction)sendEmail:(id)sender
{
    pdfController = [[PDFController alloc] init];
    pdfController.SVC = self;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[paths objectAtIndex:0] stringByAppendingPathComponent:self.fileNameTextField.text];
    [pdfController exportToPDF:self.htmlString withFileName:fileName];
}

- (void)showMailControllerWithFile:(NSString *)fileName
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *MVC = [[MFMailComposeViewController alloc] init];
        MVC.mailComposeDelegate = self;
        [MVC setToRecipients:@[self.sendToTextField.text]];
        [MVC setSubject:@"Checks"];
        [MVC setMessageBody:@"Here are the checks!" isHTML:NO];
        [MVC addAttachmentData:[NSData dataWithContentsOfFile:fileName] mimeType:@"application/pdf" fileName:self.fileNameTextField.text];
        
        [self presentViewController:MVC animated:YES completion:nil];
    }
}

- (IBAction)cancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)tap:(id)sender {
    
    [self.sendToTextField resignFirstResponder];
    [self.fileNameTextField resignFirstResponder];
    
}

@end
