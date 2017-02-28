//
//  CardGameViewController.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/28/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "CardGameViewController.h"

@interface  CardGameViewController()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachTopBehavior;
@property (nonatomic) BOOL areCardsInPile;

@end

@implementation CardGameViewController

CGFloat originalAnchorLength;
CGRect originalCardContainerBounds;

static const int INITIAL_NUMBER_OF_CARDS = 12;
static const double CARD_ASPECT_RATIO = 0.5;

static int NUMBER_OF_COLUMNS = 4;
static int NUMBER_OF_ROWS = 3;

- (IBAction)dealAgain:(UIButton *)sender{
    NUMBER_OF_COLUMNS = 4;
    NUMBER_OF_ROWS = 3;
    self.cardContainerView.bounds = originalCardContainerBounds;
    [self setUpContainerViewHeight];
    [self setUpMyGrid];
    self.game = [self createGame];
    [self removeAllCardSubViews];
    [self initializeAndAddCardViews];
    [self addTapGestureRecognizerToCards];
    [self updateUI];
}

- (IBAction)drawThreeCards:(id)sender{
    [self drawThree];
}

-(void)tapRootView:(UITapGestureRecognizer *)sender{
    NSLog(@"In tap gesture recognizer");
    NSLog(@"Are cards in pile in tap: %@", self.areCardsInPile ? @"Yes":@"No");
    if(self.areCardsInPile){
        NSLog(@"In tap gesture recognizer 2");
        self.areCardsInPile = !self.areCardsInPile;
        [self animateCardsToOriginalLocations];
    }
}

-(void)panRootView:(UIPanGestureRecognizer *)sender{
    if(self.areCardsInPile){
        NSLog(@"In Pan");
        UIView *topCard = [self.cardViews lastObject];
        if(sender.state == UIGestureRecognizerStateBegan){
            _attachTopBehavior = [[UIAttachmentBehavior alloc] initWithItem:topCard attachedToAnchor:[sender locationInView:self.view]];
            _attachTopBehavior.length = 0.0;
            [self.animator addBehavior:_attachTopBehavior];
        }else if(sender.state == UIGestureRecognizerStateChanged){
            [_attachTopBehavior setAnchorPoint:[sender locationInView:self.view]];
        }else if(sender.state == UIGestureRecognizerStateEnded){
            [self.animator removeBehavior:_attachTopBehavior];
        }
    }
}

-(void)pinchContainer:(UIPinchGestureRecognizer *)sender{
    UIView *topView = [self.cardViews lastObject];
    NSLog(@"Are cards in pile: %@", self.areCardsInPile ? @"YES":@"NO");
    if(!self.areCardsInPile){
        if(sender.state == UIGestureRecognizerStateBegan){
            for(UIView *cardView in self.cardViews){
                [UIView animateWithDuration:1.0
                                 animations:^{
                                     CGFloat halfWidth = self.cardContainerView.bounds.size.width/2;
                                     CGFloat halfHeight = self.cardContainerView.bounds.size.height/2;
                                     CGPoint containerCenter = CGPointMake(halfWidth, halfHeight);
                                     cardView.center = containerCenter;
                                 }
                                 completion:^(BOOL finished){
                                     if (finished) {
                                         if(cardView != topView){
                                             UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:cardView attachedToItem:topView];
                                             [self.animator addBehavior:attachmentBehavior];
                                         }else if (cardView == topView)
                                             self.areCardsInPile = !self.areCardsInPile;
                                     }
                                 }
                 ];
            }
        }
//        self.areCardsInPile = !self.areCardsInPile;
    }
}

-(void)tapCard:(UITapGestureRecognizer *)sender{
    NSLog(@"Card Tapped");
        
    NSUInteger chosenCardIndex = [self.cardViews indexOfObject:sender.view];
    NSLog(@"In tapCard: %lu", chosenCardIndex);
//    Card *card = [self.game cardAtIndex:chosenCardIndex];
//    
//    NSLog(@"Is this tapped chosen: %@", card.isChosen ? @"YES":@"NO");
    [self.game chooseCardAtIndex:chosenCardIndex];
    [self updateUI];
}

