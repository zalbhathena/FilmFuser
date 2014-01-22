//
//  VideoScrollView.h
//  FilmFuser
//
//  Created by Zal Bhathena on 1/19/14.
//  Copyright (c) 2014 Zal Bhathena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoButtonView.h"

@interface VideoScrollView: UIScrollView <VideoButtonViewDelegate>

@property (retain, nonatomic)          NSMutableArray *buttonArray;

- (void)setScrollViewContentSize;
- (VideoButtonView*)buttonAdded;
- (void)respondToDelete:(id)sender;

- (void)respondToSwap: (id)sender withRelativeSwapIndex:(int)relativeIndex;

@end
