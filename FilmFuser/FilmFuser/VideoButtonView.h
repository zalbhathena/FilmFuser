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

@end

@interface VideoButtonView : UIView


@property (retain, nonatomic) UIButton *videoButton;
@property (retain, nonatomic) UIButton *deleteButton;

@property(nonatomic,assign)id<VideoButtonViewDelegate> delegate;

@end
