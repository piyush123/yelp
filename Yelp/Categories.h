//
//  Categories.h
//  Yelp
//
//  Created by piyush shah on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject
- (id) initWithApiParam: (NSString*) param;
- (NSString*) apiParam;

- (void) selectCategoryAtIndex:(NSInteger)index selected:(BOOL)selected;
- (BOOL) isCategorySelectedAtIndex:(NSInteger)index;

- (NSString*) categoryAtIndex:(NSInteger)index;
- (NSInteger) count;
@end
