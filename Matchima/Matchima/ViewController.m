//
//  ViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/9/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (strong, nonatomic) Deck *deck;

@end

@implementation ViewController

- (Deck *)deck{
    if(!_deck)
        _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void) drawRandomCard{
    Card *card = [self.deck drawRandomCard];
    if([card isKindOfClass:[PlayingCard class]]){
        PlayingCard *playingCard = (PlayingCard *)card;
        self.playingCardView.rank = playingCard.rank;
        self.playingCardView.suit = playingCard.suit;
    }
}

- (void)touch:(UITapGestureRecognizer *)sender{
    if(!self.playingCardView.faceUP)
        [self drawRandomCard];
    
    [UIView transitionWithView:self.playingCardView
                      duration:1.5
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        self.playingCardView.faceUP = !self.playingCardView.faceUP;
                    }
                    completion:nil];
    //self.playingCardView.faceUP = !self.playingCardView.faceUP;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.playingCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch:)]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
