//
//  PDFController.h
//  RealtorChecks
//
//  Created by Trevor Stevenson on 5/10/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SendViewController.h"

@interface PDFController : NSObject

@property NSString *propertyAddress;
@property NSString *buyer;
@property NSString *seller;
@property NSString *checkType1;
@property NSString *checkType2;
@property UIImage *img1;
@property UIImage *img2;

@property NSString *htmlContent;
@property NSString *fileName;

@property (weak) SendViewController *SVC;

- (instancetype)initWithAddress:(NSString *)add buyer:(NSString *)buy seller:(NSString *)sell check1:(UIImage *)c1 check2:(UIImage *)c2 type1:(NSString *)t1 type2:(NSString *)t2;

- (void)exportToPDF:(NSString *)htmlString withFileName:(NSString *)fileName;
- (NSData *)drawPDFWithRenderer:(UIPrintPageRenderer *)renderer;

@end
