//
//  NSDictionary+setDictionary.h
//  Yelp
//
//  Created by piyush shah on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (setDictionary)

- (void)copyValueInDictionary:(NSMutableDictionary*)dict key:(id)key value:(id)value;

@end
