//
//  INDDViewController.h
//  NoteDecks
//
//  Created by Ignat Remizov on 7/28/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INDDViewController : UIViewController
@property(nonatomic, strong) NSMutableArray *decks;
- (IBAction) unwindToMain:(UIStoryboardSegue*)segue;
@end
