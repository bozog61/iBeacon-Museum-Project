//
//  positionView.h
//  Museum
//
//  Created by Ali BOZOĞ on 8.05.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface positionView : UIView<CLLocationManagerDelegate>
@property CGRect rectangle;
@property CLBeacon *beacon;
@property CLBeaconRegion *beaconRegion;
@property CLLocationManager *locationManager;

@end
