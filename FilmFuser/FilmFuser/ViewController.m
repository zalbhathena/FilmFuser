//
//  ViewController.m
//  FilmFuser
//
//  Created by Zal Bhathena on 1/19/14.
//  Copyright (c) 2014 Zal Bhathena. All rights reserved.
//

#import "ViewController.h"

#ifndef MIN
#import <NSObjCRuntime.h>
#endif
#import "VideoScrollView.h"
@interface ViewController ()

@end

@implementation ViewController


@synthesize scrollView, addVideoButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.shouldRotate = YES;
        [self.view bringSubviewToFront: self.addVideoButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setScrollViewContentSize];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonAdded: (UIImage*)image withMininumSize: (CGSize) minimumSize{
    
}

- (IBAction)addVideoButtonPressed:(id)sender {
    [self video];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
    
    return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [scrollView setScrollViewContentSize];
    
}

- (void)video {
    self.shouldRotate = NO;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,      nil];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    NSString* moviePath = nil;
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        // NSLog(@"%@",moviePath);
        //NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        
        /*if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
        }*/
    }
    
    NSURL* sourceMovieURL = [NSURL fileURLWithPath:moviePath];
    AVURLAsset* sourceAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    AVAssetImageGenerator* imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:sourceAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(0, 1);
    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime: time actualTime:NULL error:NULL]];
    [self.scrollView buttonAdded:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[picker release];
}

- (void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
    self.shouldRotate = YES;
}

- (BOOL)shouldAutorotate {
    return self.shouldRotate;
}

@end
