//
//  UARTPeripheral.m
//  nRF UART
//
//  Created by Ole Morten on 1/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import "UARTPeripheral.h"

@interface UARTPeripheral ()
@property CBService *uartService;
@property CBCharacteristic *rxCharacteristic;
@property CBCharacteristic *txCharacteristic;

@end

@implementation UARTPeripheral
@synthesize peripheral = _peripheral;
@synthesize delegate = _delegate;
@synthesize uartService = _uartService;
@synthesize rxCharacteristic = _rxCharacteristic;
@synthesize txCharacteristic = _txCharacteristic;

+ (CBUUID *) uartServiceUUID
{
  //return [CBUUID UUIDWithString:@"6e400001-b5a3-f393-e0a9-e50e24dcca9e"];
    NSLog(@"uartServiceUUID");
    return [CBUUID UUIDWithString:@"569a1101-b87f-490c-92cb-11ba5ea5167c"];
}

+ (CBUUID *) txCharacteristicUUID   //data going to the module
{
    //return [CBUUID UUIDWithString:@"6e400002-b5a3-f393-e0a9-e50e24dcca9e"];
    NSLog(@"txCharacteristicUUID");
    return [CBUUID UUIDWithString:@"569a2001-b87f-490c-92cb-11ba5ea5167c"];
}

+ (CBUUID *) rxCharacteristicUUID  //data coming from the module
{
    //return [CBUUID UUIDWithString:@"6e400003-b5a3-f393-e0a9-e50e24dcca9e"];
    NSLog(@"rxCharacteristicUUID");
    return [CBUUID UUIDWithString:@"569a2000-b87f-490c-92cb-11ba5ea5167c"];
}

+ (CBUUID *) deviceInformationServiceUUID
{
    NSLog(@"DeviceInformationServiceUUID 180A");
    return [CBUUID UUIDWithString:@"180A"];
}

+ (CBUUID *) hardwareRevisionStringUUID
{
    return [CBUUID UUIDWithString:@"2A27"];
}

- (UARTPeripheral *) initWithPeripheral:(CBPeripheral*)peripheral delegate:(id<UARTPeripheralDelegate>) delegate
{
    NSLog(@"initWithPeripheral");
    if (self = [super init])
    {
        _peripheral = peripheral;
        _peripheral.delegate = self;
        _delegate = delegate;
    }
    return self;
}

- (void) didConnect
{
    NSLog(@"didConnect");
    [_peripheral discoverServices:@[self.class.uartServiceUUID, self.class.deviceInformationServiceUUID]];
    NSLog(@"Did start service discovery.");
}

- (void) didDisconnect
{
    NSLog(@"didDisconnect");
}

- (void) writeString:(NSString *) string
{
    NSLog(@"writeString");
    NSString *string1 = [NSString stringWithString:string];
    
    string1 = [string1 stringByAppendingString:@"\r"];
    
    NSData *data = [NSData dataWithBytes:string1.UTF8String length:string1.length];
    
    
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

- (void) writeRawData:(NSData *) data
{
     NSLog(@"writeRawData");
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices");
    if (error)
    {
        NSLog(@"Error discovering services: %@", error);
        return;
    }
    
    for (CBService *s in [peripheral services])
    {
        if ([s.UUID isEqual:self.class.uartServiceUUID])
        {
            NSLog(@"Found correct service");
            self.uartService = s;
            
            [self.peripheral discoverCharacteristics:@[self.class.txCharacteristicUUID, self.class.rxCharacteristicUUID] forService:self.uartService];
        }
        else if ([s.UUID isEqual:self.class.deviceInformationServiceUUID])
        {
            [self.peripheral discoverCharacteristics:@[self.class.hardwareRevisionStringUUID] forService:s];
        }
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"didDiscoverCharacteristicsForService");
    if (error)
    {
        NSLog(@"Error discovering characteristics: %@", error);
        return;
    }
    
    for (CBCharacteristic *c in [service characteristics])
    {
        if ([c.UUID isEqual:self.class.rxCharacteristicUUID])
        {
            NSLog(@"Found RX characteristic");
            self.rxCharacteristic = c;
            
            [self.peripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
        }
        else if ([c.UUID isEqual:self.class.txCharacteristicUUID])
        {
            NSLog(@"Found TX characteristic");
            self.txCharacteristic = c;
        }
        else if ([c.UUID isEqual:self.class.hardwareRevisionStringUUID])
        {
            NSLog(@"Found Hardware Revision String characteristic");
            [self.peripheral readValueForCharacteristic:c];
        }
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateValueForCharacteristic");
    if (error)
    {
        NSLog(@"Error receiving notification for characteristic %@: %@", characteristic, error);
        return;
    }
    
    NSLog(@"Received data on a characteristic.");
    
    if (characteristic == self.rxCharacteristic)
    {
        
        NSString *string = [NSString stringWithUTF8String:[[characteristic value] bytes]];
        [self.delegate didReceiveData:string];
    }
    else if ([characteristic.UUID isEqual:self.class.hardwareRevisionStringUUID])
    {
        NSString *hwRevision = @"";
        const uint8_t *bytes = characteristic.value.bytes;
        for (int i = 0; i < characteristic.value.length; i++)
        {
            NSLog(@"UUID : %x", bytes[i]);
            hwRevision = [hwRevision stringByAppendingFormat:@"0x%02x, ", bytes[i]];
        }
        @try {
            [self.delegate didReadHardwareRevisionString:[hwRevision substringToIndex:hwRevision.length-2]];
        }
        @catch ( NSException *e ) {
            
            NSLog(@"ERROR <<%@>>ERROR",hwRevision);
            
        }
    }
}
@end
