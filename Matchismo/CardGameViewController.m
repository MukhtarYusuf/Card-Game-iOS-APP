//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 7/7/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *isOnLabel;
@property (weak, nonatomic) IBOutlet UISwitch *threeCardGameSwitch;
@end

@implementation CardGameViewController

int gameModeNumber = 0;
long score = 0;
long oldScore = 0;

NSInteger chosenButtonIndex = 0;
NSAttributedString *attributedTitle;
NSMutableAttributedString *chosenCardsContents;
NSMutableArray *chosenCardContentsArray;
NSMutableArray *chosenCardButtons;

//Change between 2 and 3 card mode
- (IBAction)changeGameMode:(UISwitch *)sender{
    CardMatchingGame *aGame = self.game;
    aGame.threeCardGame = sender.isOn;
    self.isOnLabel.text = sender.isOn ? @"Three Card Mode: ON":@"Three Card Mode: OFF";
    NSLog(@"%i", aGame.threeCardGame); //Testing card game mode
}

//Reset the game
- (IBAction)dealAgain{
    self.game = [self createGame];
    [chosenCardButtons removeAllObjects];
    score = 0;
    self.game.threeCardGame = self.threeCardGameSwitch.isOn;
    self.isOnLabel.text = self.threeCardGameSwitch.isOn ? @"Three Card Mode: ON":@"Three Card Mode: OFF";
    [self.threeCardGameSwitch setEnabled:YES];
    [self updateUI];
}

//Getter for CardMatchingGame
- (CardMatchingGame *)game{
    if(!_game) _game = [self createGame];
    return _game;
}

//Getter for Array that stores history of statuses
- (NSMutableArray *)statusHistory{
    if (!_statusHistory)
        _statusHistory = [[NSMutableArray alloc] init];
    
    return _statusHistory;
}

//Implemented in subclasses
- (Deck *)createDeck{
    return nil;
}

//When a card button is touched
- (IBAction)touchCardButton:(UIButton *)sender {
    if(!chosenCardButtons) chosenCardButtons = [[NSMutableArray alloc] init];
    if(self.game.threeCardGame)
        gameModeNumber = 3;
    else
        gameModeNumber = 2;
    chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    oldScore = self.game.score;
    [self.game chooseCardAtIndex:chosenButtonIndex];
    score = self.game.score - oldScore + 1; //+1 because cost to choose is deducted from score
    [self.threeCardGameSwitch setEnabled:NO];
    [self updateUI];
}

//Update UI elements for each card button touch and other events
- (void)updateUI{
    for(UIButton *cardButton in self.cardButtons){
        NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        if(cardButtonIndex == chosenButtonIndex && !card.isChosen){
            attributedTitle = cardButton.currentAttributedTitle;
        }
        
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        
        if([self isCardButtonChosenAndNotMatched:cardButton] && ![chosenCardButtons containsObject:cardButton])
            [chosenCardButtons addObject:cardButton];
    }
    [self addAttributedTitleToArray:self.cardButtons[chosenButtonIndex]];
    [self createAttributedStringFromCardContents];
    [self checkForUnchosenCardButtons:chosenCardButtons];
    self.statusLabel.attributedText = [self getGameStatusForLastChosenCard:self.cardButtons[chosenButtonIndex]];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.game.score];
}

//Adding attrubuted titles to array for easy access
-(void)addAttributedTitleToArray:(UIButton *)button{
    if(!chosenCardContentsArray)
        chosenCardContentsArray = [[NSMutableArray alloc] init];
    NSAttributedString *attributedTitle = button.currentAttributedTitle;
    attributedTitle = [self removeNewlinesFromAttributedString:attributedTitle];
    [chosenCardContentsArray addObject:attributedTitle];
}

//Removing attributed titles from array
-(void)removeAttributedTitleFromArray:(NSAttributedString *)attributedTitle{
    NSArray *chosenCardContentsCopyArray = [chosenCardContentsArray copy];
    for(NSAttributedString *attrString in chosenCardContentsCopyArray){
        if([attrString isEqualToAttributedString:attributedTitle]){
            [chosenCardContentsArray removeObject:attrString];
        }
    }
}