-(void)drawThree{
    NUMBER_OF_COLUMNS++;
    [self setUpContainerViewHeight];
    [self setUpMyGrid];
    __block int cardIndex = 0;
    for(int i = 0; i < self.myGridForCards.numOfRows; i++){
        for(int j = 0; j < self.myGridForCards.numOfColumns; j++){
            if(j != self.myGridForCards.numOfColumns-1){
                [UIView animateWithDuration:0.4
                                 animations:^{
                                     ((UIView *)self.cardViews[cardIndex]).frame = [self.myGridForCards frameForCellInRow:i andColumn:j]; //Use Introspection?
                                 }];
                cardIndex++;
                 
            }else{
                SetCard *drawnSetCard = (SetCard *)[self.game drawOneCardIntoGame]; //Use Introspection?
                CGRect initialFrame;
                initialFrame.origin = CGPointMake(self.myGridForCards.size.width-[self.myGridForCards cellWidth], 0.0);
                SetCardView *newScv = [[SetCardView alloc] initWithFrame:initialFrame];
                if(drawnSetCard){
                    newScv.shape = drawnSetCard.shape;
                    newScv.color = drawnSetCard.color;
                    newScv.number = drawnSetCard.number;
                    newScv.shading = drawnSetCard.shading;
                    newScv.isChosen = drawnSetCard.isChosen;
                    
                    [self.cardContainerView addSubview:newScv];
                    [self.cardViews insertObject:newScv atIndex:cardIndex];
                    [UIView animateWithDuration:0.4
                                     animations:^{
                                         newScv.frame = [self.myGridForCards frameForCellInRow:i andColumn:j];
                                         [self.cardViewFrames insertObject:[NSValue valueWithCGRect:newScv.frame] atIndex:cardIndex];
                                         cardIndex++;
                                     }];
                }
            }
        }
    }
}

-(void)updateUI{
    NSMutableArray *addedCards = [[NSMutableArray alloc] initWithCapacity:3];
    for(UIView *cardView in self.cardViews){
        NSUInteger cardIndex = [self.cardViews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
        if([card isKindOfClass:[PlayingCard class]]){
            if([cardView isKindOfClass:[PlayingCardView class]]){
                PlayingCardView *playingCardView = (PlayingCardView *)cardView;
                PlayingCard *playingCard = (PlayingCard *)card;
                NSLog(@"Is this chosen: %@", card.isChosen ? @"YES":@"NO");
                playingCardView.rank = playingCard.rank;
                playingCardView.suit = playingCard.suit;
                playingCardView.isMatched = playingCard.isMatched;
                if(card.isChosen != playingCardView.faceUP){
                    [UIView transitionWithView:playingCardView
                                  duration:0.6
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                    animations:nil
                                completion:nil];
                }
                playingCardView.faceUP = playingCard.isChosen;
            }
        }else if([card isKindOfClass:[SetCard class]]){
            if([cardView isKindOfClass:[SetCardView class]]){
                SetCardView *setCardView = (SetCardView *)cardView;
                SetCard *setCard = (SetCard *)card;
                setCardView.shape = setCard.shape;
                setCardView.color = setCard.color;
                setCardView.number = setCard.number;
                setCardView.shading = setCard.shading;
                setCardView.isChosen = setCard.isChosen;
                if(setCard.isMatched && setCardView.alpha != 0.0){
                    setCardView.alpha = 0.0;
                    CGRect rectForMatchedCard = setCardView.frame;
                    CGFloat initialXValue = arc4random_uniform(self.cardContainerView.bounds.size.width);
                    CGRect initialFrame;
                    initialFrame.origin = CGPointMake(initialXValue, 0);
                    initialFrame.size = rectForMatchedCard.size;
                    
                    SetCard *drawnCard = (SetCard *)[self.game drawOneCardIntoGame];//Use Introspection?
                    SetCardView *newScv = [[SetCardView alloc] initWithFrame:initialFrame];
                    newScv.shape = drawnCard.shape;
                    newScv.color = drawnCard.color;
                    newScv.number = drawnCard.number;
                    newScv.shading = drawnCard.shading;
                    newScv.isChosen = drawnCard.isChosen;
                    [self.cardContainerView addSubview:newScv];
                    [addedCards addObject:newScv];
                    [newScv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
                    
                    [UIView animateWithDuration:1.0
                                     animations:^{
                                         newScv.frame = rectForMatchedCard;
                                         [self.cardViewFrames addObject:[NSValue valueWithCGRect:newScv.frame]];
                                     }];
                }
            }
        }
    }
    [self.cardViews addObjectsFromArray:addedCards];
    NSLog(@"Number of cards in outlet: %lu", [self.cardViews count]);
    NSLog(@"Number of cards in added cards: %lu", [addedCards count]);
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.game.score];
}

-(void)animateCardsToOriginalLocations{
    for(int i = 0; i < [self.cardViews count]; i++){
        [UIView animateWithDuration:0.3
                         animations:^{
                            ((UIView *)self.cardViews[i]).frame = ((NSValue *)self.cardViewFrames[i]).CGRectValue;
                         }];
    }
//    int cardIndex = 0;
//    for(int i = 0; i < self.myGridForCards.numOfRows; i++){
//        for(int j = 0; j < self.myGridForCards.numOfColumns; j++){
//            UIView *cardView = self.cardViews[cardIndex];
//            [UIView animateWithDuration:0.3
//                             animations:^{
//                                 cardView.frame = [self.myGridForCards frameForCellInRow:i andColumn:j];
//                             }];
//            cardIndex++; //Check
//        }
//    }
}

//--Getters and Setters--
#pragma mark - Getters and Setters

-(Grid *)gridForCards{
    if(!_gridForCards)
        _gridForCards = [[Grid alloc] init];
    return _gridForCards;
}

-(MyGrid *)myGridForCards{
    if(!_myGridForCards)
        _myGridForCards = [[MyGrid alloc] init];
    return _myGridForCards;
}

-(CardMatchingGame *)game{
    if(!_game)
        _game = [self createGame];
    _game.threeCardGame = NO;
    return _game;
}

-(NSMutableArray *)cardViews{
    if(!_cardViews)
        _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}
-(UIDynamicAnimator *)animator{
    if(!_animator)
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardContainerView];
    return _animator;
}
-(NSMutableArray *)cardViewFrames{
    if(!_cardViewFrames)
        _cardViewFrames = [[NSMutableArray alloc] init];
    return _cardViewFrames;
}
-(NSUInteger)numOfRows{
    return 0;
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
                 
//Implemented in subclasses
-(Deck *)createDeck{
    return nil;
}

-(CardMatchingGame *)createGame{
    NSLog(@"Card count when creating game: %li", self.cardViews.count);
    return [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count] usingDeck:[self createDeck]];
}

