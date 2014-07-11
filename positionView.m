//
//  positionView.m
//  Museum
//
//  Created by Ali BOZOĞ on 8.05.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import "positionView.h"
#import "positionViewController.h"

@implementation positionView
@synthesize rectangle,locationManager,beacon,beaconRegion;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSUUID *beaconİD=[[NSUUID alloc] initWithUUIDString:@"8DEEFBB9-F738-4297-8040-96668BB44281"];
        beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconİD identifier:@"myBeacon"];
        
        [beaconRegion setNotifyEntryStateOnDisplay:YES];
        [beaconRegion setNotifyOnEntry:YES];
        [beaconRegion setNotifyOnExit:YES];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        
        
        
    }
    return self;
    
}


- (void)drawRect:(CGRect)rect
{
  
  
    
        

}

-(CGRect) merkezKoordinatlariAl:(int ) merkezX koordinatAl:(int) merkezY yaricap:(float) yaricap
{
    
    float tempYaricap=yaricap*43;
    int pikselYaricap=(int)tempYaricap;
    
    int merkezXPiksel=merkezX-pikselYaricap;
    int merkezYPiksel=merkezY-pikselYaricap;
    
    CGRect rectangle2=CGRectMake(merkezXPiksel, merkezYPiksel, tempYaricap*2, tempYaricap*2);
    
    return rectangle2;
}
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    if ([beacons count] > 0) {
        NSMutableArray *uzaklikArray=[[NSMutableArray alloc]init];
        NSMutableArray *minorArray=[[NSMutableArray alloc]init];
        for(int i=0;i<beacons.count;i++){
            
            CLBeacon *nearestExhibit = [beacons objectAtIndex:i];
            NSString *temp=[NSString stringWithFormat:@"%f", nearestExhibit.accuracy];
            NSString *minor=[NSString stringWithFormat:@"%@",[nearestExhibit minor]];
            [uzaklikArray addObject:temp];
            [minorArray addObject:minor];
                       
            
          
            
            
            
        }
    }
    
    
    
    
}






@end
