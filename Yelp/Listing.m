//
//  Listing.m
//  Yelp
//
//  Created by piyush shah on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Listing.h"
#import <MTLModel.h>//MTLModel
#import <MTLJSONAdapter.h>//MTLModel

@implementation Listing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name":@"name",
             @"address":@"location.address"
             };
}


+ (NSArray *)listinsWithArray:(NSArray *)array {
    NSMutableArray *listings = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        Listing *listing = [[Listing alloc] initWithDictionary:dictionary];
        [listings addObject:listing];
    }
    
    return listings;
    
}

@end

