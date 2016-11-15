//
//  TNCircularRadioButton.m
//  TNRadioButtonGroupDemo
//
//  Created by Frederik Jacques on 22/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNRectangularRadioButton.h"
#import <PureLayout/PureLayout.h>

@interface TNRectangularRadioButton()

@property (nonatomic, strong) CAShapeLayer *border;
@property (nonatomic, strong) CAShapeLayer *rectangle;

@end

@implementation TNRectangularRadioButton

#pragma mark - Initializers

- (instancetype)initWithData:(TNRectangularRadioButtonData *)data {
    
    self = [super initWithData:data];
    
    if (self) {
        // Initialization code
        self.data = data;
        
        [self setup];
    }
    
    return self;
}

#pragma mark - Creation
- (void)setup{
    [self createRadioButton];
    [super setup];
}

- (void)updateBorder {
    self.border.frame = CGRectMake(0, 0, self.data.borderWidth, self.data.borderHeight);
    self.border.lineWidth = self.data.borderLineThickness;
    self.border.strokeColor = self.data.selected?self.data.borderActiveColor.CGColor:self.data.borderPassiveColor.CGColor;
    self.border.fillColor = [UIColor clearColor].CGColor;
}

- (void)updateRectangle {
    self.rectangle.frame = CGRectMake((self.border.frame.size.width - self.data.rectangleWidth) / 2, (self.border.frame.size.height - self.data.rectangleHeight) / 2, self.data.rectangleWidth, self.data.rectangleHeight);
    self.rectangle.lineWidth = 3.0f;
    self.rectangle.strokeColor = self.data.selected?self.data.rectangleActiveColor.CGColor:self.data.rectanglePassiveColor.CGColor;
    self.rectangle.fillColor = [UIColor clearColor].CGColor;
}

- (void)createRadioButton {
    self.radioButton = [UIView newAutoLayoutView];
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.data.borderWidth, self.data.borderHeight) cornerRadius:2.0f];
    
    UIBezierPath *rectangularPath = [[UIBezierPath alloc] init];
    [rectangularPath moveToPoint:CGPointMake(0.0f, self.data.rectangleHeight*1/2)];
    [rectangularPath addLineToPoint:CGPointMake(self.data.rectangleWidth*1/3, self.data.rectangleHeight*5/6)];
    [rectangularPath addLineToPoint:CGPointMake(self.data.rectangleWidth, self.data.rectangleHeight*1/8)];
    
    self.border = [CAShapeLayer layer];
    self.border.path = borderPath.CGPath;
    [self updateBorder];
    
    [self.radioButton.layer addSublayer:self.border];
    
    self.rectangle = [CAShapeLayer layer];
    self.rectangle.path = rectangularPath.CGPath;
    [self updateRectangle];
    
    [self.radioButton.layer addSublayer:self.rectangle];
    
    [self addSubview:self.radioButton];
    
    [self.radioButton autoSetDimensionsToSize:CGSizeMake(self.data.borderWidth, self.data.borderHeight)];
    [self.radioButton autoPinEdgeToSuperviewEdge:NSLayoutAttributeLeft];
    [self.radioButton autoAlignAxisToSuperviewAxis:NSLayoutAttributeCenterY];
    [self.radioButton autoPinEdgeToSuperviewEdge:NSLayoutAttributeTop withInset:0.0f relation:NSLayoutRelationGreaterThanOrEqual];
    [self.radioButton autoPinEdgeToSuperviewEdge:NSLayoutAttributeBottom withInset:0.0f relation:NSLayoutRelationGreaterThanOrEqual];
    
    [self selectWithAnimation:NO];
}

#pragma mark - Animations
- (void)selectWithAnimation:(BOOL)animated {
    [super selectWithAnimation:animated];
    
    [self updateBorder];
    [self updateRectangle];
    
    NSNumber *scaleValue = (self.data.selected) ? @1 : @0;
    
    if( animated ){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.toValue = scaleValue;
        animation.duration = 0.3f;
        
        [self.rectangle addAnimation:animation forKey:nil];
    }
    self.rectangle.strokeEnd = scaleValue.floatValue;
}


@end
