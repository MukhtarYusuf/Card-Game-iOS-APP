//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 2/8/15.
//  Copyright (c) 2015 Mukhtar Yusuf. All rights reserved.
//

#import "GameHistoryViewController.h"
#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardGameViewController

//Send status history to destination view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"history for set card"]){
        GameHistoryViewController *ghvc = (GameHistoryViewController *)segue.destinationViewController;
        ghvc.statusHistory = self.statusHistory;
    }
}

-(Deck *)createDeck{
    return [[SetCardDeck alloc] init];
}

//Check if card is chosen through UI
-(BOOL)isCardButtonChosen:(UIButton *)cardButton{
    return [cardButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"chosen"]];
}

//Check if card is chosen but not matched through UI
-(BOOL)isCardButtonChosenAndNotMatched:(UIButton *)cardButton{
    BOOL chosen = NO;
    
    if([cardButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"chosen"]] && cardButton.isEnabled){
        chosen = YES;
    }
    return chosen;
}

- (UIImage *)backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"chosen":@"cardfront"];
}

//Set the title for card
-(NSAttributedString *)titleForCard:(Card *)card{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    if([card isKindOfClass:[SetCard class]]){
        SetCard *aCard = (SetCard *)card;
        
        
        attributedString = [SetCardGameViewController draw:aCard.number ofShape:aCard.shape];
        attributedString = [SetCardGameViewController draw:attributedString with:aCard.color and:aCard.shading];
    }
    
    return attributedString;
}

//Method to add color and shading to set card button titles
+(NSMutableAttributedString *)draw:(NSMutableAttributedString *)attString with:(NSString *)color and: (NSString *)shading{
    
    UIColor *cardColor;
    NSMutableAttributedString *attributedString = attString;
    
    if([color isEqualToString:@"Red"]){
        cardColor = [UIColor redColor];
        [attributedString addAttribute:NSForegroundColorAttributeName value:cardColor range:NSMakeRange(0, [attString length])];
    }else if ([color isEqualToString:@"Green"]){
        cardColor = [UIColor greenColor];
        [attributedString addAttribute:NSForegroundColorAttributeName value:cardColor range:NSMakeRange(0, [attString length])];
    }
    else if ([color isEqualToString:@"Blue"]){
        cardColor = [UIColor blueColor];
        [attributedString addAttribute:NSForegroundColorAttributeName value:cardColor range:NSMakeRange(0, [attString length])];
    }
    
    if([shading isEqualToString:@"Open"]){
        [attributedString addAttributes:@{/*NSForegroundColorAttributeName: [UIColor whiteColor],*/
                                          NSStrokeWidthAttributeName:@8
                                          /*NSStrokeColorAttributeName: cardColor*/
                                          }
                                  range:NSMakeRange(0, [attributedString length])];
    }
    else if ([shading isEqualToString:@"Striped"]){
        [attributedString addAttributes:@{NSStrokeWidthAttributeName:@-10,
                                          NSStrokeColorAttributeName:[UIColor blackColor]
                                          } range:NSMakeRange(0, [attributedString length])];
    }
    
    return attributedString;
}

//Method to draw shapes and their respective numbers on set cards
+(NSMutableAttributedString *)draw:(int)number ofShape:(NSString *)shape{
    NSMutableString *attString = [[NSMutableString alloc] init];
    
    for(int i = 0; i < number; i++){
        if([shape isEqualToString:@"Circle"]){
            (i==number-1)?[attString appendString:@"●"]:[attString appendString:@"●\n"];
        }else if ([shape isEqualToString:@"Square"]){
            (i==number-1)?[attString appendString:@"◼︎"]:[attString appendString:@"◼︎\n"];
        }else if ([shape isEqualToString:@"Triangle"]){
            (i==number-1)?[attString appendString:@"▲"]:[attString appendString:@"▲\n"];
        }
    }
    
    return [[NSMutableAttributedString alloc] initWithString:attString];
}

@end