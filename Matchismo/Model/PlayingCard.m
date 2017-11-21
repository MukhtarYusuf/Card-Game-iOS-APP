//
//  PlayingCard.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 7/8/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards{
    int score = 0;
    NSUInteger numberOfOtherCards = [otherCards count];
    NSLog(@"Number of Cards in Match: %li", numberOfOtherCards);
    
    if(numberOfOtherCards == 1){ //Matching against one card
        PlayingCard *otherCard = [otherCards firstObject];
        if([otherCard isKindOfClass:[PlayingCard class]]){
            score += [PlayingCard scoreCard:self with:otherCard];
        }
        
    }else if(numberOfOtherCards > 1){ //Matching against more than one Card
        for(int i = 0; i <= numberOfOtherCards-2; i++){
            score += [PlayingCard scoreCard:self with:otherCards[i]];
            if(i == numberOfOtherCards-2)
                score += [PlayingCard scoreCard:self with:otherCards[i+1]];
            NSLog(@"Score: %i", score);
            for(int j = i+1; j <= numberOfOtherCards-1; j++){
                score += [PlayingCard scoreCard:otherCards[i] with:otherCards[j]];
                NSLog(@"Score: %i", score);
            }
        }
    }
    return score;
}

- (NSString *)contents{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits{
    return @[@"♥️", @"♦️", @"♠️", @"♣️"];
}

@synthesize suit = _suit; //Because Getter and Setter is provided

- (void)setSuit:(NSString *)suit{
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

- (NSString *)suit{
    return _suit ? _suit:@"?";
}

- (void)setRank:(NSUInteger)rank{
    if(rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
}

+ (NSArray *)rankStrings{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank{
    return [[self rankStrings] count]-1;
}

+ (int)scoreCard:(PlayingCard *)firstCard with: (PlayingCard *)secondCard{
    int calculatedScore = 0;
    
    if(firstCard.rank == secondCard.rank){
        calculatedScore = 4;
    }
    else if([firstCard.suit isEqualToString:secondCard.suit]){
        calculatedScore = 1;
    }

    return calculatedScore;
}

@end
