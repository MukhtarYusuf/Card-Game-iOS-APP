//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Mukhtar Yusuf on 7/7/14.
//  Copyright (c) 2014 Mukhtar Yusuf. All rights reserved.
//  Abstract class. Must implement methods as described below.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import"Deck.h"
#import <sqlite3.h>

@interface CardGameViewController : UIViewController
//Protected for Subclass
@property (strong, nonatomic) NSMutableArray *statusHistory;

//Protected for Subclass
- (Deck *)createDeck;
@end
