//
//  positionViewController.m
//  Museum
//
//  Created by Ali BOZOĞ on 7.05.2014.
//  Copyright (c) 2014 Ali BOZOĞ. All rights reserved.
//

#import "positionViewController.h"
#import "positionView.h"

@interface positionViewController ()
@property (nonatomic, strong) UIImageView       *positionDot;

@end
int ornekKontrol;
int ornekSayisi;
float beaconlarArasiUzaklik;
float dikeyUzaklik;
NSMutableArray *sol;
NSMutableArray *orta;
NSMutableArray *sag;
NSThread *myThread;
int metreBasiPiksel;
@implementation positionViewController



@synthesize beaconRegion,beacon,locationManager,drawView,rectangle;

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
    beaconlarArasiUzaklik=4;
    dikeyUzaklik=beaconlarArasiUzaklik*430/320;
    ornekSayisi=1;
    ornekKontrol=0;
    metreBasiPiksel=320/beaconlarArasiUzaklik;
    sol=[[NSMutableArray alloc]init];
    orta=[[NSMutableArray alloc]init];
    sag=[[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor redColor];
    
    UIImageView *beaconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beacon"]];
    [beaconImageView setCenter:CGPointMake(drawView.center.x, 50)];
    [self.view addSubview:beaconImageView];
    
    
    UIImageView *beaconImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beacon"]];
    [beaconImageView2 setCenter:CGPointMake(0, 50)];
    [self.view addSubview:beaconImageView2];
    
    UIImageView *beaconImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beacon"]];
    [beaconImageView3 setCenter:CGPointMake(320,50)];
    [self.view addSubview:beaconImageView3];
    
    
    
    self.positionDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_dot"]];
    [self.positionDot setCenter:drawView.center];
    [self.view addSubview:self.positionDot];
    

    
    NSUUID *beaconİD=[[NSUUID alloc] initWithUUIDString:@"8DEEFBB9-F738-4297-8040-96668BB44281"];
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconİD identifier:@"myBeacon"];
	
    [beaconRegion setNotifyEntryStateOnDisplay:YES];
    [beaconRegion setNotifyOnEntry:YES];
    [beaconRegion setNotifyOnExit:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
   [locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [locationManager startMonitoringForRegion:self.beaconRegion];
   
    
 
    
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    
    if ([beacons count]==3)
    {
        
        for(int i=0;i<beacons.count;i++){
            
            CLBeacon *nearestExhibit = [beacons objectAtIndex:i];
            NSString *temp=[NSString stringWithFormat:@"%f", nearestExhibit.accuracy];
            NSString *minor=[NSString stringWithFormat:@"%@",[nearestExhibit minor]];
            int minorInt=[minor intValue];
            float uzaklikk=[temp floatValue];
            
            
            if (minorInt==3357 && uzaklikk>0 && uzaklikk<dikeyUzaklik)
            {
                if([sol count]<ornekSayisi)
                {
                    [sol addObject:temp];
                    ornekKontrol++;
                }
               
            }
            
            if (minorInt==3359 && uzaklikk>0 && uzaklikk<dikeyUzaklik)
            {
                if(orta.count<ornekSayisi)
                {
                    [orta addObject:temp];
                    ornekKontrol++;
                }
                
            }
            if (minorInt==3384 && uzaklikk>0 && uzaklikk<dikeyUzaklik)
            {
                if (sag.count<ornekSayisi)
                {
                    [sag addObject:temp];
                    ornekKontrol++;
                }
            }
            
            if (ornekKontrol==ornekSayisi*3)
            {
                ornekKontrol=0;
                [self sol:sol orta:orta sag:sag];
                [sol removeAllObjects];
                [orta removeAllObjects];
                [sag removeAllObjects];
                
            }
            
        }
        
            

        }
    }
    
    


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) sol:(NSMutableArray *) sol orta:(NSMutableArray *) orta sag:(NSMutableArray *) sag
{
    float solaUzaklik=[self ortalamahesapla:sol];
    float ortayaUzaklik=[self ortalamahesapla:orta];
    float sagaUzaklik=[self ortalamahesapla:sag];
    
    if(solaUzaklik>=sagaUzaklik)
    {
        float p=(powf(solaUzaklik,2)-powf(sagaUzaklik, 2)-powf(beaconlarArasiUzaklik/2, 2))/beaconlarArasiUzaklik;
        float hKare=powf(ortayaUzaklik, 2)-powf(p, 2);
        float h=sqrtf(hKare);
        
        float konumDüsey=h;
        float konumYatay=p+(beaconlarArasiUzaklik/2);
        [self konumlariAlveHareketEttir:konumYatay düsey:konumDüsey];
        
    }
    
    else
    {
        float p=(powf(sagaUzaklik,2)-powf(ortayaUzaklik, 2)-powf(beaconlarArasiUzaklik/2, 2))/beaconlarArasiUzaklik;
        float hKare=powf(ortayaUzaklik, 2)-powf(p, 2);
        float h=sqrtf(hKare);
        
        float konumDüsey=h;
        float konumYatay=(beaconlarArasiUzaklik/2)-p;
        [self konumlariAlveHareketEttir:konumYatay düsey:konumDüsey];
    }
    
    
}


-(float)ortalamahesapla:(NSMutableArray *) uzaklikArray
{
    float toplam=0;
    for(int i=0;i<uzaklikArray.count;i++)
    {
        NSString *temp=[uzaklikArray objectAtIndex:i];
        toplam=toplam+[temp floatValue];
    }
    return (toplam/ornekSayisi);
}

-(void)konumlariAlveHareketEttir:(float) konumYatay düsey:(float) konumDusey
{
    int pikselYatay=konumYatay*metreBasiPiksel;
    int pikselDusey=konumDusey*metreBasiPiksel;
    [self.positionDot setCenter:CGPointMake(pikselYatay,pikselDusey+50)];
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
