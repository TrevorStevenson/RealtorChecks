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
    UIActivityIndicatorView *indicator;
    UIView *loadingView;
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

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertController *failAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Make sure you have internet connection to send checks." preferredStyle:UIAlertControllerStyleAlert];
    [failAlert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:failAlert animated:YES completion:nil];
}

- (IBAction)sendEmail:(id)sender
{
    if (self.fileNameTextField.text.length == 0)
    {
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"File Name" message:@"You must provide a file name for the PDF." preferredStyle:UIAlertControllerStyleAlert];
        [errorAlert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:errorAlert animated:YES completion:nil];
        return;
    }
    
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.hidesWhenStopped = YES;
    loadingView = [[UIView alloc] init];
    indicator.center = self.view.center;
    loadingView.frame = UIEdgeInsetsInsetRect(indicator.frame, UIEdgeInsetsMake(-10, -10, -10, -10));
    loadingView.layer.masksToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
    loadingView.backgroundColor = [UIColor blackColor];
    indicator.center = loadingView.center;
    [self.view addSubview:loadingView];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
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
        [MVC setSubject:[NSString stringWithFormat:@"%@ Checks", self.propertyAddress]];
        [MVC setMessageBody:[NSString stringWithFormat:@"Here are the checks for %@.", [self.propertyAddress stringByReplacingOccurrencesOfString:@"." withString:@""]] isHTML:NO];
        [MVC addAttachmentData:[NSData dataWithContentsOfFile:fileName] mimeType:@"application/pdf" fileName:self.fileNameTextField.text];
        
        [self presentViewController:MVC animated:YES completion:nil];
        
        [loadingView removeFromSuperview];
        [indicator stopAnimating];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length + range.location > textField.text.length) return NO;
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 33;
}

- (IBAction)cancel:(id)sender {
    
    UIAlertController *cancelAlert = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"All data will be lost for these checks." preferredStyle:UIAlertControllerStyleAlert];
    [cancelAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
    [cancelAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }]];
    
    [self presentViewController:cancelAlert animated:YES completion:nil];
}

- (IBAction)tap:(id)sender {
    
    [self.sendToTextField resignFirstResponder];
    [self.fileNameTextField resignFirstResponder];
    
}
- (IBAction)switch:(UISwitch *)sender
{
    if (sender.isOn)
    {
        self.fileNameTextField.text = [[self.propertyAddress stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
    else
    {
        self.fileNameTextField.text = @"";
    }
}


@end