-(void)addTapGestureRecognizerToCards{
    for(UIView *cardView in self.cardViews){
        [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
    }
}

-(void)addPinchRecognizerToCardContainer{
    [self.cardContainerView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchContainer:)]];
}

-(void)addPanRecognizerToRootView{
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRootView:)]];
}

-(void)addTapRecognizerToRootView{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRootView:)]];
}

-(void)setUpContainerViewHeight{
    CGFloat deductFromHeight = self.cardContainerView.bounds.size.height - [self deductFromHeightFactor]*[self deductFromHeightCoeff];
    [self.cardContainerView setBounds:CGRectMake(self.cardContainerView.bounds.origin.x, self.cardContainerView.bounds.origin.y, self.cardContainerView.bounds.size.width, deductFromHeight)];
}

-(int)deductFromHeightFactor{
    return NUMBER_OF_COLUMNS - (NUMBER_OF_ROWS + 1);
}

-(CGFloat)deductFromHeightCoeff{
    return self.cardContainerView.bounds.size.height/7;
}

-(void)removeAllCardSubViews{
    for(UIView *view in self.cardContainerView.subviews){
        [view removeFromSuperview];
    }
}

//--View Controller Life Cycle--
#pragma mark - Lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    originalCardContainerBounds = self.cardContainerView.bounds;
    [self setUpContainerViewHeight];
    [self setUpMyGrid];
//    [self setUpGrid];
    [self initializeAndAddCardViews];
    [self addTapGestureRecognizerToCards];
    [self addPinchRecognizerToCardContainer];
    [self addPanRecognizerToRootView];
    [self addTapRecognizerToRootView];
    [self updateUI];
    NSLog(@"Card outlet count: %lu", (unsigned long)[self.cardViews count]);
}

@end
