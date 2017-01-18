//
//  SetCard.h
//  Matchismo
//
//  Created by Mukhtar Yusuf on 2/8/15.
//  Copyright (c) 2015 Mukhtar Yusuf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface SetCard : Card
@property(nonatomic, strong) NSString *shape;
@property(nonatomic, strong) NSString *color;
@property(nonatomic, strong) NSString *shading;
@property(nonatomic) int number;

+(NSArray *)validShapes;
+(NSArray *)validColors;
+(NSArray *)validShadings;

@end

