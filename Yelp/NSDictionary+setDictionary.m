//
//  NSDictionary+setDictionary.m
//  Yelp
//
//  Created by piyush shah on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/CustomizingExistingClasses/CustomizingExistingClasses.html

#import "NSDictionary+setDictionary.h"

@implementation NSDictionary (setDictionary)

- (void)copyValueInDictionary:(NSMutableDictionary*)dict key:(id)key value:(id)value
{
    if (value) {
        dict[key] = value;
    } else {
        [dict removeObjectForKey:key];
    }
}

@end
