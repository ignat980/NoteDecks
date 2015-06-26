//
//  INDViewController.m
//  NoteDecks
//
//  Created by Ignat Remizov on 7/23/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//  

#import "INDViewController.h"
#import "INDDViewController.h"
#import "INDCardCell.h"

@interface INDViewController () <UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
//@property(nonatomic, weak) IBOutlet UITextView *textView; //The card
@property(nonatomic, weak) IBOutlet UIButton *currentCardButton; //Basicaly "menu button", but it displays the current card info
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView; // Collection view :)
@property(nonatomic, strong) NSNumber *currentCard; //Needs to keep track of the Current card
@property(nonatomic, strong) NSNumber *tempCurrentCard; //Needs to move around Cards, and for creating a Card
@property(nonatomic, strong) NSNumber *tempDeckIndex; //Needs to move around Decks, and for creating a Deck
@end
#pragma mark -
@implementation INDViewController
#pragma mark View loading/unloading
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.45];
    [self loadCards];
    [self showCard:0];
    [self.collectionView registerClass:[INDCardCell class] forCellWithReuseIdentifier:@"CardCell"];
    [self.collectionView setPagingEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveCards];
}

#pragma mark Text view
-(void)textViewDidChange:(UITextView *)textView
{
    for (int i = 0 ; i < self.collectionView.visibleCells.count; i++) {
        NSIndexPath *cardPath =[self.collectionView indexPathsForVisibleItems][i];
        if (cardPath.item == self.currentCard.integerValue)
        {
            INDCardCell *cell = (INDCardCell *)[self.collectionView cellForItemAtIndexPath:cardPath];
            cell.cellTextView.text = textView.text;
        }
    }
    [self saveCards];
}

///Makes the keyboard go away
-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [self.view endEditing:YES];
    [self saveCards];
}

#pragma mark -
#pragma mark ⚠view

///CurrentCardButton handler, shows a menu of options
-(IBAction)optionMenu:(id)sender {
    UIActionSheet *actionMenu = [[UIActionSheet alloc] initWithTitle:@"The Menu"
                                                            delegate:self
                                                   cancelButtonTitle:@"Close"
                                              destructiveButtonTitle:[self whichString]
                                                   otherButtonTitles:@"Add a card",@"Go to a card",@"Go to a deck",@"Randomize Deck",nil];
    [actionMenu showInView:self.view];
}
#pragma mark Main menu conifg
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.destructiveButtonIndex == -1) {
        buttonIndex++;
    }
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        if (self.cards.count == 0) {
            //[self.tempDecks removeObjectAtIndex:self.deckIndex.integerValue];
            self.deckIndex = @(self.deckIndex.integerValue - 1);
            self.cards = self.tempDecks[self.deckIndex.integerValue];
            [self showCard:0];
            return;
        }
        [self.cards removeObjectAtIndex:self.currentCard.integerValue];
        if (self.cards.count == 0) {
            //[self.tempDecks removeObjectAtIndex:self.deckIndex.integerValue];
            self.deckIndex = @(self.deckIndex.integerValue - 1);
            self.cards = self.tempDecks[self.deckIndex.integerValue];
            [self showCard:0];
        } else if (self.currentCard.integerValue == 0){
            [self showCard:self.currentCard.integerValue];
        } else {
            [self showCard:self.currentCard.integerValue - 1];
        }
    } else if (buttonIndex == 1){
        [self.cards addObject:@""];
        [self showCard:self.cards.count - 1];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Card Added"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Ok!"
                                              otherButtonTitles:nil];
        [alert show];
    } else if (buttonIndex == 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Goto which card?"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    } else if (buttonIndex == 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Goto which deck?"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    } else if (buttonIndex == 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                        message:@"This cannot be undone"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes",nil];
        [alert show];
    }
    [self saveCards];
}

