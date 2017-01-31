//
//  CardGameViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/28/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "CardGameViewController.h"

@interface  CardGameViewController()

@end

@implementation CardGameViewController

static const int INITIAL_NUMBER_OF_CARDS = 12;
static const double CARD_ASPECT_RATIO = 0.5;

static const int NUMBER_OF_COLUMNS = 6;
static const int NUMBER_OF_ROWS = 5;


//--Getters and Setters--
#pragma mark - Getters and Setters

- (Grid *)gridForCards{
    if(!_gridForCards)
        _gridForCards = [[Grid alloc] init];
    return _gridForCards;
}

- (MyGrid *)myGridForCards{
    if(!_myGridForCards)
        _myGridForCards = [[MyGrid alloc] init];
    return _myGridForCards;
}

//--Setup Code--
#pragma mark - Setup

-(void)setUpMyGrid{
    self.myGridForCards.size = self.cardContainerView.bounds.size;
    self.myGridForCards.numOfColumns = NUMBER_OF_COLUMNS;
    self.myGridForCards.numOfRows = NUMBER_OF_ROWS;
}

-(void)setUpGrid{
    self.gridForCards.size = self.cardContainerView.bounds.size;
    self.gridForCards.minimumNumberOfCells = INITIAL_NUMBER_OF_CARDS;
    self.gridForCards.cellAspectRatio = CARD_ASPECT_RATIO;
}

//Implemented in subclasses
-(void)initializeAndAddCardViews{
}

//--View Controller Life Cycle
#pragma mark - Lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpGrid];
    [self setUpMyGrid];
    [self initializeAndAddCardViews];
}

@end
