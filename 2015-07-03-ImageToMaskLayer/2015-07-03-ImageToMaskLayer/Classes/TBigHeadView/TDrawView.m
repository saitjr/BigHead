//
//  TTouchView.m
//  2015-07-03-ImageToMaskLayer
//
//  Created by TangJR on 7/3/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "TDrawView.h"
#import "TDrawPath.h"

typedef struct TDrawBounds {
    
    CGFloat minX;
    CGFloat minY;
    CGFloat maxX;
    CGFloat maxY;
} TDrawBoundsBuffer;

TDrawBoundsBuffer buffer = {NSIntegerMax, NSIntegerMax, NSIntegerMin, NSIntegerMin};

@interface TDrawView ()

@property (strong, nonatomic) TDrawPath *path;
@property (strong, nonatomic) NSMutableArray *paths;
//@property (assign, nonatomic) TDrawBoundsBuffer *buffer;

@end

@implementation TDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

#pragma mark - Support methods

- (CGPoint)pointWithTouches:(NSSet *)touches {
    
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

- (void)updateBoundsWithPoint:(CGPoint)point {
    
    CGFloat left = point.x - self.lineWidth / 2;
    CGFloat top = point.y - self.lineWidth / 2;
    CGFloat right = point.x + self.lineWidth / 2;
    CGFloat bottom = point.y + self.lineWidth / 2;

    buffer.minX = buffer.minX < left ? buffer.minX : left;
    buffer.minY = buffer.minY < top ? buffer.minY : top;
    buffer.maxX = buffer.maxX > right ? buffer.maxX : right;
    buffer.maxY = buffer.maxY > bottom ? buffer.maxY : bottom;
}

#pragma mark - Touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    CGPoint point = [self pointWithTouches:touches];
    
    self.path = [[TDrawPath alloc] init];
    self.path.lineWidth = self.lineWidth;
    self.path.isClear = self.isClear;
    [self.paths addObject:_path];
    [self.path moveToPoint:point];
    
    [self updateBoundsWithPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    
    CGPoint point = [self pointWithTouches:touches];
    
    [self.path addLineToPoint:point];
    [self updateBoundsWithPoint:point];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    for (TDrawPath *path in self.paths) {
        
        CGContextSetLineWidth(context, path.lineWidth);
        CGContextAddPath(context, path.CGPath);
        if (path.isClear) {
            
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
            [[UIColor clearColor] set];
            CGContextStrokePath(context);
            continue;
        }
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
        [[UIColor redColor] set];
        CGContextStrokePath(context);
    }
}

#pragma mark - Property getter/setter

- (NSMutableArray *)paths {
    
    if (_paths == nil) {
        
        _paths = [[NSMutableArray alloc] init];
    }
    return _paths;
}

- (CGFloat)lineWidth {
    
    if (_lineWidth <= 0) {
        
        _lineWidth = 20;
    }
    return _lineWidth;
}

- (CGRect)imageRect {
    
    CGRect frame = CGRectMake(buffer.minX, buffer.minY, buffer.maxX - buffer.minX, buffer.maxY - buffer.minY);
    
    return frame;
}

@end