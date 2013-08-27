//
//  ViewController.m
//  StreetView
//
//  Created by Siddhant Dange on 8/27/13.
//  Copyright (c) 2013 Siddhant Dange. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

//CL
@property (nonatomic, strong) CLLocationManager *locationManager; 
@property (nonatomic, strong) CLGeocoder *geoCoder;

//IB 
@property (weak, nonatomic) IBOutlet UITextView *gpsText;
@property (weak, nonatomic) IBOutlet UITextView *compassText;

//self
@property (nonatomic, assign) int counter;
@property (nonatomic, assign) float lon, lat;


@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //init
    
    //CL location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    //CL geocoder
    self.geoCoder = [[CLGeocoder alloc] init];
    
    self.counter = 0;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation             fromLocation:(CLLocation *)oldLocation {
    
    if(self.counter % 1000 == 0){
        CLLocation *currentLocation = newLocation;
        
        //set properties
        self.lon = currentLocation.coordinate.longitude;
        self.lat = currentLocation.coordinate.latitude;
        
        //get street name
        [self.geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks,   NSError *error) {
            NSLog(@"placemarks: %@", placemarks);
        }];
    }
    
    self.counter++;
}


- (IBAction)getData:(id)sender {
    
    //gps
    [self.gpsText setText:[NSString stringWithFormat:@"Lon: %f\nLat: %f", self.lon, self.lat]];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