//AlertView handler.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.tempDeckIndex = self.deckIndex;
        self.tempCurrentCard = self.currentCard;
        //Sadly no switch statements for text :/ ...yet ;)
        NSString *lookup = alertView.title;
        typedef void (^CaseBlock)();
        NSDictionary *d = @{
                            @"Goto which card?":
                                ^{
                                    self.currentCard = @([[alertView textFieldAtIndex:0].text integerValue] - 1);
                                    if (self.currentCard && (self.currentCard.integerValue < self.cards.count)) {
                                        [self showCard:self.currentCard.integerValue];
                                    } else if (self.currentCard.integerValue <= 0) {
                                        self.currentCard = @(0);
                                        [self showCard:0];
                                    } else if (self.currentCard.integerValue >= self.cards.count) {
                                        self.currentCard = self.tempCurrentCard;
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Card does not exist"
                                                                                        message:@""
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"Ok :("
                                                                              otherButtonTitles:@"Create a new card?", nil];
                                        [alert show];
                                    }
                                },
                            @"Card does not exist":
                                ^{
                                    [self.cards addObject:@""];
                                    [self showCard:self.cards.count - 1];
                                },
                            @"Goto which deck?":
                                ^{
                                    self.deckIndex = @([[alertView textFieldAtIndex:0].text integerValue] - 1);
                                    if (self.deckIndex && (self.deckIndex.integerValue < self.tempDecks.count)) {
                                        self.cards = self.tempDecks[self.deckIndex.integerValue];
                                        [self showCard:0];
                                    } else if (self.deckIndex.integerValue <= 0) {
                                        self.deckIndex = @(0);
                                        [self showCard:0];
                                    } else if (self.deckIndex.integerValue >= self.tempDecks.count) {
                                        self.deckIndex = self.tempDeckIndex;
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deck does not exist"
                                                                                        message:@""
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"Ok :("
                                                                              otherButtonTitles:@"Create a new deck?", nil];
                                        [alert show];
                                    }
                                },
                            @"Deck does not exist":
                                ^{
                                    [self.tempDecks addObject:[@[@""]mutableCopy]];
                                    self.cards = self.tempDecks[self.tempDecks.count-1];
                                    self.deckIndex = @(self.tempDecks.count - 1);
                                    [self showCard:0];
                                },
                            @"Are you sure?":
                                ^{
                                    self.cards=[self shuffleCards:self.cards];
                                    [self showCard:0];
                                }
                            };
        ((CaseBlock)d[lookup])();
        [self saveCards];
    } else if (buttonIndex == 0) {
        if ([alertView.title isEqualToString:@"Deck does not exist"]) {
            self.deckIndex = self.tempDeckIndex;
        } else if ([alertView.title isEqualToString:@"Card does not exist"]) {
            self.currentCard = self.tempCurrentCard;
        }
    }
}

#pragma mark -
#pragma mark Card Control ಠ_ಠ
//Switched to a CollectionView based layout
///Updates "current" variables and shows the text in the text view from a card
///@param card Which card to focus to
- (void) showCard:(NSInteger)card
{
    self.currentCard = @(card);
    [self.currentCardButton setTitle:[NSString stringWithFormat:@"%li / %lu in deck %li",
                                      (long)[self whichNumber],(unsigned long)self.cards.count,
                                      self.deckIndex.integerValue + 1] forState:UIControlStateNormal];
    //[self.textView setText:self.cards[card]];
    [self.collectionView reloadData];
}

///Reads the plist and stores the data into an array called tempDecks
-(void) loadCards
{
    //Read the plist :)
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %lu", errorDesc, format);
    }
    //self.tempDecks = [NSMutableArray arrayWithArray:[temp objectForKey:@"Decks"]];
    self.tempDecks = [temp objectForKey:@"Decks"];
    if (self.deckIndex.integerValue >= self.tempDecks.count) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deck does not exist"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Ok :("
                                              otherButtonTitles:@"Create a new deck?", nil];
        [alert show];
    } else {
        self.cards = self.tempDecks[self.deckIndex.integerValue];
    }
}

#pragma mark  save whenever ¯\_(ツ)_/¯
//Save to the plist  :)

-(void) saveCards
{
    for (int i = 0 ; i < self.collectionView.visibleCells.count; i++) {
        NSIndexPath *cardPath =[self.collectionView indexPathsForVisibleItems][i];
        INDCardCell *cell = (INDCardCell *)[self.collectionView cellForItemAtIndexPath:cardPath];
        self.cards[cardPath.item] = cell.cellTextView.text;
    }
    //self.cards[self.currentCard.integerValue] = self.textView.text;
    self.tempDecks[self.deckIndex.integerValue] = self.cards;
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.tempDecks, nil]
                                                          forKeys:[NSArray arrayWithObjects: @"Decks", nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else {
        NSLog(@"Error saving plist: %@", error);
    }
}

-(NSMutableArray*) shuffleCards:(NSMutableArray *)cards {
    
    NSUInteger count = cards.count;
    for (NSUInteger i = 0; i < count; ++i) {
        [cards exchangeObjectAtIndex:i withObjectAtIndex:i + arc4random_uniform((int)(count - i))];
    }
    return cards;
}

-(NSInteger)whichNumber
{
    if (self.cards.count == 0)
    {
        return 0;
    } else {
        return self.currentCard.integerValue + 1;
    }
}

-(NSString*)whichString
{
    if (self.cards.count == 0) {
        return nil;
    } else {
        return @"Delete Card D:";
    }
}

#pragma mark -
#pragma mark CollectionView
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.cards.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    INDCardCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    cell.cellTextView.text = self.cards[indexPath.item];
    cell.backgroundColor = [UIColor clearColor];
    self.currentCard = @(indexPath.item);
    [self.currentCardButton setTitle:[NSString stringWithFormat:@"%li / %lu in deck %li",self.currentCard.integerValue + 1,(unsigned long)self.cards.count, self.deckIndex.integerValue + 1] forState:UIControlStateNormal];
    return cell;
}

/*- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Nothing (?)
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Nothing (?)
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(310, 180);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 0);
}

@end
