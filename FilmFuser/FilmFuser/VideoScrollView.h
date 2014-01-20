//
//  VideoScrollView.h
//  FilmFuser
//
//  Created by Zal Bhathena on 1/19/14.
//  Copyright (c) 2014 Zal Bhathena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoScrollView : UIScrollView

@property (strong, nonatomic)          NSMutableArray *buttonArray;

- (void)setScrollViewContentSize: (CGSize) minimumSize;
- (void)buttonAdded: (UIImage*)image withMinimumSize: (CGSize) minimumSize;

@end
