//
//  CheckCell.h
//  RealtorChecks
//
//  Created by Trevor Stevenson on 5/10/17.
//  Copyright © 2017 Triple Torus Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *propertyAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;

@end
