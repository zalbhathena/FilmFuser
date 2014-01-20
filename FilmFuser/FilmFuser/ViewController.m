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
        
        [self.view bringSubviewToFront: self.addVideoButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setScrollViewContentSize:self.view.frame.size];
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
    [self.scrollView buttonAdded:nil withMinimumSize: self.view.frame.size];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
    
    return NO;
}

@end
