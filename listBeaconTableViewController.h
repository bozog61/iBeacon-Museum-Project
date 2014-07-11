//
//  listBeaconTableViewController.h
//  Museum
//
//  Created by Ali BOZOĞ on 21.04.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface listBeaconTableViewController : UITableViewController<CLLocationManagerDelegate,CBPeripheralDelegate,UIScrollViewDelegate>

@property CLBeacon *beacon;
@property CLBeaconRegion *beaconRegion;
@property CLLocationManager *locationManager;
@property int girisMinor;

@end
