//
//  OptionsView.m
//  RealtorChecks
//
//  Created by Trevor Stevenson on 5/10/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import "OptionsView.h"

@implementation OptionsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.frame];
        imgView.image = [UIImage imageNamed:@"OptionView"];
        [self addSubview:imgView];
        
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height/3, self.frame.size.width, self.frame.size.height/3)];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"OptionSend"] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendCheck) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 + 20, self.frame.size.width, self.frame.size.height/3)];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"OptionCancel"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelCheck) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
    }
    return self;
}

- (void)sendCheck
{
    [self.parentViewController emailChecks];
}

- (void)cancelCheck
{
    [self removeFromSuperview];
}

@end
