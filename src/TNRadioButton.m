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
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.data.labelText];
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInt:1]
                             range:self.data.linkRange];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:self.data.labelFont
                             range:NSMakeRange(0, self.data.labelText.length)];
    
    self.lblLabel.attributedText = attributedString;
    
    [self addSubview:self.lblLabel];
    
    [self.lblLabel autoPinEdge:NSLayoutAttributeLeft toEdge:NSLayoutAttributeRight ofView:self.radioButton withOffset:16.0f];
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
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapped:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (BOOL)didTapAttributedTextInLabel:(UILabel *)label withTapGesture:(UITapGestureRecognizer *)tapGesture inRange:(NSRange)targetRange {
    NSParameterAssert(label != nil);
    
    CGSize labelSize = label.bounds.size;
    // create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:label.attributedText];
    
    // configure layoutManager and textStorage
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    // configure textContainer for the label
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = label.lineBreakMode;
    textContainer.maximumNumberOfLines = label.numberOfLines;
    textContainer.size = labelSize;
    
    // find the tapped character location and compare it to the specified range
    CGPoint locationOfTouchInLabel = [tapGesture locationInView:self];
    locationOfTouchInLabel = [self.lblLabel convertPoint:locationOfTouchInLabel fromView:self];
    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
    
    //    CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
    //                                              (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    //    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
    //                                                         locationOfTouchInLabel.y - textContainerOffset.y);
    
    if(locationOfTouchInLabel.x >= 0 && locationOfTouchInLabel.y >= 0 && locationOfTouchInLabel.x < textBoundingBox.size.width && locationOfTouchInLabel.y < textBoundingBox.size.height) {
        
        NSInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInLabel
                                                           inTextContainer:textContainer
                                  fractionOfDistanceBetweenInsertionPoints:nil];
        
        if (NSLocationInRange(indexOfCharacter, targetRange)) {
            return YES;
        }
    }
    
    return NO;
}


- (void)buttonTapped:(UITapGestureRecognizer *)tapGesture {
    
    // 1st) Check if the click happened on a link
    if(self.data.linkRange.location != NSNotFound && [self didTapAttributedTextInLabel:self.lblLabel withTapGesture:tapGesture inRange:self.data.linkRange]) {
        
        if(self.data.linkBlock != nil) {
            self.data.linkBlock();
        }
        
        return;
    }
    
    // 2nd) Otherwise just handle normal selection
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
