//
//  INDCardCell.m
//  NoteDecks
//
//  Created by Ignat Remizov on 8/1/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "INDCardCell.h"
#import "INDViewController.h"

@implementation INDCardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
        self.cellTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notecard.png"]];
        self.cellTextView.textContainerInset = UIEdgeInsetsMake(0, 3, 0, 0);
        self.cellTextView.textContainer.lineFragmentPadding = 0;
        UIImageView *topCardColor = [[UIImageView alloc] initWithFrame:CGRectMake(0,-10,300, 36)];
        topCardColor.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notecard-top.png"]];
        [self.cellTextView insertSubview:topCardColor atIndex:0];
        self.cellTextView.font = [UIFont fontWithName:@"Helvetica"  size:20.1];
        [self.contentView addSubview:self.cellTextView];
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
