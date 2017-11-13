//
//  SetCard.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 2/8/15.
//  Copyright (c) 2015 Mukhtar Yusuf. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

//Override match method
-(int)match:(NSArray *)otherCards{//otherCards always has length 2
    int score = 0;
    
    if([SetCard checkNumbersFor:self with:otherCards] && [SetCard checkShapesFor:self with:otherCards] && [SetCard checkShadingsFor:self with:otherCards] && [SetCard checkColorsFor:self with:otherCards]){
        
        score = 4;
    }
    
    return score;
}

//Check that condition for a set through numbers is met
+(BOOL)checkNumbersFor:(SetCard *)firstCard with: (NSArray *)otherCards{
    BOOL isSet = NO;
    
    if([otherCards count] == 2){
        SetCard *secondCard = (SetCard *)otherCards[0];
        SetCard *thirdCard = (SetCard *)otherCards[1];
        
        if(firstCard.number == secondCard.number && secondCard.number == thirdCard.number){
            isSet = YES;
        }
        else if (firstCard.number != secondCard.number && firstCard.number != thirdCard.number && secondCard.number != thirdCard.number){
            isSet = YES;
        }

    }
    
    return isSet;
}

//Check that condition for set through shadings is met
+(BOOL)checkShadingsFor:(SetCard *)firstCard with: (NSArray *)otherCards{
    BOOL isSet = NO;
    
    if([otherCards count] == 2){
        SetCard *secondCard = (SetCard *)otherCards[0];
        SetCard *thirdCard = (SetCard *)otherCards[1];
        
        if([firstCard.shading isEqualToString:secondCard.shading] && [secondCard.shading isEqualToString:thirdCard.shading]){
            isSet = YES;
        }
        else{
            if(![firstCard.shading isEqualToString:secondCard.shading] && ![firstCard.shading isEqualToString:thirdCard.shading] && ![secondCard.shading isEqualToString:thirdCard.shading]){
                isSet = YES;
            }
        }

    }
    
    return isSet;
}

//Check that conditions for set through colors is met
+(BOOL)checkColorsFor:(SetCard *)firstCard with: (NSArray *)otherCards{
    BOOL isSet = NO;
    
    if([otherCards count] == 2){
        SetCard *secondCard = (SetCard *)otherCards[0];
        SetCard *thirdCard = (SetCard *)otherCards[1];
        
        if([firstCard.color isEqualToString:secondCard.color] && [secondCard.color isEqualToString:thirdCard.color]){
            isSet = YES;
        }
        else{
            if(![firstCard.color isEqualToString:secondCard.color] && ![firstCard.color isEqualToString:thirdCard.color] && ![secondCard.color isEqualToString:thirdCard.color]){
                isSet = YES;
            }
        }
    }
    
    return isSet;
}

//Check that codition for set through shapes is met
+(BOOL)checkShapesFor:(SetCard*)firstCard with:(NSArray *)otherCards{
    BOOL isSet = NO;
    
    if([otherCards count] == 2){
        SetCard *secondCard = (SetCard *)otherCards[0];
        SetCard *thirdCard = (SetCard *)otherCards[1];
        
        if([firstCard.shape isEqualToString:secondCard.shape] && [secondCard.shape isEqualToString:thirdCard.shape]){
            isSet = YES;
        }
        else{
            if(![firstCard.shape isEqualToString:secondCard.shape] && ![firstCard.shape isEqualToString:thirdCard.shape] && ![secondCard.shape isEqualToString:thirdCard.shape]){
                isSet = YES;
            }
        }
    }
    return isSet;
}

-(void)setShape:(NSString *)shape{
    if([[SetCard validShapes] containsObject:shape])
        _shape = shape;
}
-(void)setShading:(NSString *)shading{
    if([[SetCard validShadings] containsObject:shading])
        _shading = shading;
}
-(void)setColor:(NSString *)color{
    if([[SetCard validColors] containsObject:color])
        _color = color;
}
-(void)setNumber:(int)number{
    if(number >= 1 && number <= 3)
        _number = number;
}

+ (NSArray *)validShapes{
    return @[@"Circle", @"Triangle", @"Square"];
}
+ (NSArray *)validColors{
    return @[@"Red", @"Green", @"Blue"];
}
+ (NSArray *)validShadings{
    return @[@"Open", @"Striped", @"Solid"];
}

@end
