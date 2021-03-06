//
//  RadioButtonGroup.h
//  TNRadioButtonGroupDemo
//
//  Created by Frederik Jacques on 22/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNCircularRadioButton.h"
#import "TNRectangularRadioButton.h"
#import "TNImageRadioButton.h"

extern NSString *const SELECTED_RADIO_BUTTON_CHANGED;

typedef enum : NSUInteger {
    TNRadioButtonGroupLayoutHorizontal,
    TNRadioButtonGroupLayoutVertical
} TNRadioButtonGroupLayout;

//typedef void (^maxSelectionBlock)();

@interface TNRadioButtonGroup : UIView <TNRadioButtonDelegate>

@property (nonatomic, strong) NSArray *radioButtonData;

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic) CGPoint position;
@property (nonatomic) NSInteger marginBetweenItems;
@property (nonatomic) UIEdgeInsets itemsInsets;

@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, strong) UIColor *labelColor;

@property (nonatomic, strong) UIColor *textActiveColor;
@property (nonatomic, strong) UIColor *textPassiveColor;
@property (nonatomic, strong) UIColor *controlActiveColor;
@property (nonatomic, strong) UIColor *controlPassiveColor;

@property (nonatomic, strong) NSArray *radioButtons;
@property (nonatomic, weak) TNRadioButton *selectedRadioButton;

@property (nonatomic, assign) BOOL multipleOptions;
@property (nonatomic) NSInteger maxSelection;
@property (nonatomic, copy) void (^maxSelectionBlock)(void);

- (instancetype)initWithRadioButtonData:(NSArray *)radioButtonData layout:(TNRadioButtonGroupLayout)layout;
- (void)create;
- (void)update;
@end
