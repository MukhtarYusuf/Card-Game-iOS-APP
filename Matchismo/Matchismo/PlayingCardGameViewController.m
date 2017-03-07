//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 12/30/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "GameHistoryViewController.h"
@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

//Send Status History to destination view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"history for playing card"]){
        GameHistoryViewController *ghvc = (GameHistoryViewController *)segue.destinationViewController;
        ghvc.statusHistory = self.statusHistory;
    }
}

- (Deck *)createDeck{
    return [[PlayingCardDeck alloc] init];
}

//Method to check if card is chosen through UI
-(BOOL)isCardButtonChosen:(UIButton *)cardButton{
    return [cardButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"cardfront"]];
}

//Method to check if card is chosen but not matched through UI
-(BOOL)isCardButtonChosenAndNotMatched:(UIButton *)cardButton{
    BOOL chosen = NO;
    
    if([cardButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"cardfront"]] && cardButton.isEnabled){
        chosen = YES;
    }
    return chosen;
}

@end
