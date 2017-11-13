//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 2/8/15.
//  Copyright (c) 2015 Mukhtar Yusuf. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(instancetype)init{
    self = [super init];
    
    if(self){
        for(int i = 1; i <= 3; i++){
            for(NSString *shape in [SetCard validShapes]){
                for(NSString *shading in [SetCard validShadings]){
                    for(NSString *color in [SetCard validColors]){
                        SetCard *card = [[SetCard alloc] init];
                        card.number = i;
                        card.shape = shape;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card];
                    }
                    
                }
            }
        }
    }
    return self;
}

@end
