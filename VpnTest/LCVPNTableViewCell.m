//
//  LCVPNTableViewCell.m
//  APUSBrowser
//
//  Created by luanchen on 16/6/6.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import "LCVPNTableViewCell.h"
//#import "UISettings.h"
//#import "UIViewExt.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define CELL_HEIGHT 50

@interface LCVPNTableViewCell()
{
    UIImageView *_icon;
    UILabel *_titleLabel;
    UILabel *_rightLabel;
}

@property (nonatomic,strong) UISwitch *rightSwitch;

@end

@implementation LCVPNTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initialize_subviews];
    }
    
    return self;
}

- (void)initialize_subviews{
    _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, (CELL_HEIGHT-24)/2, SCREEN_WIDTH/2-20, 24)];
    _rightSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, (CELL_HEIGHT-28)/2-1, 70 , 28)];
    
    [_rightSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:_rightLabel];
    [self addSubview:_rightSwitch];
    
    _rightLabel.alpha = 0;
    _rightSwitch.alpha = 0;
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = [UIFont systemFontOfSize:16];
    _rightLabel.textColor = [UIColor lightGrayColor];
    
}

-(void)setCellType:(SettingsCellType)cellType{
    _rightLabel.frame = CGRectMake(SCREEN_WIDTH/2, (CELL_HEIGHT-24)/2, SCREEN_WIDTH/2-20, 24);
//    _rightSwitch.frame = CGRectMake(SCREEN_WIDTH-70, (CELL_HEIGHT-28)/2-1, 70 , 28);
    if(cellType == CellWithRightSwitch) {
        _rightSwitch.alpha = 1;
        _rightLabel.alpha = 0;
    } else if(cellType == CellWithRightText) {
        _rightSwitch.alpha = 0;
        _rightLabel.alpha = 1;
    }  else if(cellType == CellWithRightSwitchAndRightText) {
        _rightSwitch.alpha = 1;
        _rightLabel.alpha = 1;
        _rightLabel.frame = CGRectMake(SCREEN_WIDTH/2-70, (CELL_HEIGHT-24)/2, SCREEN_WIDTH/2-20, 24);
    } else {
        _rightSwitch.alpha = 0;
        _rightLabel.alpha = 0;
    }
}

- (void)setCellRightText:(NSString*)text{
    _rightLabel.text = text;
}

- (void)setCellRightSwitch:(BOOL)isOpen{
    _rightSwitch.on = isOpen;
}

- (BOOL)isOpenCellRightSwitch{
    return _rightSwitch.on;
}
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        if ([self.delegate respondsToSelector:@selector(switchedSaveTabIsOn:)]) {
            [self.delegate switchedSaveTabIsOn:isButtonOn];
        }
        
    }else {
        if ([self.delegate respondsToSelector:@selector(switchedSaveTabIsOn:)]) {
            [self.delegate switchedSaveTabIsOn:isButtonOn];
        }
        
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    if (self.positionType == CellFirst) {
        //上全分割线，
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:0.4].CGColor);
        CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
        //下分割线
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:0.4].CGColor);
        CGContextStrokeRect(context, CGRectMake(19/*+30+17*/, rect.size.height, rect.size.width, 0.8));
    }else if (CellFirstNotIcon == self.positionType) {
        //上全分割线，
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:0.4].CGColor);
        CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
        //下分割线
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:0.4].CGColor);
        CGContextStrokeRect(context, CGRectMake(19, rect.size.height, rect.size.width, 0.8));
        
    }else if (self.positionType == CellLast) {
        //下全分割线
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:0.4].CGColor);
        CGContextStrokeRect(context, CGRectMake(0, rect.size.height-0.5, rect.size.width, 0.5));
    }else if (self.positionType == CellOnlyOne) {
        //上全分割线，
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:0.4].CGColor);
        CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
        //下全分割线
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:0.4].CGColor);
        CGContextStrokeRect(context, CGRectMake(0, rect.size.height-0.5, rect.size.width, 0.5));
    }else if (self.positionType == CellNoIcon) {
        //下分割线
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:0.4].CGColor);
        CGContextStrokeRect(context, CGRectMake(19, rect.size.height, rect.size.width, 0.8));
    }else{
        //下分割线
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:0.4].CGColor);
        CGContextStrokeRect(context, CGRectMake(19/*+30+17*/, rect.size.height, rect.size.width, 0.8));
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.textColor = [UIColor darkTextColor];
}

//add for 2016/6/16 by CLL 用户清除缓存数据页面更新位置
- (void)updateRightLabelForCellHeight:(CGFloat)h
{
//    [_rightLabel sizeToFit];
//    _rightLabel.right = SCREEN_WIDTH-10;
//    _rightLabel.top = (h - _rightLabel.height) * 0.5;
}
@end
