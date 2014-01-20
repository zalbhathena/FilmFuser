//
//  ViewController.h
//  FilmFuser
//
//  Created by Zal Bhathena on 1/19/14.
//  Copyright (c) 2014 Zal Bhathena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoScrollView.h"

@interface ViewController : UIViewController<UIScrollViewDelegate>



@property (retain, nonatomic) IBOutlet UIButton *addVideoButton;

@property (retain, nonatomic) IBOutlet VideoScrollView *scrollView;

@end
