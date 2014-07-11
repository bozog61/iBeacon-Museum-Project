//
//  positionViewController.h
//  Museum
//
//  Created by Ali BOZOĞ on 7.05.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "positionView.h"

@interface positionViewController : UIViewController<CLLocationManagerDelegate,CBPeripheralDelegate>

@property CLBeacon *beacon;
@property CLBeaconRegion *beaconRegion;
@property CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet positionView *drawView;
@property CGRect rectangle;
@end
