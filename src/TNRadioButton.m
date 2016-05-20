//
//  RadioButton.m
//  TNRadioButtonGroupDemo
//
//  Created by Frederik Jacques on 22/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNRadioButton.h"
#import <PureLayout/PureLayout.h>

@interface TNRadioButton()

@end

@implementation TNRadioButton

- (instancetype)initWithData:(TNRadioButtonData *)data {

    self = [super init];
    
    if (self) {
        self.data = data;
    }
    
    return self;
}

- (void)setup {
    self.lblLabel = [UILabel newAutoLayoutView];
    self.lblLabel.backgroundColor = [UIColor clearColor];
    self.lblLabel.numberOfLines = 0;
    self.lblLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblLabel.font = self.data.labelFont;
    self.lblLabel.textColor = self.data.selected?self.data.labelActiveColor:self.data.labelPassiveColor;
    self.lblLabel.text = self.data.labelText;
    
    [self addSubview:self.lblLabel];
    
    [self.lblLabel autoPinEdge:NSLayoutAttributeLeft toEdge:NSLayoutAttributeRight ofView:self.radioButton withOffset:8.0f];
    [self.lblLabel autoPinEdgeToSuperviewEdge:NSLayoutAttributeTop];
    [self.lblLabel autoPinEdgeToSuperviewEdge:NSLayoutAttributeBottom];
    
    if(self.data.priceText != nil) {
        self.priceLabel = [UILabel newAutoLayoutView];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.numberOfLines = 1;
        self.priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.priceLabel.font = self.data.labelFont;
        self.priceLabel.text = self.data.priceText;
        
        [self addSubview:self.priceLabel];
        
        [self.priceLabel autoPinEdgeToSuperviewEdge:NSLayoutAttributeRight];
        [self.priceLabel autoPinEdgeToSuperviewEdge:NSLayoutAttributeTop];
        [self.priceLabel autoPinEdgeToSuperviewEdge:NSLayoutAttributeBottom];
        [self.priceLabel autoSetDimension:NSLayoutAttributeWidth toSize:40.0f];
        [self.lblLabel autoPinEdge:NSLayoutAttributeRight toEdge:NSLayoutAttributeLeft ofView:self.priceLabel withOffset:-8.0f];
    }
    else {
        [self.lblLabel autoPinEdgeToSuperviewEdge:NSLayoutAttributeRight];
    }
    
    self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnHidden addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.btnHidden];
    
    [self.btnHidden autoPinEdgesToSuperviewEdges];
}


- (void)buttonTapped:(id)sender {
    
    if( !self.data.selected || self.multipleOptions ){
        
        BOOL canChange = YES;
        if(!self.data.selected && [self.delegate respondsToSelector:@selector(radioButtonCanChange:)]) {
            canChange = [self.delegate radioButtonCanChange:self];
        }
        
        if(canChange) {
            self.data.selected = !self.data.selected;
            
            if ([self.delegate respondsToSelector:@selector(radioButtonDidChange:)]) {
                [self.delegate radioButtonDidChange:self];
            }
        }
    }
}

- (void)update {
    self.lblLabel.textColor = self.data.selected?self.data.labelActiveColor:self.data.labelPassiveColor;
}

#pragma mark - Animations
- (void)selectWithAnimation:(BOOL)animated {
    [self update];
}

@end
