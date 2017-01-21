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
    
    [self drawSquiggleAt:-1*([self shapeWidthScaleFactor]/2) and:0 withColor:[UIColor blueColor] andShading:@"Open"];
    
//    [self drawOvalAt:-1*([self shapeWidthScaleFactor]/2) and:-1*([self shapeHeightScaleFactor]/2) withColor:[UIColor blueColor] andShading:@"Striped"];
    
//    [self drawDiamondAt:-1*([self shapeWidthScaleFactor]/2) and:0 withColor:[UIColor greenColor] andShading:@"Striped"];
}

-(void)drawSquiggleAt: (CGFloat)hOffset and:(CGFloat)vOffset withColor:(UIColor *)color andShading:(NSString *)shading{
    [self saveContext];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint startPoint = CGPointMake(center.x + hOffset, center.y + vOffset);
    CGFloat shapeHeight = [self shapeHeightScaleFactor];
    CGFloat shapeWidth = [self shapeWidthScaleFactor];

    
    //7 Curves are needed to draw squiggle. Create an array of points for each curve
    NSArray *curve1 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.45*shapeWidth, startPoint.y-0.35*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.15*shapeWidth, startPoint.y - 0.4*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.3*shapeWidth, startPoint.y - 0.43*shapeHeight)]
                        ];
    
    
    NSArray *curve2 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.85*shapeWidth, startPoint.y-0.45*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.6*shapeWidth, startPoint.y - 0.25*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.75*shapeWidth, startPoint.y - 0.25*shapeHeight)]
                        ];
    
    NSArray *curve3 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.95*shapeWidth, startPoint.y-0.2*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.9*shapeWidth, startPoint.y - 0.5*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.955*shapeWidth, startPoint.y - 0.4*shapeHeight)]
                        ];
    
    NSArray *curve4 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.8*shapeWidth, startPoint.y+0.32*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.92*shapeWidth, startPoint.y + 0.2*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.85*shapeWidth, startPoint.y + 0.3*shapeHeight)]
                        ];
    NSArray *curve5 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.355*shapeWidth, startPoint.y+0.29*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.65*shapeWidth, startPoint.y + 0.42*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.45*shapeWidth, startPoint.y + 0.3*shapeHeight)]
                        ];
    NSArray *curve6 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.15*shapeWidth, startPoint.y+0.45*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.18*shapeWidth, startPoint.y + 0.35*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.15*shapeWidth, startPoint.y + 0.45*shapeHeight)]
                        ];
    
    NSArray *curve7 = @[[NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.01*shapeWidth, startPoint.y+0.2*shapeHeight)],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.1*shapeWidth, startPoint.y + 0.5*shapeHeight )],
                        [NSValue valueWithCGPoint:CGPointMake(startPoint.x + 0.04*shapeWidth, startPoint.y + 0.4*shapeHeight)]
                        ];
    
    NSArray *curve8;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    [bezierPath moveToPoint:startPoint];
    [bezierPath addCurveToPoint:((NSValue *)curve1[0]).CGPointValue controlPoint1:((NSValue *)curve1[1]).CGPointValue controlPoint2:((NSValue *)curve1[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve2[0]).CGPointValue controlPoint1:((NSValue *)curve2[1]).CGPointValue controlPoint2:((NSValue *)curve2[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve3[0]).CGPointValue controlPoint1:((NSValue *)curve3[1]).CGPointValue controlPoint2:((NSValue *)curve3[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve4[0]).CGPointValue controlPoint1:((NSValue *)curve4[1]).CGPointValue controlPoint2:((NSValue *)curve4[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve5[0]).CGPointValue controlPoint1:((NSValue *)curve5[1]).CGPointValue controlPoint2:((NSValue *)curve5[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve6[0]).CGPointValue controlPoint1:((NSValue *)curve6[1]).CGPointValue controlPoint2:((NSValue *)curve6[2]).CGPointValue];
    
    [bezierPath addCurveToPoint:((NSValue *)curve7[0]).CGPointValue controlPoint1:((NSValue *)curve7[1]).CGPointValue controlPoint2:((NSValue *)curve7[2]).CGPointValue];
    
    [color setStroke];
    [bezierPath stroke];
    
    
    [self restoreContext];
}

#define OVAL_CORNER_RADIUS_RATIO 0.3

-(void)drawOvalAt: (CGFloat)hOffSet and:(CGFloat)vOffSet withColor:(UIColor *)color andShading:(NSString *)shading{
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
    bezierPath.lineWidth = 3.0;
    
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
    
    [self restoreContext];
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
    bezierPath.lineWidth = 3.0;
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
