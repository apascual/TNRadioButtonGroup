//
//  RadioButtonGroup.m
//  TNRadioButtonGroupDemo
//
//  Created by Frederik Jacques on 22/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNRadioButtonGroup.h"

NSString *const SELECTED_RADIO_BUTTON_CHANGED = @"selectedRadioButtonChanged";

@interface TNRadioButtonGroup()

@property (nonatomic) TNRadioButtonGroupLayout layout;
@property (nonatomic) NSInteger widthOfComponent;
@property (nonatomic) NSInteger heightOfComponent;

@end

@implementation TNRadioButtonGroup

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.layout = TNRadioButtonGroupLayoutVertical;
        self.marginBetweenItems = 15;
        self.itemsInsets = UIEdgeInsetsZero;
    }
    
    return self;
}

- (instancetype)initWithRadioButtonData:(NSArray *)radioButtonData layout:(TNRadioButtonGroupLayout)layout {
    
    self = [super init];
    
    if (self) {
        self.radioButtonData = radioButtonData;
        self.layout = layout;
        self.marginBetweenItems = 15;
        self.itemsInsets = UIEdgeInsetsZero;
    }
    
    return self;
}

#pragma mark - Setup
- (void)create {
    [self createRadioButtons];
    
    self.frame = CGRectMake(0, 0, self.widthOfComponent, self.heightOfComponent);
}

-(void)update {
    for (TNRadioButton *radioButton in self.radioButtons) {
        [radioButton update];
    }
}

- (void)createRadioButtons {
    
    int xPos = _itemsInsets.left;
    int yPos = _itemsInsets.top;
    int maxHeight = 0;
    int i = 0;
    
    for (TNRadioButton *radioButton in self.radioButtons) {
        [radioButton removeFromSuperview];
    }
    self.radioButtons = nil;
    
    NSMutableArray *tmp = [NSMutableArray new];
    
    for (TNRadioButtonData *data in self.radioButtonData) {
        
        TNRadioButton *radioButton = nil;
        
        if( !data.labelFont) data.labelFont = self.labelFont;
        if( !data.labelActiveColor) data.labelActiveColor = self.textActiveColor;
        if( !data.labelPassiveColor) data.labelPassiveColor = self.textPassiveColor;
        
        if( [data isKindOfClass:[TNCircularRadioButtonData class]] ){
            TNCircularRadioButtonData *rData = (TNCircularRadioButtonData *)data;
            rData.borderActiveColor = self.controlActiveColor;
            rData.borderPassiveColor = self.controlPassiveColor;
            rData.circleActiveColor = self.controlActiveColor;
            rData.circlePassiveColor = self.controlPassiveColor;
            radioButton = [[TNCircularRadioButton alloc] initWithData:rData];
        }else if( [data isKindOfClass:[TNRectangularRadioButtonData class]] ){
            TNRectangularRadioButtonData *rData = (TNRectangularRadioButtonData *)data;
            rData.borderActiveColor = self.controlActiveColor;
            rData.borderPassiveColor = self.controlPassiveColor;
            rData.rectangleActiveColor = self.controlActiveColor;
            rData.rectanglePassiveColor = self.controlPassiveColor;
            radioButton = [[TNRectangularRadioButton alloc] initWithData:rData];
        }else if( [data isKindOfClass:[TNImageRadioButtonData class]] ){
            radioButton = [[TNImageRadioButton alloc] initWithData:(TNImageRadioButtonData *)data];
        }
        
        // If there is already a radio button selected ... deselect the current one
        if( self.selectedRadioButton ){
            data.selected = NO;
        }
        
        data.tag = i;
        
        radioButton.delegate = self;
        radioButton.multipleOptions = self.multipleOptions;
        
        CGRect frame;
        
        if( self.layout == TNRadioButtonGroupLayoutHorizontal ){
            frame = CGRectMake(xPos, _itemsInsets.top, radioButton.frame.size.width, radioButton.frame.size.height);
        }else{
            frame = CGRectMake(_itemsInsets.left, yPos, radioButton.frame.size.width, radioButton.frame.size.height);
        }
        
        radioButton.frame = frame;
        [self addSubview:radioButton];
        
        xPos += radioButton.frame.size.width + self.marginBetweenItems;
        yPos += radioButton.frame.size.height + self.marginBetweenItems;
        maxHeight = MAX(maxHeight, radioButton.frame.size.height);
        
        if( self.layout == TNRadioButtonGroupLayoutVertical ){
            maxHeight = yPos;
        }
        
        //        if( data.selected ){
        //            self.selectedRadioButton = radioButton;
        //        }
        
        [tmp addObject:radioButton];
        i++;
    }
    
    self.widthOfComponent = xPos;
    self.heightOfComponent = maxHeight;
    self.radioButtons = [NSArray arrayWithArray:tmp];
}

- (void)setMultipleOptions:(BOOL)multipleOptions {
    _multipleOptions = multipleOptions;
    for (TNRadioButton *button in self.radioButtons) {
        button.multipleOptions = multipleOptions;
    }
}

- (NSInteger)numberOfSelectedOptions {
    NSInteger selected = 0;
    for (TNRadioButton *rb in self.radioButtons) {
        if(rb.data.selected) {
            selected++;
        }
    }
    return selected;
}

- (BOOL)radioButtonCanChange:(TNRadioButton *)radioButton {
    NSInteger itemsSelected = [self numberOfSelectedOptions];
    if (self.multipleOptions && itemsSelected + 1 > self.maxSelection) {
        if (self.maxSelectionBlock != nil) {
            self.maxSelectionBlock();
        }
        return NO;
    }
    return YES;
}

#pragma mark - TNRadioButtonDelegate methods
- (void)radioButtonDidChange:(TNRadioButton *)radioButton {
    for (TNRadioButton *rb in self.radioButtons) {
        
        if(self.multipleOptions) {
            // In multiple-selection-mode
            if(rb == radioButton) {
                [rb selectWithAnimation:YES];
            }
        } else {
            // In single-selection-mode remove all other selections
            if(rb == radioButton) {
                rb.data.selected = YES;
                [rb selectWithAnimation:YES];
            } else {
                rb.data.selected = NO;
                [rb selectWithAnimation:YES];
            }
        }
    }
    
    self.selectedRadioButton = radioButton;
}

#pragma mark - Getters / Setters
- (void)setSelectedRadioButton:(TNRadioButton *)selectedRadioButton {
    
    if( _selectedRadioButton != selectedRadioButton || self.multipleOptions) {
        _selectedRadioButton = selectedRadioButton;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SELECTED_RADIO_BUTTON_CHANGED object:self];
    }
    
}

- (void)setPosition:(CGPoint)position {
    
    self.frame = CGRectMake(position.x, position.y, self.frame.size.width, self.frame.size.height);
    
}

- (UIColor *)labelColor {
    
    if( !_labelColor ){
        _labelColor = [UIColor blackColor];
    }
    
    return _labelColor;
    
}

- (UIFont *)labelFont {
    
    if( !_labelFont ){
        _labelFont = [UIFont systemFontOfSize:14];
    }
    
    return  _labelFont;
}


@end
