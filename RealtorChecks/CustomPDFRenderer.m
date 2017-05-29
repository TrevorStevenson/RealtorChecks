//
//  CustomPDFRenderer.m
//  RealtorChecks
//
//  Created by Trevor Stevenson on 5/12/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import "CustomPDFRenderer.h"

@implementation CustomPDFRenderer
{
    CGFloat A4pageWidth;
    CGFloat A4pageHeight;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        A4pageWidth = 595.2;
        A4pageHeight = 841.8;
        
        CGRect pageFrame = CGRectMake(0, 0, A4pageWidth, A4pageHeight);
        
        [self setValue:[NSValue valueWithCGRect:pageFrame] forKey:@"paperRect"];
        [self setValue:[NSValue valueWithCGRect:pageFrame] forKey:@"printableRect"];
    }
    return self;

}



@end
