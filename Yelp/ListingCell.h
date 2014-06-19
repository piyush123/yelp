//
//  ListingCell.h
//  Yelp
//
//  Created by piyush shah on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"

@interface ListingCell : UITableViewCell


- (void)setListing:(Listing *)yelpListing;

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *review_count;
@property (weak, nonatomic) IBOutlet UILabel *radial_distance;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *rating_image;

@property (weak, nonatomic) IBOutlet UILabel *categories;

@end

