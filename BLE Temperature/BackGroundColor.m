//
//  BackGroundColor.m
//  BLE temperature
//
//  Created by Jennifer AUBINAIS on 03/01/2014.
//  Copyright (c) 2014 Jennifer AUBINAIS. All rights reserved.
//

#import "BackGroundColor.h"

@implementation BackGroundColor

- (void) background:(NSString *) string;
{
    NSInteger intValue = [string intValue];
    NSInteger ColorRed;
    NSInteger ColorGreen;
    NSInteger ColorBlue;
    switch (intValue) {
        case 30:
        case 29:
        case 28:
            ColorRed = 119;
            ColorGreen =20;
            ColorBlue = 8;
            break;
        case 27:
        case 26:
            ColorRed = 189;
            ColorGreen =44;
            ColorBlue = 35;
            break;
            
            
        case 10:
            break;
            
    }
    
    //[[self view] setBackgroundColor:[UIColor colorWithRed:(ColorRed & 0xFF) / 255.0f                                                              green:(ColorGreen & 0xFF) / 255.0f
   //                                                  blue:(ColorBlue & 0xFF) / 255.0f
    //                                                alpha:(0xFF)/ 255.0f]];
}

@end
