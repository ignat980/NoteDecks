//
//  INDViewController.h
//  NoteDecks
//
//  Created by Ignat Remizov on 7/23/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INDViewController : UIViewController
- (IBAction) dismissKeyboardOnTap:(id)sender;
- (void) saveCards;
@property(nonatomic, strong) NSNumber *deckIndex;
@property(nonatomic, strong) NSMutableArray *cards; //May no longer be needed, as tempDecks passes info
@property(nonatomic, strong) NSMutableArray *tempDecks; //Needs it to Save, And to pass information
@end
