//
//  ViewController.h
//  FilmFuser
//
//  Created by Zal Bhathena on 1/19/14.
//  Copyright (c) 2014 Zal Bhathena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoScrollView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ViewController : UIViewController<UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (retain, nonatomic) IBOutlet UIButton *addVideoButton;

@property (retain, nonatomic) IBOutlet UIButton *mergeVideoButton;

@property (retain, nonatomic) IBOutlet VideoScrollView *scrollView;

@property BOOL shouldRotate;

@property (retain, nonatomic) __block UIAlertView* alert;

@end
