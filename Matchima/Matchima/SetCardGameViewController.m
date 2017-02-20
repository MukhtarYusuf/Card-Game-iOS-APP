//
//  SetCardGameViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/28/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

@interface SetCardGameViewController()

@end

@implementation SetCardGameViewController

-(void)initializeAndAddCardViews{
    [self.cardViews removeAllObjects];
    [self.cardViewFrames removeAllObjects];
    for(int i = 0; i < self.myGridForCards.numOfRows; i++){
        for(int j = 0; j < self.myGridForCards.numOfColumns; j++){
            CGFloat initialXValue = arc4random_uniform(self.cardContainerView.bounds.size.width);
            CGRect finalFrame = [self.myGridForCards frameForCellInRow:i andColumn:j];
            CGRect initialFrame;
            initialFrame.origin = CGPointMake(initialXValue, 0.0);
            SetCardView *scv = [[SetCardView alloc] initWithFrame:initialFrame];
            [self.cardContainerView addSubview:scv];
            [self.cardViews addObject:scv];
            [UIView animateWithDuration:0.3
                             animations:^{
                                 scv.frame = finalFrame;
                                 [self.cardViewFrames addObject:[NSValue valueWithCGRect:scv.frame]];
                             }];
        }
    }
}

-(Deck *)createDeck{
    return [[SetCardDeck alloc] init];
}

@end
