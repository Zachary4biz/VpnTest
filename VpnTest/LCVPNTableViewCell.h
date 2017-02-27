//
//  SettingsTableViewCell.h
//  APUSBrowser
//
//  Created by luanchen on 16/6/6.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    CellNormal,
    CellWithRightText,
    CellWithRightSwitch,
    CellWithRightSwitchAndRightText,
}SettingsCellType;

typedef enum{
    CellFirst,
    CellFirstNotIcon,
    CellMiddle,
    CellLast,
    CellOnlyOne,
    CellNoIcon,
}SettingsCellPositionType;


@protocol LCVPNTableViewCellDelegate <NSObject>

@optional
- (void)switchedSaveTabIsOn:(BOOL)isOn;

@end


@interface LCVPNTableViewCell : UITableViewCell

@property (nonatomic,weak) NSString *url;
@property (nonatomic,weak) NSString *title;
@property (nonatomic,assign) SettingsCellType cellType;
@property (nonatomic,assign) SettingsCellPositionType positionType;

@property (nonatomic,assign) id<LCVPNTableViewCellDelegate> delegate;

- (BOOL)isOpenCellRightSwitch;
- (void)setCellRightText:(NSString*)text;
- (void)setCellRightSwitch:(BOOL)isOpen;
//add for 2016/6/16 by CLL 用户清除缓存数据页面更新位置
- (void)updateRightLabelForCellHeight:(CGFloat)h;

@end
