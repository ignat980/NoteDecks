//
//  INDDDeckCell.m
//  NoteDecks
//
//  Created by Ignat Remizov on 8/6/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "INDDDeckCell.h"

@implementation INDDDeckCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.cardAmount = [[UITextField alloc]initWithFrame:CGRectMake(14, 14, 100, 100)];
        self.cardAmount.textAlignment = NSTextAlignmentCenter;
        [self.cardAmount setFont:[UIFont fontWithName:@"Helvetica Neue" size:30]];
        self.cardAmount.text = @"0";
        [self.cardAmount setUserInteractionEnabled:NO];
        [self addSubview:self.cardAmount];
    }
    return self;
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
