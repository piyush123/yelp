//
//  FilterViewController.h
//  Yelp
//
//  Created by piyush shah on 6/16/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FiltersDelegate <NSObject>
- (NSDictionary*) filters;
- (void)confirmFilter:(NSDictionary*)filters;
- (void)cancelFilter;
@end

@interface FilterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) id<FiltersDelegate> delegate;
@end