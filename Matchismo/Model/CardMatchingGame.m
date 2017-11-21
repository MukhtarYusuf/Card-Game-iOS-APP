//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 7/30/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
//

#import "CardMatchingGame.h"
#import "SetCard.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@end

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

NSMutableArray *chosenCards;

- (NSMutableArray *)cards{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

//Designated Initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    
    if(self){
        for(int i = 0; i < count; i++){
            Card *randomCard = [deck drawRandomCard];
            if(randomCard){
                [self.cards addObject:randomCard];
            }
            else{
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

//Return card at index
- (Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

//Select card at index and perform operations
- (void)chooseCardAtIndex:(NSUInteger)index{
    
    if(!chosenCards){
        chosenCards = [[NSMutableArray alloc] init];
    }
    
    Card *card = [self cardAtIndex:index];
    if([card isKindOfClass:[SetCard class]]){
        self.threeCardGame = YES;
    }
    
    int matchScore = 0;
    NSUInteger chosenCardCount = 0;
    
    if(!card.isMatched){
        if(card.isChosen){
            card.chosen = NO;
        }
        else{ // Put Cards that are chosen but not matched in an array
            for(Card *otherCard in self.cards){
                if(otherCard.isChosen && !otherCard.isMatched && ![chosenCards containsObject:otherCard]){
                    [chosenCards addObject:otherCard];
                }
            }
            
            matchScore = [card match:chosenCards];
            chosenCardCount = [chosenCards count];
    
            
            if(!self.threeCardGame && [chosenCards count] == 1){//Matching for a two card game
                if(matchScore){
                    [self updateGameForMatch:card forScore:matchScore];
                }
                else{
                    [self updateGameForMismatch:card];
                }
            }
            else if([chosenCards count] == 2 && self.threeCardGame){//Matching for a three card game
                if(matchScore){
                    [self updateGameForMatch:card forScore:matchScore];
                }
                else{
                    [self updateGameForMismatch:card];
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

//Update score and card status for match
-(void)updateGameForMatch:(Card *)chosenCard forScore:(int)score{
    self.score += score * MATCH_BONUS;
    chosenCard.matched = YES;
    
    for(Card *otherCard in chosenCards){
        otherCard.matched = YES;
    }

    [chosenCards removeAllObjects];
}

//Update score and cards status for mismatch
-(void)updateGameForMismatch:(Card *)chosenCard{
    self.score -= MISMATCH_PENALTY;
    
    for(Card *otherCard in chosenCards){
        otherCard.chosen = NO;
    }
    [chosenCards removeAllObjects];
}

@end
