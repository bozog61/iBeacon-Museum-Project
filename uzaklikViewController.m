//
//  uzaklikViewController.m
//  Museum
//
//  Created by Ali BOZOĞ on 16.05.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import "uzaklikViewController.h"
#import "WebServis.h"
#import "detailViewController.h"

@interface uzaklikViewController ()

@end

@implementation uzaklikViewController
@synthesize eserID,eserImageView,minorID,maxUzaklik,minUzaklik,beaconImageView3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    WebServis *webServis=[[WebServis alloc] init];
    
    [eserImageView setCenter:CGPointMake(self.view.center.x, 50)];
   
    beaconImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me.png"]];
    [beaconImageView3 setCenter:self.view.center];
    [self.view addSubview:beaconImageView3];
    
    
    NSThread *resimYukle=[[NSThread alloc]initWithTarget:self selector:@selector(resimAyarla:) object:eserID];
    [resimYukle start];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@", eserID],@"eserID",
                                nil];
    NSDictionary *detaylar=[webServis servisAdi:@"Takip.php" parametleriVeDegerleriAl:parameters];
    NSArray *detayArray=[detaylar objectForKey:@"eserler"];
    NSDictionary *eser=[detayArray objectAtIndex:0];
    minorID=[eser objectForKey:@"minor"];
    
    
    
    
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@", minorID],@"minor",
                                nil];
    NSDictionary *JSON=[webServis servisAdi:@"BeaconEser.php" parametleriVeDegerleriAl:parameter];
    NSString *succes=[JSON objectForKey:@"success"];
    
    int durum=[succes intValue];
    
    if(durum==1)
    {
        NSArray *eserArray=[JSON objectForKey:@"eserler"];
        NSDictionary *eserDictionary=[eserArray objectAtIndex:0];
        NSString *minUzaklikString=[eserDictionary objectForKey:@"minUzaklik"];
        NSString *maxUzaklikString=[eserDictionary objectForKey:@"maxUzaklik"];
         minUzaklik=[minUzaklikString floatValue];
         maxUzaklik=[maxUzaklikString floatValue];
    }
    
    
    NSUUID *beaconİD=[[NSUUID alloc] initWithUUIDString:@"8DEEFBB9-F738-4297-8040-96668BB44281"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconİD identifier:@"myBeacon"];
	
    [self.beaconRegion setNotifyEntryStateOnDisplay:YES];
    [self.beaconRegion setNotifyOnEntry:YES];
    [self.beaconRegion setNotifyOnExit:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)resimAyarla:(NSString *)eserID2
{
    WebServis *webSevis=[[WebServis alloc] init];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@", eserID2],@"eserID",
                                nil];
    
    NSDictionary *detaylar=[webSevis servisAdi:@"EserDetay.php" parametleriVeDegerleriAl:parameters];
    
    NSArray *detayArray=[detaylar objectForKey:@"Eserler"];
    NSDictionary *eser=[detayArray objectAtIndex:0];
    NSURL *url=[NSURL URLWithString:[eser objectForKey:@"resimURL"]];
    NSData* data2 = [NSData dataWithContentsOfURL:url];
    UIImage* image = [UIImage imageWithData:data2];
    eserImageView.image=image;

}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    if ([beacons count] > 0) {
        for(int i=0;i<beacons.count;i++){
            
            CLBeacon *nearestExhibit = [beacons objectAtIndex:i];
            NSString *temp=[NSString stringWithFormat:@"%f", nearestExhibit.accuracy];
            NSString *minor=[NSString stringWithFormat:@"%@",[nearestExhibit minor]];
            int minorInt=[minor intValue];
            float uzaklik=[temp floatValue];
            if(uzaklik>0 && uzaklik<20 && minorInt==[minorID intValue])
            {
                float konumDusey=uzaklik*17;
                [beaconImageView3 setCenter:CGPointMake(160,konumDusey+135)];
                if(uzaklik>minUzaklik && uzaklik<maxUzaklik)
                {
                    [self performSegueWithIdentifier:@"uzakliktodetay" sender:self];
                }
                
            }
        }
    }
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"uzakliktodetay"])
    {
        detailViewController  *obj = segue.destinationViewController;
        obj.eserID=eserID;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
