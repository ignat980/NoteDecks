//
//  INDDViewController.m
//  NoteDecks
//
//  Created by Ignat Remizov on 7/28/14.
//  Copyright (c) 2014 Fuzz Productions. All rights reserved.
//

#import "INDDViewController.h"
#import "INDViewController.h"
#import "INDDDeckCell.h"

@interface INDDViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSNumber *tempDeckIndex;
@property(nonatomic, retain) NSMutableArray *cards;
@end

@implementation INDDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ShelfTile.png"]];
    [self.collectionView registerClass:[INDDDeckCell class] forCellWithReuseIdentifier:@"DeckCell"];
    [self loadDecks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadDecks
{
    //Read all the info from the plist, then show up in the collectionView
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
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
        NSLog(@"Error reading plist: %@, format: %lu", errorDesc, (unsigned long)format);
    }
    self.decks = [NSMutableArray arrayWithArray:[temp objectForKey:@"Decks"]];
    [self.collectionView reloadData];
}

-(void)saveCards
{
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.decks, nil]
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

//Was the temporary button that brings up a card
/*
 -(IBAction)DeckButtonTapped:(id)sender {
 //Save current cards //update:No need to, this is initial state
 //self.cards = [@[@""] mutableCopy];
 //[self.decks addObject:self.cards]; //if (insert) {insertObject:self.cards atIndex:(self.currentDeck + 1);}
 INDViewController* indViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"CardViewController"];
 self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
 [self presentViewController:indViewController animated:YES completion:^{
 indViewController.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height + 10);
 [UIView animateWithDuration:1.0 animations:^{
 indViewController.view.transform = CGAffineTransformIdentity;
 }];
 }];
 [self.collectionView reloadData];
 } */

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return 50;//self.decks.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    INDDDeckCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"DeckCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ShelfTile.png"]];
    if (indexPath.item >= self.decks.count) {
        cell.cardAmount.text = @"0";
    } else {
        cell.cardAmount.text = [NSString stringWithFormat:@"%lu",(unsigned long)((NSMutableArray *) self.decks[indexPath.item]).count];
    }
    return cell;
}

/*- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark ಠ_ಠ
- (BOOL) array:(NSArray*)array1 isEqualToArray:(NSArray*)array2
{
    
    if (array1.count != array2.count) return false;
    for (int i = 0; i < array1.count; ++i) {
        if (![array1[i] isEqual:array2[i]])
            return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Start Card with specific Deck data
    // Is way easier to do... I think.
    // self.tempDeckIndex = @([indexPath indexAtPosition:1]); ?
    if (indexPath.item >= self.decks.count) {
        for (NSUInteger i = self.decks.count; i <= indexPath.item; i++) {
            [self.decks addObject:[@[]mutableCopy]];
        }
    }
    if (((NSMutableArray*)self.decks[indexPath.item]).count == 0) {
        self.decks[indexPath.item] =[@[[NSString stringWithFormat:@"Card 1 from %li", (long)indexPath.item]]mutableCopy];
    }
    [self saveCards];
    INDViewController* indViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"CardViewController"];
    indViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext; //Set presentation style on PRESENTED controller :)
    [indViewController setDeckIndex:@(indexPath.item)];
    
    [self presentViewController:indViewController animated:YES completion:nil];/*^{
        indViewController.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height + 10);
        [UIView animateWithDuration:1.0 animations:^{
            indViewController.view.transform = CGAffineTransformIdentity;
        }];
    }];*/
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(128, 128);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(16, 24, 24, 16);
}

-  (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //[segue.destinationViewController setDeckIndex:@(0)];
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue
{
    self.decks = [(INDViewController *)segue.sourceViewController tempDecks];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [self.collectionView reloadData];
}

@end
