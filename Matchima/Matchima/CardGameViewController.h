//
//  CardGameViewController.h
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/28/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"
#import "MyGrid.h"
#import "playingCardView.h"
#import "SetCardView.h"

@interface CardGameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *cardContainerView;
@property (strong, nonatomic) Grid *gridForCards; //Protected for subclasses
@property (strong, nonatomic) MyGrid *myGridForCards; //Protected for subclasses
@end
