//
//  VideoScrollView.m
//  FilmFuser
//
//  Created by Zal Bhathena on 1/19/14.
//  Copyright (c) 2014 Zal Bhathena. All rights reserved.
//

#import "VideoScrollView.h"

@implementation VideoScrollView

#define BUTTON_BUFFER_LENGTH 30
#define BUTTON_SIDE_LENGTH self.frame.size.width - BUTTON_BUFFER_LENGTH
#define INSET_HEIGHT 0
#define INSET_WIDTH 0

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.buttonArray = [[NSMutableArray alloc] init];
        self.delaysContentTouches = NO;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.buttonArray = [[NSMutableArray alloc] init];
        self.delaysContentTouches = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        self.buttonArray = [[NSMutableArray alloc] init];
        self.delaysContentTouches = NO;
    }
    return self;
}


-(BOOL)touchesShouldCancelInContentView:(UIView *)view {
    /*if([view class] == [UIButton class])
        return true;*/
    return [super touchesShouldCancelInContentView:view];
}

- (void)setScrollViewContentSize {
    CGSize minimumSize = self.frame.size;
    
    BOOL isPortrait = minimumSize.width < minimumSize.height;
    
    float button_size;
    CGSize contentSize;
    if (isPortrait) {
        button_size = minimumSize.width/2;
        
        float min_height = minimumSize.height -  INSET_HEIGHT*2;
        float actual_height = (button_size + BUTTON_BUFFER_LENGTH) * [self.buttonArray count] + BUTTON_BUFFER_LENGTH;
        float content_height = MAX(min_height, actual_height);
        contentSize = CGSizeMake(minimumSize.width, content_height);
    }
    else {
        button_size = minimumSize.height/2;
        float min_width = minimumSize.width - INSET_HEIGHT*2;
        float actual_width = (button_size + BUTTON_BUFFER_LENGTH) * [self.buttonArray count] + BUTTON_BUFFER_LENGTH;
        float content_width = MAX(min_width, actual_width);
        contentSize = CGSizeMake(content_width, minimumSize.height);
    }
    
    self.contentSize = contentSize;
    [self setButtonLocations];
}

- (void)setButtonLocations {
    int count = 0;
    for(VideoButtonView *button in self.buttonArray) {
        button.frame = [self getButtonFrame:count];
        count++;
    }
}

- (VideoButtonView*)buttonAdded{
    int button_count = [self.buttonArray count];

    VideoButtonView* temp_button_view = [[VideoButtonView alloc] initWithFrame:[self getButtonFrame:button_count]];
    temp_button_view.delegate = self;
    
    [self addSubview:temp_button_view];

    [self.buttonArray addObject:temp_button_view];

    [self setScrollViewContentSize];
    return temp_button_view;
}

- (CGRect)getButtonFrame: (int)index {
    CGSize frameSize = self.frame.size;
    BOOL isPortrait = frameSize.width < frameSize.height;
    if (isPortrait) {
        float button_size = frameSize.width/2;
        float button_y = BUTTON_BUFFER_LENGTH + index * (button_size + BUTTON_BUFFER_LENGTH);
        return CGRectMake(frameSize.width/4, button_y, button_size, button_size);
    }
    else {
        float button_size = frameSize.height/2;
        float button_x = BUTTON_BUFFER_LENGTH + index * (button_size + BUTTON_BUFFER_LENGTH);
        return CGRectMake(button_x, frameSize.height/4, button_size, button_size);
    }
}

- (void)respondToDelete: (id)sender
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         [self.buttonArray removeObject:sender];
                         [self setButtonLocations];
                     }
                     completion:^(BOOL finished){
                         [self setScrollViewContentSize];
                     }];
    
    
}

- (void)respondToSwap: (id)sender withRelativeSwapIndex:(int)relativeIndex {
    int index = [self.buttonArray indexOfObject:sender];
    int other_index = relativeIndex + index;
    if (other_index < 0 || other_index >= self.buttonArray.count)
        return;
    VideoButtonView* other_object = (VideoButtonView*)[self.buttonArray objectAtIndex:other_index];
    [self.buttonArray replaceObjectAtIndex:index withObject:other_object];
    [self.buttonArray replaceObjectAtIndex:other_index withObject:sender];
    
    CGRect temp_frame = other_object.frame;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         other_object.frame = ((VideoButtonView*)sender).frame;
                         ((VideoButtonView*)sender).frame = temp_frame;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)setFrame:(CGRect)frame  {
    [super setFrame:frame];
    [self setScrollViewContentSize];
}

@end
