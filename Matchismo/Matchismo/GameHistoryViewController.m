//
//  GameHistoryViewController.m
//  Matchismo
//
//  Created by Mukhtar Yusuf on 2/16/15.
//  Copyright (c) 2015 Mukhtar Yusuf. All rights reserved.
//

#import "GameHistoryViewController.h"

@interface GameHistoryViewController()

@property (weak, nonatomic) IBOutlet UITextView *gameHistory;

@end

@implementation GameHistoryViewController

//Set up text view contents when view loads
-(void)viewDidLoad{
    [super viewDidLoad];
    for(NSAttributedString *status in self.statusHistory){
        [self.gameHistory.textStorage appendAttributedString:status];
        [self.gameHistory.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
}

@end
