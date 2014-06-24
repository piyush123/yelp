//
//  self.m
//  Yelp
//
//  Created by piyush shah on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ListingCell.h"
#import "Listing.h"
#import <UIImageView+AFNetworking.h>

@implementation ListingCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setListing:(Listing *)yelpListing
{
  
    NSLog(@"got listing %@", yelpListing);
    
    self.name.text = yelpListing.name;
    
    
    
    if ([yelpListing.address count]) {
        NSLog(@"address %@", yelpListing.address[0]);
        
        self.address.text = yelpListing.address[0];
    }
    
    
    NSLog(@"categories %@", yelpListing.categories[0]);
    
    self.radial_distance.text = @"0.75 mi";
    
    NSLog(@"review count %@", yelpListing.review_count);
    self.review_count.text = [NSString stringWithFormat:@"reviews %@", yelpListing.review_count];
    
    self.categories.text = yelpListing.categories[0][0];
  //  self.categories.text = [NSString stringWithFormat:@"%@", yelpListing.categories];
    NSURL *image_url = [[NSURL alloc]initWithString:yelpListing.image_url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:image_url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:2*60]; // New line
    
        ListingCell *weakListingCell = self;
    
    [self.image setImageWithURLRequest:request
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          weakListingCell.image.image = image;
                                          [weakListingCell setNeedsLayout];
                                      } failure:nil];
    
    
    NSURL *rating_url = [[NSURL alloc]initWithString:yelpListing.rating_img_url];
    
    NSURLRequest  *rating_request = [NSURLRequest requestWithURL:rating_url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:2*60]; // New line
    
    
    [self.rating_image setImageWithURLRequest:rating_request
                                    placeholderImage:nil
                                             success:^(NSURLRequest *rating_request, NSHTTPURLResponse *response, UIImage *image) {
                                                 weakListingCell.rating_image.image = image;
                                                 [weakListingCell setNeedsLayout];
                                             } failure:nil];

   
}

@end
