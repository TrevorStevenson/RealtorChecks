//
//  TutorialScreenViewController.m
//  RealtorChecks
//
//  Created by Trevor Stevenson on 6/11/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import "TutorialScreenViewController.h"

@interface TutorialScreenViewController ()


@end

@implementation TutorialScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
