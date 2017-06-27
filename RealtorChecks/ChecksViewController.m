//
//  ChecksViewController.m
//  RealtorChecks
//
//  Created by Trevor Stevenson on 5/7/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import "ChecksViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CheckCell.h"
#import "OptionsView.h"

@interface ChecksViewController ()
{
    NSArray *myChecks;
}

@end

@implementation ChecksViewController
{
    NSManagedObjectContext *context;
    UILabel *noItemsLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    context = delegate.persistentContainer.viewContext;
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Checks"];
    
    NSError *error = nil;
    
    myChecks = [context executeFetchRequest:fetch error:&error];
    
    if (!myChecks) NSLog(@"error");
    
    if (myChecks.count == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Checks Saved" message:@"Click create in the main menu to create one!" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myChecks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.propertyAddressLabel.text = [myChecks[indexPath.row] objectForKey:@"propertyAddress"];
    //cell.buyerLabel.text = [myChecks[indexPath.row] objectForKey:@"buyer"];
    //cell.sellerLabel.text = [myChecks[indexPath.row] objectForKey:@"seller"];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [context deleteObject:myChecks[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionsView *OV = [[OptionsView alloc] init];
    [self.view addSubview:OV];
}

- (void)emailChecks
{
    
}

@end
