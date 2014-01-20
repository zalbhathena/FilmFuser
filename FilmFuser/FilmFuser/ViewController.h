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



@property (strong, nonatomic) IBOutlet UIButton *addVideoButton;

@property (strong, nonatomic) IBOutlet VideoScrollView *scrollView;

@end
