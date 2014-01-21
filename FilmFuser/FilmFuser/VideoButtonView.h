//
//  VideoButtonView.h
//  FilmFuser
//
//  Created by Zal Bhathena on 1/20/14.
//  Copyright (c) 2014 Zal Bhathena. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VideoButtonViewDelegate <NSObject>

- (void)respondToDelete: (id)sender;

- (void)respondToSwap: (id)sender withRelativeSwapIndex:(int)relativeIndex;

@end

@interface VideoButtonView : UIView

- (id)initWithFrame:(CGRect)frame withImage: (UIImage*) image;

@property (retain, nonatomic) UIButton *videoButton;

@property(nonatomic,assign)id<VideoButtonViewDelegate> delegate;

@end
