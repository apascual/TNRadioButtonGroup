//
//  RadioButton.m
//  TNRadioButtonGroupDemo
//
//  Created by Frederik Jacques on 22/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNRadioButton.h"

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
    
    [self createLabel];
    [self createHiddenButton];
    
    [self selectWithAnimation:NO];
    self.frame = self.btnHidden.frame;
}

- (void)update {
    [self updateLabel];
}

- (void)updateLabel {
    self.lblLabel.backgroundColor = [UIColor clearColor];
    self.lblLabel.numberOfLines = 0;
    self.lblLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblLabel.font = self.data.labelFont;
    self.lblLabel.textColor = self.data.selected?self.data.labelActiveColor:self.data.labelPassiveColor;
    self.lblLabel.text = self.data.labelText;
    
    self.priceLabel.backgroundColor = [UIColor clearColor];
    self.priceLabel.numberOfLines = 0;
    self.priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.priceLabel.font = self.data.labelFont;
    self.priceLabel.textColor = self.data.selected?self.data.labelActiveColor:self.data.labelPassiveColor;
    self.priceLabel.text = self.data.priceText;
}

- (void)createRadioButton {}

- (void)createLabel {
    
    // Temporary solution
    CGFloat realWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat maxWidth = realWidth - self.radioButton.frame.size.width - 15.0f - 80.0f - 45.0f;
    CGSize labelSize;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        labelSize = [self.data.labelText sizeWithFont:self.data.labelFont forWidth:maxWidth lineBreakMode:NSLineBreakByWordWrapping];
        
    } else {
        CGRect labelRect = [self.data.labelText boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.data.labelFont} context:nil];
        
        labelSize = CGSizeMake(labelRect.size.width, labelRect.size.height);
        
    }
    
    CGFloat yPos = MAX(0, (self.radioButton.frame.size.height - labelSize.height) / 2);
    
    self.lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.radioButton.frame.origin.x + self.radioButton.frame.size.width + 15, yPos, labelSize.width, labelSize.height)];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(realWidth - 120, yPos, 40, labelSize.height)];
    
    [self updateLabel];
    [self addSubview:self.lblLabel];
    [self addSubview:self.priceLabel];
}

- (void)createHiddenButton {
    
    int height = MAX(self.lblLabel.frame.size.height, self.radioButton.frame.size.height);
    
    self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnHidden.frame = CGRectMake(0, 0, self.lblLabel.frame.origin.x + self.lblLabel.frame.size.width, height);
    [self addSubview:self.btnHidden];
    
    [self.btnHidden addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Animations
- (void)selectWithAnimation:(BOOL)animated {
    [self updateLabel];
}

@end
