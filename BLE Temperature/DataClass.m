//
//  DataClass.m
//  BLE temperature
//
//  Created by Jennifer AUBINAIS on 24/11/2013.
//  Copyright (c) 2013 Jennifer AUBINAIS. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass
@synthesize str;
static DataClass *sharedGlobalData = nil;
+ (DataClass*)sharedGlobalData {
    if (sharedGlobalData == nil) {
        sharedGlobalData = [[super allocWithZone:NULL] init];
        
        // initialize your variables here
        sharedGlobalData.str = @"Default Global str";
    }
    return sharedGlobalData;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self)
    {
        if (sharedGlobalData == nil)
        {
            sharedGlobalData = [super allocWithZone:zone];
            return sharedGlobalData;
        }
    }
    return nil;
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end
