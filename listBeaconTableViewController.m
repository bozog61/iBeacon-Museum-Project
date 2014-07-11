//
//  listBeaconTableViewController.m
//  Museum
//
//  Created by Ali BOZOĞ on 21.04.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import "listBeaconTableViewController.h"
#import "listBeaconTableViewCell.h"
#import "WebServis.h"
#import "detailViewController.h"
#import "uzaklikViewController.h"



@interface listBeaconTableViewController ()
@property (nonatomic, strong) NSURLSession *session;
@end
WebServis *webservis;
NSArray *beaconArray=nil;
NSTimer *timer=nil;
NSData *data;
NSArray *eserlerArray=nil;
NSString *gonderID=nil;
NSThread *otoGecisThread;
NSLock *lock;
NSLock *lock2;
int otoGecisKontrol;
NSMutableArray *resimData;
@implementation listBeaconTableViewController
@synthesize girisMinor;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    resimData=[[NSMutableArray alloc]init];
    webservis=[[WebServis alloc]init];
    otoGecisKontrol=0;
    lock=[[NSLock alloc] init];
    lock2=[[NSLock alloc] init];
    
     NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%d", girisMinor],@"minor",
     nil];
    
  
    NSUUID *beaconİD=[[NSUUID alloc] initWithUUIDString:@"8DEEFBB9-F738-4297-8040-96668BB44281"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconİD identifier:@"myBeacon"];
    

    [self.beaconRegion setNotifyEntryStateOnDisplay:YES];
    [self.beaconRegion setNotifyOnEntry:YES];
    [self.beaconRegion setNotifyOnExit:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];

    UIRefreshControl *refresh=[[UIRefreshControl alloc]init];
    self.refreshControl=refresh;
    
    
    [refresh addTarget:self action:@selector(yenile) forControlEvents:UIControlEventValueChanged]; //tabloyu yenilemek için
    
    // timer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(yenile2) userInfo:nil repeats:YES];
    
    
    NSThread *webservice=[[NSThread alloc] initWithTarget:self selector:@selector(websevisFonk:) object:parameters];
    [webservice start];
    
    
    
}

-(void) resimyükle:(NSURL *) resimurl
{
     data = [NSData dataWithContentsOfURL:resimurl];
   // [self.tableView reloadData];
}

-(void) websevisFonk:(NSDictionary *) parametreler
{
    WebServis *webSevis=[[WebServis alloc] init];
    NSDictionary *tümEserler=[webSevis servisAdi:@"TumEserler.php" parametleriVeDegerleriAl:parametreler];
    eserlerArray=[tümEserler objectForKey:@"Eserler"];
     [self.tableView reloadData];
}
-(void) yenile
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

-(void) yenile2
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return eserlerArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    listBeaconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listBeaconTableViewCell"];
    
    if (cell == nil) {
        cell = [[listBeaconTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listBeaconTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *eser=[eserlerArray objectAtIndex:indexPath.item];
    [cell.eserLbl setText:[eser objectForKey:@"eserIsim"]];
    cell.eserID=[eser objectForKey:@"eserID"];
    NSURL *resimURL=[NSURL URLWithString:[eser objectForKey:@"resimURL"]];
   
    NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
    [temp  setValue:cell forKey:@"cell"];
    [temp setValue:resimURL forKey:@"url"];
    
    if([[eser objectForKey:@"takipVarmi"] intValue]==1)
    [cell.takipResim setImage:[UIImage imageNamed:@"takip.png"]];
    
    NSThread *resimThread=[[NSThread alloc] initWithTarget:self selector:@selector(cellImageViewAyarla:) object:temp];
    [resimThread start];
    
    return cell;
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
                    otoGecisThread=[[NSThread alloc] initWithTarget:self selector:@selector(minorveuzakligial:) object:otoGecisParametre];
                    [otoGecisThread start];
                    [self otogecis];
                }
            }
        }
            
            
            
    
    }
    


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    listBeaconTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    gonderID=cell.eserID;
    NSDictionary *eser=[eserlerArray objectAtIndex:indexPath.item];
    if([[eser objectForKey:@"takipVarmi"] intValue]==1)
    {
        [self performSegueWithIdentifier:@"uzaklikGecis" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"gecis2" sender:self];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"gecis2"])
    {
        detailViewController  *obj = segue.destinationViewController;
        obj.eserID=gonderID;
    }
    if([[segue identifier] isEqualToString:@"gecis4"])
    {
        detailViewController  *obj = segue.destinationViewController;
        obj.eserID=gonderID;
    }
    if([[segue identifier] isEqualToString:@"uzaklikGecis"])
    {
        uzaklikViewController  *obj = segue.destinationViewController;
        obj.eserID=gonderID;
    }
    
}

-(void)cellImageViewAyarla:(NSMutableDictionary *) data
{
    listBeaconTableViewCell *cell=[data valueForKey:@"cell"];
    NSURL *url=[data valueForKey:@"url"];
    
    NSData* data2 = [NSData dataWithContentsOfURL:url];
    UIImage* image = [UIImage imageWithData:data2];
    cell.imageView.image=image;
        
}
    

-(void)minorveuzakligial:(NSMutableDictionary *) parametreler
{
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
            //[self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
            //[self.locationManager stopMonitoringForRegion:self.beaconRegion];
            gonderID=eserIDString;
            otoGecisKontrol=1;
        }
       
    }
    
    
    
}
-(void) otogecis
{
    if(otoGecisKontrol==1)
     [self performSegueWithIdentifier:@"gecis2" sender:self];
    otoGecisKontrol=0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewDidDisappear:(BOOL)animated
{
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    
    [super viewDidDisappear:animated];
}




@end

