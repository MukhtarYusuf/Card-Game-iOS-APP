//
//  SetCardView.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/16/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "SetCardView.h"
@interface SetCardView()
@end

@implementation SetCardView

//--Handle Getters and Setters--

-(void)setShape:(NSString *)shape{
    _shape = shape;
    [self setNeedsDisplay];
}

-(void)setColor:(NSString *)color{
    _color = color;
    [self setNeedsDisplay];
}

-(void)setShading:(NSString *)shading{
    _shading = shading;
    [self setNeedsDisplay];
}

-(void)setNumber:(int)number{
    _number = number;
    [self setNeedsDisplay];
}

//--Handle Drawing--

#define CORNER_HEIGHT 180.0
#define CORNER_RADIUS 12.0

#define SHAPE_HEIGHT_RATIO 0.22
#define SHAPE_WIDTH_RATIO 0.80

-(CGFloat)cornerScaleFactor{
    return (self.bounds.size.height/CORNER_HEIGHT);
}
-(CGFloat)cornerRadius{
    return (CORNER_RADIUS * [self cornerScaleFactor]);
}
-(CGFloat)shapeHeightScaleFactor{
    return (SHAPE_HEIGHT_RATIO * self.bounds.size.height);
}
-(CGFloat)shapeWidthScaleFactor{
    return (SHAPE_WIDTH_RATIO * self.bounds.size.width);
}

//Override drawRect: to perform custom drawing
-(void)drawRect:(CGRect)rect{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    [roundedRect fill];
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawDiamondAt:-1*([self shapeWidthScaleFactor]/2) and:0];
}

-(void)drawDiamondAt: (CGFloat)hOffSet and: (CGFloat) vOffSet{
    [self saveContext];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint startPoint = CGPointMake(center.x + hOffSet, center.y + vOffSet);
    
    CGFloat halfHeight = [self shapeHeightScaleFactor]/2;
    CGFloat halfWidth = [self shapeWidthScaleFactor]/2;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:startPoint];
    
    CGPoint topCorner = CGPointMake(startPoint.x + halfWidth, startPoint.y - halfHeight);
    
    CGPoint rightCorner = CGPointMake(topCorner.x + halfWidth, topCorner.y+halfHeight);
    
    CGPoint bottomCorner = CGPointMake(rightCorner.x - halfWidth, rightCorner.y + halfHeight);
    
    [bezierPath addLineToPoint:topCorner];
    [bezierPath addLineToPoint:rightCorner];
    [bezierPath addLineToPoint:bottomCorner];
    [bezierPath closePath];
    
    [[UIColor greenColor] setFill];
    [bezierPath fill];
    
    [[UIColor blackColor] setStroke];
    [bezierPath stroke];
    
    [self restoreContext];
}

-(void)saveContext{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
}
-(void)restoreContext{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

//--Handle Setup and Initialization

-(void)setup{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
