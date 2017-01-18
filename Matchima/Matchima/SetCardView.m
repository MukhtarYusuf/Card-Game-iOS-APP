//
//  SetCardView.m
//  Matchima
//
//  Created by Mukhtar Yusuf on 1/16/17.
//  Copyright © 2017 Mukhtar Yusuf. All rights reserved.
//

#import "SetCardView.h"
@interface SetCardView()
@property (strong, nonatomic) NSDictionary *colors;
@end

@implementation SetCardView

//--Handle Getters and Setters--

-(NSDictionary *)colors{
    if(!_colors)
        _colors = @{
                    @"Red" : [UIColor redColor],
                    @"Green" : [UIColor greenColor],
                    @"Blue" : [UIColor blueColor]
                    };
    return _colors;
}

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

#define STROKE_SPACE_RATIO 0.04

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
    
    [self drawOvalAt:-1*([self shapeWidthScaleFactor]/2) and:-1*([self shapeHeightScaleFactor]/2) withColor:[UIColor blueColor] andShading:@"Striped"];
    
//    [self drawDiamondAt:-1*([self shapeWidthScaleFactor]/2) and:0 withColor:[UIColor blueColor] andShading:@"Solid"];
}

#define OVAL_CORNER_RADIUS_RATIO 0.3

-(void)drawOvalAt: (CGFloat)hOffSet and:(CGFloat)vOffSet withColor: (UIColor *)color andShading:(NSString *)shading{
    [self saveContext];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint startPoint = CGPointMake(center.x + hOffSet, center.y + vOffSet);
    CGFloat shapeHeight = [self shapeHeightScaleFactor];
    CGFloat shapeWidth = [self shapeWidthScaleFactor];
    
    CGSize sizeOfRect = CGSizeMake(shapeWidth, shapeHeight);
    CGRect enclosingRect;
    enclosingRect.origin = startPoint;
    enclosingRect.size = sizeOfRect;
    
    CGFloat ovalCornerRadius = shapeWidth * OVAL_CORNER_RADIUS_RATIO;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:enclosingRect cornerRadius:ovalCornerRadius];
    
    [color setStroke];
    [bezierPath stroke];
    if([shading isEqualToString:@"Solid"])
        [color setFill];
    else
        [[UIColor whiteColor] setFill];
    
    [bezierPath fill];
    
    [bezierPath addClip];
    
    if([shading isEqualToString:@"Striped"])
        [self addStrokeToRect:enclosingRect];
    
}

-(void)drawDiamondAt: (CGFloat)hOffSet and: (CGFloat)vOffSet withColor: (UIColor *)color andShading:(NSString *)shading {
    [self saveContext];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint startPoint = CGPointMake(center.x + hOffSet, center.y + vOffSet);
    CGFloat shapeHeight = [self shapeHeightScaleFactor];
    CGFloat shapeWidth = [self shapeWidthScaleFactor];
    
    CGFloat halfHeight = shapeHeight/2;
    CGFloat halfWidth = shapeWidth/2;
    
    CGPoint originOfRect = CGPointMake(startPoint.x, startPoint.y-halfHeight);
    CGSize sizeOfRect = CGSizeMake(shapeWidth, shapeHeight);
    CGRect enclosingRect;
    enclosingRect.origin = originOfRect;
    enclosingRect.size = sizeOfRect;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:startPoint];
    
    CGPoint topCorner = CGPointMake(startPoint.x + halfWidth, startPoint.y - halfHeight);
    
    CGPoint rightCorner = CGPointMake(topCorner.x + halfWidth, topCorner.y+halfHeight);
    
    CGPoint bottomCorner = CGPointMake(rightCorner.x - halfWidth, rightCorner.y + halfHeight);
    
    [bezierPath addLineToPoint:topCorner];
    [bezierPath addLineToPoint:rightCorner];
    [bezierPath addLineToPoint:bottomCorner];
    [bezierPath closePath];
    
    [color setStroke];
    [bezierPath stroke];
    if([shading isEqualToString:@"Solid"])
        [color setFill];
    else
        [[UIColor whiteColor] setFill];
    
    [bezierPath fill];
    
    [bezierPath addClip];

    if([shading isEqualToString:@"Striped"]){
        [self addStrokeToRect:enclosingRect];
//        CGFloat strokeSpacing = STROKE_SPACE_RATIO * enclosingRect.size.width;
//        CGFloat topBoundary = enclosingRect.origin.y;
//        CGFloat bottomBoundary = enclosingRect.origin.y + enclosingRect.size.height;
//        
//        for(double i = enclosingRect.origin.x; i < enclosingRect.size.width; i+=strokeSpacing){
//            [bezierPath moveToPoint:CGPointMake(i, topBoundary)];
//            [bezierPath addLineToPoint:CGPointMake(i, bottomBoundary)];
//        }
//        [color setStroke];
//        [bezierPath stroke];
    }
    
//    UIColor *fillandStrokeColor = self.colors[self.color];
//    
//    [fillandStrokeColor setStroke];
//    [bezierPath stroke];
//    
//    if(![self.shading isEqualToString:@"Open"]){
//        [fillandStrokeColor setFill];
//        [bezierPath fill];
//    }else{
//        [[UIColor whiteColor] setFill];
//        [bezierPath fill];
//    }
    
    [self restoreContext];
}

-(void)addStrokeToRect:(CGRect)aRect{
    [self saveContext];
    CGFloat strokeSpacing = STROKE_SPACE_RATIO * aRect.size.width;
    CGFloat topBoundary = aRect.origin.y;
    CGFloat bottomBoundary = aRect.origin.y + aRect.size.height;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    bezierPath.lineWidth = 0.25;
    for(double i = aRect.origin.x; i < (aRect.origin.x + aRect.size.width); i+=strokeSpacing){
        [bezierPath moveToPoint:CGPointMake(i, topBoundary)];
        [bezierPath addLineToPoint:CGPointMake(i, bottomBoundary)];
    }
//    [[UIColor blackColor] setStroke];
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
