//
//  VideoScrollView.m
//  FilmFuser
//
//  Created by Zal Bhathena on 1/19/14.
//  Copyright (c) 2014 Zal Bhathena. All rights reserved.
//

#import "VideoScrollView.h"

@implementation VideoScrollView


#define BUTTON_SIDE_LENGTH 60
#define BUTTON_BUFFER_LENGTH 10
#define INSET_HEIGHT 0
#define INSET_WIDTH 0

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.buttonArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.buttonArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        self.buttonArray = [[NSMutableArray alloc] init];
    }
    return self;
}


-(BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if([view class] == [UIButton class])
        return true;
    return [super touchesShouldCancelInContentView:view];
}

- (void)setScrollViewContentSize {
    CGSize minimumSize = self.frame.size;
    
    float scrollViewWidth = self.frame.size.width;
    float buttons_per_row = scrollViewWidth / (BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH);
    float num_rows = ceil([self.buttonArray count] / floorf( buttons_per_row ));
    
    self.contentInset = UIEdgeInsetsMake(INSET_HEIGHT, INSET_WIDTH, INSET_HEIGHT, INSET_WIDTH);
    
    CGFloat min_height = minimumSize.height - INSET_HEIGHT*2;
    CGFloat acutal_height = (BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH) * num_rows + BUTTON_BUFFER_LENGTH;
    CGFloat contentHeight = MAX(acutal_height, min_height);
    CGSize temp_size = CGSizeMake(minimumSize.width, contentHeight);
    self.contentSize = temp_size;
    [self setButtonLocations];
}

- (void)setButtonLocations {
    float scrollViewWidth = self.frame.size.width;
    float buttons_per_row = scrollViewWidth / (BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH);
    
    int count = 0;
    for(VideoButtonView *button in self.buttonArray) {
        CGPoint point = CGPointMake(count % (int)buttons_per_row, floorf(count / (int)buttons_per_row));
        [self setButtonLocation: button withLocation:point];
        count++;
    }
}

- (void)buttonAdded: (UIImage*)image{
    int scrollViewWidth = self.frame.size.width;
    int buttons_per_row = scrollViewWidth / (BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH);

    int button_count = [self.buttonArray count];
    CGFloat button_x = (CGFloat)(button_count % buttons_per_row)*(BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH) + BUTTON_BUFFER_LENGTH;
    CGFloat button_y = (CGFloat)floor(button_count / buttons_per_row)*(BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH) + BUTTON_BUFFER_LENGTH;

    VideoButtonView* temp_button_view = [[VideoButtonView alloc] initWithFrame:CGRectMake(button_x, button_y, BUTTON_SIDE_LENGTH, BUTTON_SIDE_LENGTH)];
    temp_button_view.delegate = self;
    
    [self addSubview:temp_button_view];

    [self.buttonArray addObject:temp_button_view];

    CGPoint point = CGPointMake(button_count % (int)buttons_per_row, floorf(button_count / (int)buttons_per_row));
    [self setButtonLocation: temp_button_view withLocation:point];
    [self setScrollViewContentSize];
}

- (void)setButtonLocation: (VideoButtonView*)videoButton withLocation: (CGPoint)location {
    float scrollViewWidth = self.frame.size.width;
    float buttons_per_row = floorf(scrollViewWidth / (BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH));
    //float num_rows = 0;
    //num_rows = ceil([self.buttonArray count] / floorf( buttons_per_row ));
    
    float offset = scrollViewWidth - (BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH)*buttons_per_row -BUTTON_BUFFER_LENGTH;
    offset/=2;
    
    CGFloat button_x = (CGFloat)(location.x)*(BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH) + BUTTON_BUFFER_LENGTH + offset;
    CGFloat button_y = (CGFloat)(location.y)*(BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH) + BUTTON_BUFFER_LENGTH;
    
    videoButton.frame = CGRectMake(button_x, button_y, BUTTON_SIDE_LENGTH, BUTTON_SIDE_LENGTH);
}

- (void)respondToDelete: (id)sender
{
    [self.buttonArray removeObject:sender];
    [self setButtonLocations];
    
}

- (void)setFrame:(CGRect)frame  {
    [super setFrame:frame];
    [self setScrollViewContentSize];
}

@end
