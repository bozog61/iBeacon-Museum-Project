//
//  uzaklikViewController.h
//  Museum
//
//  Created by Ali BOZOĞ on 16.05.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface uzaklikViewController : UIViewController<CLLocationManagerDelegate,CBPeripheralDelegate>
@property NSString *eserID;
@property NSString *minorID;
@property (strong, nonatomic) IBOutlet UIImageView *eserImageView;
@property CLBeacon *beacon;
@property CLBeaconRegion *beaconRegion;
@property CLLocationManager *locationManager;
@property float maxUzaklik;
@property float minUzaklik;
@property UIImageView *beaconImageView3;
@end
