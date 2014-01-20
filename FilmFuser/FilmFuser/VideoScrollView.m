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

- (void)setScrollViewContentSize: (CGSize) minimumSize {
    float scrollViewWidth = self.frame.size.width;
    float buttons_per_row = scrollViewWidth / (BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH);
    float num_rows = 0;
    num_rows = ceil([self.buttonArray count] / floorf( buttons_per_row ));
    
    float offset = scrollViewWidth - (BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH)*buttons_per_row + BUTTON_BUFFER_LENGTH;
    offset/=2;
    
    int count = 0;
    for(UIButton *button in self.buttonArray) {
        CGFloat button_x = (CGFloat)(count % (int)buttons_per_row)*(BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH) + BUTTON_BUFFER_LENGTH + offset;
        CGFloat button_y = (CGFloat)floorf(count / (int)buttons_per_row)*(BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH) + BUTTON_BUFFER_LENGTH;
        
        button.frame = CGRectMake(button_x, button_y, BUTTON_SIDE_LENGTH, BUTTON_SIDE_LENGTH);
        
        count++;
    }
    
    self.contentInset = UIEdgeInsetsMake(INSET_HEIGHT, INSET_WIDTH, INSET_HEIGHT, INSET_WIDTH);
    
    CGFloat min_width = minimumSize.height - INSET_HEIGHT*2;
    CGFloat acutal_width = (BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH) * num_rows + BUTTON_BUFFER_LENGTH;
    CGFloat contentHeight = MAX(acutal_width, min_width);
    CGSize temp_size = CGSizeMake(minimumSize.width, contentHeight);
    self.contentSize = temp_size;
}

- (void)buttonAdded: (UIImage*)image withMinimumSize: (CGSize) minimumSize {
    int scrollViewWidth = self.frame.size.width;
    int buttons_per_row = scrollViewWidth / (BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH);

    int button_count = [self.buttonArray count];
    CGFloat button_x = (CGFloat)(button_count % buttons_per_row)*(BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH) + BUTTON_BUFFER_LENGTH;
    CGFloat button_y = (CGFloat)floor(button_count / buttons_per_row)*(BUTTON_SIDE_LENGTH + BUTTON_BUFFER_LENGTH) + BUTTON_BUFFER_LENGTH;

    UIButton* temp_button = [[UIButton alloc] initWithFrame:CGRectMake(button_x, button_y, BUTTON_SIDE_LENGTH, BUTTON_SIDE_LENGTH)];

    [temp_button setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:temp_button];

    [self.buttonArray addObject:temp_button];

    [self setScrollViewContentSize:minimumSize];
}

@end
