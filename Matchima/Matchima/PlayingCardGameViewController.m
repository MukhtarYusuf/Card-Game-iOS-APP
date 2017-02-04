//
//  PlayingCardGameViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/28/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "PlayingCardGameViewController.h"

@interface  PlayingCardGameViewController()

@end

@implementation PlayingCardGameViewController

-(void)initializeAndAddCardViews{
    if(self.gridForCards.inputsAreValid){
        for(int i = 0; i < self.myGridForCards.numOfRows; i++){
            for(int j = 0; j < self.myGridForCards.numOfColumns; j++){
                PlayingCardView *pcv = [[PlayingCardView alloc] initWithFrame:[self.myGridForCards frameForCellInRow:i andColumn:j]];
                [self.cardContainerView addSubview:pcv];
            }
        }
    }
}
@end
