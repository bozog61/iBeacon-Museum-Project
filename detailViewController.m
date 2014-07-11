//
//  detailViewController.m
//  Museum
//
//  Created by Ali BOZOĞ on 28.04.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import "detailViewController.h"
#import "WebServis.h"
#import "listBeaconTableViewController.h"
#import "detail2ViewController.h"
@interface detailViewController ()

@end
NSThread *otoGecisThread;
int kontrol;
int kontrol2;
NSString *eserIDString;
@implementation detailViewController

@synthesize eserID,eserImageView,progress,aciklamaText,beacon,beaconRegion,locationManager;

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
    NSString *aciklama=[[NSString alloc] init];
    eserIDString=[[NSString alloc]init];
    kontrol=0;
    kontrol2=0;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@", eserID],@"eserID",
                                nil];
   
    
   // [self performSelectorInBackground:@selector(websevisFonk:) withObject:parameters];
    WebServis *webSevis=[[WebServis alloc] init];
    NSDictionary *detaylar=[webSevis servisAdi:@"EserDetay.php" parametleriVeDegerleriAl:parameters];
    
    NSArray *detayArray=[detaylar objectForKey:@"Eserler"];
    NSDictionary *eser=[detayArray objectAtIndex:0];
    
    aciklama=[eser objectForKey:@"eserAciklama"];
    NSString *url=[eser objectForKey:@"resimURL"];
   
    NSThread *resimThread=[[NSThread alloc]initWithTarget:self selector:@selector(resimYukle:) object:url];
    [resimThread start];
    
   aciklamaText.text=aciklama;
   /*
    NSUUID *beaconİD=[[NSUUID alloc] initWithUUIDString:@"8DEEFBB9-F738-4297-8040-96668BB44281"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconİD identifier:@"myBeacon"];
	
    [self.beaconRegion setNotifyEntryStateOnDisplay:YES];
    [self.beaconRegion setNotifyOnEntry:YES];
    [self.beaconRegion setNotifyOnExit:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    */
    
     NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(gecis) userInfo:nil repeats:YES];
    
}

-(void) resimYukle:(NSString *) resimURL
{
    [progress startAnimating];
    NSURL *url=[NSURL URLWithString:resimURL];
    
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    UIImage* image = [UIImage imageWithData:data];
    [progress stopAnimating];
    eserImageView.image=image;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated
{
    
    
    [super viewDidDisappear:animated];
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

- (IBAction)backButton:(id)sender {
    [self performSegueWithIdentifier:@"gecis5" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"gecis5"])
    {
        listBeaconTableViewController  *list = segue.destinationViewController;
        list.girisMinor=3361;
        
    }
    if([[segue identifier] isEqualToString:@"gecis10"])
    {
        detail2ViewController  *obj = segue.destinationViewController;
        obj.eserID=eserIDString;
        
    }
  
    
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    if ([beacons count] > 0) {
        for(int i=0;i<beacons.count;i++){
            CLBeacon *nearestExhibit = [beacons objectAtIndex:i];
            NSString *temp=[NSString stringWithFormat:@"%f", nearestExhibit.accuracy];
            NSString *minor=[NSString stringWithFormat:@"%@",[nearestExhibit minor]];
            int uzaklikKontrol=[temp intValue];
            
            if(uzaklikKontrol<5)
            {
            NSMutableDictionary *otoGecisParametre=[[NSMutableDictionary alloc] init];
            [otoGecisParametre setObject:temp forKey:@"uzaklik"];
            [otoGecisParametre setObject:minor forKey:@"minor"];
            otoGecisThread=[[NSThread alloc] initWithTarget:self selector:@selector(otogecis:) object:otoGecisParametre];
            [otoGecisThread start];
            
            }
        }
    }
    
    
    
    
}

-(void) otogecis:(NSMutableDictionary *) parametreler
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
        eserIDString=[eserDictionary objectForKey:@"eserID"];
        float minUzaklik=[minUzaklikString floatValue];
        float maxUzaklik=[maxUzaklikString floatValue];
        int a=[eserIDString intValue];
        int b=[eserID intValue];
        
        
        if(uzaklik>minUzaklik && uzaklik<maxUzaklik && a!=b)
        {
            [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
            [self.locationManager stopMonitoringForRegion:self.beaconRegion];
             kontrol2=1;
           
        }
        
    }
    
    
 
}
-(void)gecis
{
    if(kontrol2==1)
    {
         [self performSegueWithIdentifier:@"gecis10" sender:self];
    }
}


@end
