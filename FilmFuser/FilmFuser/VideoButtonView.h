//
//  VideoButtonView.h
//  FilmFuser
//
//  Created by Zal Bhathena on 1/20/14.
//  Copyright (c) 2014 Zal Bhathena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoButtonViewDelegate <NSObject>

- (void)respondToDelete: (id)sender;

- (void)respondToSwap: (id)sender withRelativeSwapIndex:(int)relativeIndex;

@end

@interface VideoButtonView : UIView

-(void)addVideoAsset:(AVURLAsset*)new_asset;

@property (retain, nonatomic) UIActivityIndicatorView* activityView;
 
@property (retain, nonatomic) UIButton *videoButton;

@property(nonatomic,assign)id<VideoButtonViewDelegate> delegate;

@property (nonatomic, retain) AVURLAsset* videoAsset;

@property (nonatomic, retain) UIImageView* imageView;

@end
