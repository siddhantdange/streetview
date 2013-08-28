//
//  ViewController.h
//  StreetView
//
//  Created by Siddhant Dange on 8/27/13.
//  Copyright (c) 2013 Siddhant Dange. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@interface MainViewController : UIViewController <CLLocationManagerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@end
