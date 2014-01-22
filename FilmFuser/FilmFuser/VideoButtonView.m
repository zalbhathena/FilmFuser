//
//  VideoButtonView.m
//  FilmFuser
//
//  Created by Zal Bhathena on 1/20/14.
//  Copyright (c) 2014 Zal Bhathena. All rights reserved.
//

#import "VideoButtonView.h"

#define DELETE_BUTTON_LENGTH 5

@implementation VideoButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.videoButton = [[UIButton alloc] init];
        self.activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [self.activityView startAnimating];
        self.activityView.center = self.videoButton.center;
        
        [self addSubview:self.videoButton];
        [self.videoButton addSubview:self.activityView];
        
        [self.videoButton setBackgroundColor:[UIColor blackColor]];
        
        UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
        UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
        UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
        UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
        
        swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self addGestureRecognizer:swipeUpGestureRecognizer];
        [self addGestureRecognizer:swipeDownGestureRecognizer];
        [self addGestureRecognizer:swipeLeftGestureRecognizer];
        [self addGestureRecognizer:swipeRightGestureRecognizer];
        
    }
    return self;
}

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        if([self.delegate respondsToSelector:@selector(respondToSwap:withRelativeSwapIndex:)])
        {
            [self.delegate respondToSwap:self withRelativeSwapIndex:-1];
        }
    }
    else {
        CGRect frame = self.frame;
        frame = CGRectMake(frame.origin.x, -1*frame.size.height - 10, frame.size.height, frame.size.width);
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             self.frame = frame;
                         }
                         completion:^(BOOL finished){
                            [self deletePressed:nil];
                         }];
    }
}
- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        if([self.delegate respondsToSelector:@selector(respondToSwap:withRelativeSwapIndex:)])
        {
            [self.delegate respondToSwap:self withRelativeSwapIndex:1];
        }
    }
    else {
        CGRect frame = self.frame;
        frame = CGRectMake(frame.origin.x, self.superview.frame.size.height, frame.size.height, frame.size.width);
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             self.frame = frame;
                         }
                         completion:^(BOOL finished){
                             [self deletePressed:nil];
                         }];
    }
}
- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        CGRect frame = self.frame;
        frame = CGRectMake(-1*frame.size.width - 10, frame.origin.y, frame.size.height, frame.size.width);
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             self.frame = frame;
                         }
                         completion:^(BOOL finished){
                             [self deletePressed:nil];
                         }];
    }
    else {
        if([self.delegate respondsToSelector:@selector(respondToSwap:withRelativeSwapIndex:)])
        {
            [self.delegate respondToSwap:self withRelativeSwapIndex:-1];
        }
    }
}
- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        CGRect frame = self.frame;
        frame = CGRectMake(self.superview.frame.size.width, frame.origin.y, frame.size.height, frame.size.width);
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             self.frame = frame;
                         }
                         completion:^(BOOL finished){
                             [self deletePressed:nil];
                         }];
    }
    else {
        if([self.delegate respondsToSelector:@selector(respondToSwap:withRelativeSwapIndex:)])
        {
            [self.delegate respondToSwap:self withRelativeSwapIndex:1];
        }
    }
}

-(void)deletePressed: (id)sender {
    if([self.delegate respondsToSelector:@selector(respondToDelete:)])
    {
        //send the delegate function with the amount entered by the user
        [self.delegate respondToDelete:self];
        [self removeFromSuperview];
    }
    
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect video_frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self.videoButton setFrame:video_frame];
    
    
    self.activityView.center = self.videoButton.center;
}

-(void)addVideoAsset:(AVAsset*)new_asset {
    self.videoAsset = new_asset;
    AVAssetImageGenerator* imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:new_asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(0, 1);
    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime: time actualTime:NULL error:NULL]];
    [self.videoButton setBackgroundImage:image
                                forState:UIControlStateNormal];
    [self.activityView removeFromSuperview];
    self.activityView = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
