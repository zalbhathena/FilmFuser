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
        [self.videoButton setBackgroundColor:[UIColor blueColor]];
        
        self.deleteButton = [[UIButton alloc] init];
        
        [self setFrame:frame];
        
        [self.deleteButton addTarget:self action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.deleteButton setBackgroundImage:[[UIImage imageNamed:@"delete_button.png"]
                                              stretchableImageWithLeftCapWidth:8.0f
                                              topCapHeight:0.0f]
                                            forState:UIControlStateNormal];
        
        [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        self.deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:6];
        self.deleteButton.titleLabel.shadowColor = [UIColor lightGrayColor];
        self.deleteButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        
        [self addSubview:self.videoButton];
        [self addSubview:self.deleteButton];
        
        [self bringSubviewToFront:self.deleteButton];
        
    }
    return self;
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
    [self.videoButton setBackgroundColor:[UIColor blueColor]];
    
    CGFloat delete_y = frame.size.height - 15;
    CGRect deleteFrame = CGRectMake(10, delete_y, 40, 10);
    [self.deleteButton setFrame:deleteFrame];
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
