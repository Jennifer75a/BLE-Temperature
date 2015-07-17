//
//  DataClass.h
//  BLE temperature
//
//  Created by Jennifer AUBINAIS on 24/11/2013.
//  Copyright (c) 2013 Jennifer AUBINAIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject {
    
    NSString *str;
    
}
@property(nonatomic,retain)NSString *str;
+(DataClass*)sharedGlobalData;
@end  