//Remove new lines from attributed titles for display in status
-(NSAttributedString *)removeNewlinesFromAttributedString:(NSAttributedString *)attributedString{
    NSDictionary *attributes = [attributedString attributesAtIndex:0 effectiveRange:nil];
    NSString *title = [attributedString string];
    title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"Chosen Card Content: %@", title);
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

//Get complete game status
- (NSAttributedString *)getGameStatusForLastChosenCard:(UIButton *)cardButton{
    
    NSMutableAttributedString *status;
    if(!cardButton.isEnabled){//Match was found
        status = [[NSMutableAttributedString alloc] initWithString:@"Status: Match Found in "];
        [self createAttributedStringFromCardContents];
        [status appendAttributedString:chosenCardsContents];
        [status appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"for %li Points", score]]];
        [chosenCardButtons removeAllObjects];
        [chosenCardContentsArray removeAllObjects];
    }
    else if(score == -2){//Match was not found
        status = [[NSMutableAttributedString alloc] initWithString:@"Status: Match not Found in "];
        [self createAttributedStringFromCardContents];
        [status appendAttributedString:chosenCardsContents];
        NSLog(@"Chosen Card Button Count: %li", [chosenCardButtons count]);
        [chosenCardButtons removeAllObjects];
        [chosenCardContentsArray removeAllObjects];
        [chosenCardButtons addObject:cardButton];
        [self addAttributedTitleToArray:cardButton];
        [self createAttributedStringFromCardContents];
    }
    else if([chosenCardButtons count] >= 1 && [chosenCardButtons count] <= gameModeNumber-1 && cardButton.isEnabled){//Cards are chosen but not matched
        status = [[NSMutableAttributedString alloc] initWithString:@"Status: Selected Card is  "];
        [status appendAttributedString:[self removeNewlinesFromAttributedString:cardButton.currentAttributedTitle]];
    }
    else if([chosenCardButtons count] == 0){//No cards are chosen
        status = [[NSMutableAttributedString alloc] initWithString:@"Status: "];
    }
    [self.statusHistory addObject:status];
    return status;
}

//Create attributed string from array of attributed titles
-(void)createAttributedStringFromCardContents{
    if(!chosenCardsContents)
        chosenCardsContents = [[NSMutableAttributedString alloc] init];
    [chosenCardsContents replaceCharactersInRange:NSMakeRange(0, [chosenCardsContents length]) withString:@""];
    for(NSAttributedString *attrString in chosenCardContentsArray){
        [chosenCardsContents appendAttributedString:attrString];
    }
}

//Check chosen cards array for unchosen buttons
-(void)checkForUnchosenCardButtons:(NSMutableArray *)cardButtons{
    NSArray *cardButtonsCopy = [cardButtons copy];
    for(UIButton *cardButton in cardButtonsCopy){
        if([cardButton isKindOfClass:[UIButton class]]){
            if(![self isCardButtonChosen:cardButton]){
                [self removeAttributedTitleFromArray:attributedTitle];
                [cardButtons removeObject:cardButton];
                [self createAttributedStringFromCardContents];
            }
        }
    }
}

//Implemented in subclasses
-(BOOL)isCardButtonChosen:(UIButton *)cardButton{
    return nil;
}

//Implemented in subclasses
-(BOOL)isCardButtonChosenAndNotMatched:(UIButton *)cardButton{
    return nil;
}

- (NSAttributedString *)titleForCard:(Card *)card{
    return card.isChosen ? [[NSAttributedString alloc] initWithString:card.contents]:[[NSAttributedString alloc] initWithString:@""];
}

- (UIImage *)backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

//Create and return an instance of the Card matching game
- (CardMatchingGame *)createGame{
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
}

//Perform initial setup
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.threeCardGameSwitch setOn:NO];
    [self updateUI];
}
@end
