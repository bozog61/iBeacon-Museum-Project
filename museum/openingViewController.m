//
//  openingViewController.m
//  Museum
//
//  Created by Ali BOZOĞ on 21.04.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import "openingViewController.h"
#import "listBeaconTableViewController.h"
#import "detailViewController.h"
#import "WebServis.h"

@interface openingViewController ()

@end

NSMutableArray *addArraycell;
int kontrol=0;
NSString *eserID;
int otoGecisKontrol;
int girisMinor;
int durum;
NSString *muzeAdi;
NSString *beaconMinor;
@implementation openingViewController
@synthesize imageView,beacon,beaconRegion,locationManager,isleme;

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
    
    otoGecisKontrol=0;
    imageView.image=[UIImage imageNamed:@"openingpicture.jpg"];
    
    [isleme setTintColor:[UIColor whiteColor]];
    [isleme setColor:[UIColor whiteColor]];
    [isleme startAnimating];
    
    NSUUID *beaconİD=[[NSUUID alloc] initWithUUIDString:@"8DEEFBB9-F738-4297-8040-96668BB44281"];
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconİD identifier:@"myBeacon"];
	
    [beaconRegion setNotifyEntryStateOnDisplay:YES];
    [beaconRegion setNotifyOnEntry:YES];
    [beaconRegion setNotifyOnExit:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    
    [locationManager startMonitoringForRegion:beaconRegion];
    [locationManager startRangingBeaconsInRegion:beaconRegion];
    NSThread *girisKapilari=[[NSThread alloc] initWithTarget:self selector:@selector(girisKapiDegerleriniAl) object:nil];
    [girisKapilari start];
    
    NSThread *otoGecisThread=[[NSThread alloc] initWithTarget:self selector:@selector(minorveuzakligial:) object:nil];
    [otoGecisThread start];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID andIdentifier:(NSString*)identifier {
    
    // Create the beacon region to be monitored.
    CLBeaconRegion *beaconRegion2 = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    identifier:identifier];
    
    // Register the beacon region with the location manager.
    [self.locationManager startMonitoringForRegion:beaconRegion2];
}
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    
    if ([beacons count] > 0) {
        for(int i=0;i<beacons.count;i++){
            CLBeacon *nearestExhibit = [beacons objectAtIndex:i];
            NSString *temp=[NSString stringWithFormat:@"%f", nearestExhibit.accuracy];
            float uzaklik=[temp floatValue];
            NSString *minor=[NSString stringWithFormat:@"%@",[nearestExhibit minor]];
            int minorInt=[minor intValue];
            [self gecis];
            
            if(uzaklik>0 && uzaklik<10)
            {
                
                
                if (durum==1)
                {
                    if([beaconMinor intValue]==minorInt)
                    {
                        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
                        [self.locationManager stopMonitoringForRegion:self.beaconRegion];
                        
                    
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[muzeAdi stringByAppendingString:@" Hoşgeldiniz! \n Eserleri Görmek İçin Tamam'a Basınız"]delegate:self cancelButtonTitle:@"İptal" otherButtonTitles:@"Tamam", nil];
                        [isleme stopAnimating];
                        [alert show];
                        
                        girisMinor=minorInt;
                    
                        kontrol=1;
                        break;
                }
            }
            
        }
    }
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    if(buttonIndex == 1)
    {[self performSegueWithIdentifier:@"gecis1" sender:self]; }
    
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    [locationManager startRangingBeaconsInRegion:beaconRegion];
}
-(NSDictionary *)loadJSONDataFromURL:(NSString *)urlString
{
    // This function takes the URL of a web service, calls it, and either returns "nil", or a NSDictionary,
    // describing the JSON data that was returned.
    //
    NSError *error;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Call the web service, and (if it's successful) store the raw data that it returns
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];
    if (!data)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        return nil;
    }
    
    // Parse the (binary) JSON data from the web service into an NSDictionary object
    id dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (dictionary == nil) {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    return dictionary;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"gecis1"])
    {
        listBeaconTableViewController  *list = segue.destinationViewController;
        list.girisMinor=girisMinor;
        
    }
    
    if([[segue identifier] isEqualToString:@"gecis3"])
    {
        detailViewController  *list = segue.destinationViewController;
        list.eserID=eserID;
        
    }
    
}

-(void)minorveuzakligial:(NSMutableDictionary *) parametreler
{
    WebServis *webservis=[[WebServis alloc] init];
    NSString *uzaklikString=[parametreler objectForKey:@"uzaklik"];
    NSString *minorString=[parametreler objectForKey:@"minor"];
    float uzaklik=[uzaklikString floatValue];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@", minorString],@"minor",
                                nil];
    NSDictionary *JSON=[webservis servisAdi:@"BeaconEser.php" parametleriVeDegerleriAl:parameters];
    NSString *succes=[JSON objectForKey:@"success"];
    
    int durum=[succes intValue];
    
    if(durum==1)
    {
        NSArray *eserArray=[JSON objectForKey:@"eserler"];
        NSDictionary *eserDictionary=[eserArray objectAtIndex:0];
        NSString *minUzaklikString=[eserDictionary objectForKey:@"minUzaklik"];
        NSString *maxUzaklikString=[eserDictionary objectForKey:@"maxUzaklik"];
        NSString *eserIDString=[eserDictionary objectForKey:@"eserID"];
        float minUzaklik=[minUzaklikString floatValue];
        float maxUzaklik=[maxUzaklikString floatValue];
        
        if(uzaklik>minUzaklik && uzaklik<maxUzaklik)
        {
            [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
            [self.locationManager stopMonitoringForRegion:self.beaconRegion];
            eserID=eserIDString;
            otoGecisKontrol=1;
        }
    }
    
    
    
}
-(void)gecis
{
    if(otoGecisKontrol==1)
    {
        [self performSegueWithIdentifier:@"gecis3" sender:self];
        otoGecisKontrol=0;
    }
}
-(void) girisKapiDegerleriniAl
{
    NSString *url=@"http://alibozog.url.ph/GirisKapilari.php?minor=";
    NSDictionary *JSON=[self loadJSONDataFromURL:[url stringByAppendingString:@"3361"]];
    durum=[[JSON objectForKey:@"success"] intValue];
    NSArray *items=[JSON objectForKey:@"eserler"];
    NSDictionary *items2=[items objectAtIndex:0];
    muzeAdi=[items2 objectForKey:@"muzeIsim"];
    beaconMinor=[items2 objectForKey:@"beaconMinor"];
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
