//
//  JaTemp.m
//  BLE temperature
//
//  Created by Jennifer AUBINAIS on 11/11/2013.
//  Copyright (c) 2013 Jennifer AUBINAIS. All rights reserved.
//

#import "JaTemp.h"
#import "ViewController.h"
#import "DataClass.h"

@interface JaTemp()
@end

@implementation JaTemp
@synthesize cm = _cm;
@synthesize currentPeripheral = _currentPeripheral;


- (void) didReceiveData:(NSString *)string
{
    NSLog(@"************ %@ ************",string);
    [DataClass sharedGlobalData].str = [[DataClass sharedGlobalData].str stringByAppendingString:string];
    
}

- (void) ScanConnectDisconnect
{
    NSLog(@"Started scan ...");
    [self.cm scanForPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
    [DataClass sharedGlobalData].str = @"";
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"Bluetooth Enable");
    }
    else
    {
        NSLog(@"Bluetooth Disable");
    }
    
}

- (void) InitBT
{
    NSLog(@"initBT");
    self.cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Did discover peripheral %@", peripheral.name);
    [self.cm stopScan];
    
    self.currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    
    NSLog(@"Connecting to peripheral %@", peripheral.name);
    [self.cm connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect peripheral %@", peripheral.name);
    self.state = CONNECTED;
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didConnect];
    }
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    self.state = IDLE;
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        NSLog(@"WAIT DISCONNECT");
        //[self.currentPeripheral didDisconnect];
    }
}

- (UIColor *) background:(NSString *) string;
{
    NSLog(@"background");
    NSInteger intValue = [string intValue];
    NSInteger ColorRed;
    NSInteger ColorGreen;
    NSInteger ColorBlue;
    ColorRed = 0;
    ColorGreen = 0;
    ColorBlue = 0;
    switch (intValue) {
        case 33:
        case 32:
            ColorRed = 80;
            ColorGreen = 0;
            ColorBlue = 6;
            break;
        case 31:
        case 30:
            ColorRed = 108;
            ColorGreen = 0;
            ColorBlue = 0;
            break;
        case 29:
        case 28:
            ColorRed = 153;
            ColorGreen = 1;
            ColorBlue = 0;
            break;
        case 27:
        case 26:
            ColorRed = 204;
            ColorGreen = 0;
            ColorBlue = 1;
            break;
        case 25:
        case 24:
            ColorRed = 254;
            ColorGreen = 0;
            ColorBlue = 0;
            break;
        case 23:
        case 22:
            ColorRed = 255;
            ColorGreen = 51;
            ColorBlue = 1;
            break;
        case 21:
        case 20:
            ColorRed = 255;
            ColorGreen = 51;
            ColorBlue = 54;
            break;
        case 19:
        case 18:
            ColorRed = 251;
            ColorGreen = 105;
            ColorBlue = 0;
            break;
        case 17:
        case 16:
            ColorRed = 252;
            ColorGreen = 153;
            ColorBlue = 0;
            break;
        case 15:
        case 14:
            ColorRed = 255;
            ColorGreen = 204;
            ColorBlue = 1;
            break;
        case 13:
        case 12:
            ColorRed = 253;
            ColorGreen = 232;
            ColorBlue = 81;
            break;
        case 11:
        case 10:
            ColorRed = 255;
            ColorGreen = 255;
            ColorBlue = 135;
            break;
        case 9:
        case 8:
            ColorRed = 255;
            ColorGreen = 255;
            ColorBlue = 9;
            break;
        case 7:
        case 6:
            ColorRed = 187;
            ColorGreen = 250;
            ColorBlue = 19;
            break;
        case 5:
        case 4:
            ColorRed = 97;
            ColorGreen = 255;
            ColorBlue = 1;
            break;
        case 3:
        case 2:
            ColorRed = 102;
            ColorGreen = 255;
            ColorBlue = 102;
            break;
        case 1:
        case 0:
            ColorRed = 103;
            ColorGreen = 255;
            ColorBlue = 154;
            break;
        case -1:
        case -2:
            ColorRed = 102;
            ColorGreen = 254;
            ColorBlue = 255;
            break;
        case -3:
        case -4:
            ColorRed = 52;
            ColorGreen = 203;
            ColorBlue = 255;
            break;
        case -5:
        case -6:
            ColorRed = 0;
            ColorGreen = 153;
            ColorBlue = 255;
            break;
    }
    NSLog(@"background END");
    return [UIColor colorWithRed:(ColorRed) / 255.0f                                                              green:(ColorGreen) / 255.0f
                                                      blue:(ColorBlue) / 255.0f
                                                    alpha:(0xFF)/ 255.0f];
}

@end
