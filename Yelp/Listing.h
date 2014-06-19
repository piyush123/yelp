//
//  Listing.h
//  Yelp
//
//  Created by piyush shah on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MTLModel.h>//MTLModel
#import <MTLJSONAdapter.h>//MTLModel

@interface Listing : MTLModel <MTLJSONSerializing>

@property (nonatomic,strong) NSString  *name;
@property (nonatomic,strong) NSString  *display_phone;
@property (nonatomic,strong) NSArray  *categories;
@property (nonatomic,strong) NSArray  *review_count;
@property (nonatomic,strong) NSString *image_url;
@property (nonatomic,strong) NSString *distance;
@property (nonatomic, strong) NSString *rating_img_url;
@property (nonatomic, strong) NSDictionary *location;
@property (nonatomic, strong) NSArray *address;


@end
