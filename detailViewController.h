//
//  detailViewController.h
//  Museum
//
//  Created by Ali BOZOĞ on 28.04.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface detailViewController : UIViewController<CLLocationManagerDelegate>
@property NSString *eserID;
@property (weak, nonatomic) IBOutlet UIImageView *eserImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progress;

@property (strong, nonatomic) IBOutlet UITextView *aciklamaText;
- (IBAction)backButton:(id)sender;
@property CLBeacon *beacon;
@property CLBeaconRegion *beaconRegion;
@property CLLocationManager *locationManager;
@end
