//
//  TTouchView.m
//  2015-07-03-ImageToMaskLayer
//
//  Created by TangJR on 7/3/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "TDrawView.h"
#import "TDrawPath.h"

@interface TDrawView ()

@property (strong, nonatomic) TDrawPath *path;
@property (strong, nonatomic) NSMutableArray *paths;

@property (assign, nonatomic) CGFloat minX;
@property (assign, nonatomic) CGFloat minY;
@property (assign, nonatomic) CGFloat maxX;
@property (assign, nonatomic) CGFloat maxY;

@end

@implementation TDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        [self setupDatas];
    }
    
    return self;
}

#pragma mark - setup

- (void)setupDatas {
    
    self.minX = NSIntegerMax;
    self.minY = NSIntegerMax;
    self.maxX = NSIntegerMin;
    self.maxY = NSIntegerMin;
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
    
//    if (self.isClear) {
//        
//        if (_minX > ) {
//            <#statements#>
//        }
//        return;
//    }
    _minX = _minX > left ? left : _minX;
    _minY = _minY > top ? top : _minY;
    _maxX = _maxX < right ? right : _maxX;
    _maxY = _maxY < bottom ? bottom : _maxY;
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
    
    NSLog(@"%@", NSStringFromCGRect(CGRectMake(_minX, _minY, _maxX - _minX, _maxY - _minY)));
    return CGRectMake(_minX, _minY, _maxX - _minX, _maxY - _minY);
}

@end