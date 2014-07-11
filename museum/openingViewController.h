//
//  openingViewController.h
//  Museum
//
//  Created by Ali BOZOĞ on 21.04.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface openingViewController : UIViewController<CLLocationManagerDelegate,CBPeripheralDelegate,UIAlertViewDelegate,NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property CLBeacon *beacon;
@property CLBeaconRegion *beaconRegion;
@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *isleme;
@end
