//
//  Filter.h
//  Yelp
//
//  Created by piyush shah on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Categories.h"

@interface Filter : NSObject
@property (strong, nonatomic) NSArray const* sections;
@property (strong, nonatomic) NSArray const* sortByOptions;
@property (strong, nonatomic) NSArray const* distanceOptions;
@property (strong, nonatomic) NSArray const* toggleOptions;
@property (strong, nonatomic) Categories const* categories;
@property (assign, nonatomic) NSInteger const NumCategoriesWhenCollapsed;

@property (assign, nonatomic) BOOL sortByExpanded;
@property (assign, nonatomic) BOOL distanceExpanded;
@property (assign, nonatomic) BOOL categoriesExpanded;
@property (assign, nonatomic) NSInteger selectedSortByIndex;
@property (assign, nonatomic) NSInteger selectedDistanceIndex;

typedef NS_ENUM(NSInteger, FilterSection) {
    SortBySection,
    DistanceSection,
    MiscSection,
    CategorySection
};

@end
