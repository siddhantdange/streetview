//
//  ViewController.m
//  StreetView
//
//  Created by Siddhant Dange on 8/27/13.
//  Copyright (c) 2013 Siddhant Dange. All rights reserved.
//

#import "MainViewController.h"

#import <AddressBook/AddressBook.h>

@interface MainViewController ()

//CL
@property (nonatomic, strong) CLLocationManager *locationManager;                                            
@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, strong) CLPlacemark *latestPlace;

//IB 
@property (weak, nonatomic) IBOutlet UITextView *streetText;
@property (weak, nonatomic) IBOutlet UITextView *cityText;
@property (strong, nonatomic) IBOutlet UIView *cameraView;


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
    
    //StreetView
    self.counter = 0;
    
    //UI
    UIToolbar *streetBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.streetText.frame.size       .width, self.streetText.frame.size.height)];
    [streetBar setBarTintColor:[UIColor blackColor]];
    [self.streetText addSubview:streetBar];
    [self.streetText sendSubviewToBack:streetBar];
    
    UIToolbar *cityBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.cityText.frame.size.width, self.cityText.frame.size.height)];
    [cityBar setBarTintColor:[UIColor blackColor]];
    [self.cityText addSubview:cityBar];
    [self.cityText sendSubviewToBack:cityBar];
    
    //----- SHOW LIVE CAMERA PREVIEW -----
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetMedium;
	
	CALayer *viewLayer = self.cameraView.layer;
	NSLog(@"viewLayer = %@", viewLayer);
	
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
	
	captureVideoPreviewLayer.frame = self.cameraView.bounds;
	[self.cameraView.layer addSublayer:captureVideoPreviewLayer];
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];   
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
	
	[session startRunning];
    //StreetView
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
        [self.geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks,                    NSError *error) {
            
            //if place exists 
            if(placemarks && placemarks.count){
                self.latestPlace = placemarks[0];
                
                //set street
                [self.streetText setText:self.latestPlace.addressDictionary[(__bridge NSString*)    kABPersonAddressStreetKey]];
                
                //set city
                [self.cityText setText:self.latestPlace.addressDictionary[(__bridge NSString*)   kABPersonAddressCityKey]];
            }
        }];
    }
    
    self.counter++;
}


- (IBAction)getData:(id)sender {
    
    //street
    [self.streetText setText:self.latestPlace.addressDictionary[(__bridge NSString*)    kABPersonAddressStreetKey]];
    
    //city
    [self.cityText setText:self.latestPlace.addressDictionary[(__bridge NSString*)   kABPersonAddressCityKey]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
