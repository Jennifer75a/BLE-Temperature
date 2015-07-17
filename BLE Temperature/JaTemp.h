//
//  JaTemp.h
//  BLE temperature
//
//  Created by Jennifer AUBINAIS on 11/11/2013.
//  Copyright (c) 2013 Jennifer AUBINAIS. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "UARTPeripheral.h"

typedef enum
{
    IDLE = 0,
    SCANNING,
    CONNECTED,
} ConnectionState;

@interface JaTemp : NSObject <CBCentralManagerDelegate, UARTPeripheralDelegate>

@property CBCentralManager *cm;
@property ConnectionState state;
@property UARTPeripheral *currentPeripheral;

- (void) InitBT;
- (void) ScanConnectDisconnect;
- (UIColor *) background:(NSString *) string;

@end
