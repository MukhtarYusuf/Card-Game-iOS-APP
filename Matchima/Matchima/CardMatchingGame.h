//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Mukhtar Yusuf on 7/30/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

//designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck*)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
-(Card *)drawOneCardIntoGame;
-(NSMutableArray *)drawThreeCardsIntoGame;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) BOOL threeCardGame;
@end

