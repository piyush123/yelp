//
//  switchCell.h
//  Yelp
//
//  Created by piyush shah on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface switchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;

@property (strong, nonatomic) NSString* meta;
@end
