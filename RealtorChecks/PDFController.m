//
//  PDFController.m
//  RealtorChecks
//
//  Created by Trevor Stevenson on 5/10/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import "PDFController.h"
#import "CustomPDFRenderer.h"

@implementation PDFController

- (instancetype)initWithAddress:(NSString *)add buyer:(NSString *)buy seller:(NSString *)sell check1:(UIImage *)c1 check2:(UIImage *)c2 type1:(NSString *)t1 type2:(NSString *)t2
{
    self = [super init];
    if (self) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        UIImage *logo = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MWRC" ofType:@"png"]];
        NSString *logoFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"MWRC.png"];
        [UIImagePNGRepresentation(logo) writeToFile:logoFilePath atomically:YES];
        
        NSString *filePath1 = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"check1.png"];
        [UIImagePNGRepresentation(c1) writeToFile:filePath1 atomically:YES];
        
        NSString *filePath2 = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"check2.png"];
        
        if (c2)
        {
            [UIImagePNGRepresentation(c2) writeToFile:filePath2 atomically:YES];
        }
        
        NSString *template = [[NSBundle mainBundle] pathForResource:@"checks" ofType:@"html"];

        NSError *error = nil;
        NSString *content = [NSString stringWithContentsOfFile:template encoding:NSUTF8StringEncoding error:&error];
        
        if (error)
        {
            NSLog(@"error getting html");
        }
        
        content = [content stringByReplacingOccurrencesOfString:@"*CheckType1*" withString:t1];
        
        if (c2)
        {
            t2 = [t2 stringByAppendingString:@" Check"];
            content = [content stringByReplacingOccurrencesOfString:@"*CheckType2*" withString:t2];
        }
        else
        {
            content = [content stringByReplacingOccurrencesOfString:@"*CheckType2*" withString:@""];

        }
        content = [content stringByReplacingOccurrencesOfString:@"*PropertyAddress*" withString:add];
        content = [content stringByReplacingOccurrencesOfString:@"*Buyer*" withString:buy];
        content = [content stringByReplacingOccurrencesOfString:@"*Seller*" withString:sell];
        content = [content stringByReplacingOccurrencesOfString:@"*ImagePath*" withString:logoFilePath];
        content = [content stringByReplacingOccurrencesOfString:@"*Check1*" withString:filePath1];
        content = [content stringByReplacingOccurrencesOfString:@"*Check2*" withString:filePath2];
        
        self.htmlContent = content;
    }
    return self;
}

- (void)loadWebView
{
    NSLog(@"loadwebview");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *base = [paths objectAtIndex:0];
    NSURL *baseURL = [NSURL URLWithString:base];
    [self.SVC.webView loadHTMLString:self.htmlContent baseURL:baseURL];
}


- (NSData *)drawPDFWithRenderer:(UIPrintPageRenderer *)renderer
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    UIGraphicsBeginPDFContextToData(data, CGRectZero, nil);
    
    UIGraphicsBeginPDFPage();
    
    [renderer drawPageAtIndex:0 inRect:UIGraphicsGetPDFContextBounds()];
    
    UIGraphicsEndPDFContext();
    
    return data;
}

- (void)exportToPDF:(NSString *)htmlString withFileName:(NSString *)fileName
{
    self.htmlContent = htmlString;
    self.fileName = fileName;
    
    [self loadWebView];
}

@end
