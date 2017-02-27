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
    CellWithInputField,
}SettingsCellType;

typedef enum{
    CellFirst,
    CellFirstNotIcon,
    CellMiddle,
    CellLast,
    CellOnlyOne,
    CellNoIcon,
}SettingsCellPositionType;


@protocol LCVPNDetailTableViewCellDelegate <NSObject>

@optional
- (void)switchedSaveTabIsOn:(BOOL)isOn;
- (void)contentDidChanged:(NSString *)text forIndexPath:(NSIndexPath *)indexPath;

@end


@interface LCVPNDetailTableViewCell : UITableViewCell

@property (nonatomic,weak) NSString *url;
@property (nonatomic,weak) NSString *title;

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) UITextField *inputField;;


@property (nonatomic,assign) SettingsCellType cellType;
@property (nonatomic,assign) SettingsCellPositionType positionType;

@property (nonatomic,assign) id<LCVPNDetailTableViewCellDelegate> delegate;

- (BOOL)isOpenCellRightSwitch;
- (void)setCellRightText:(NSString*)text;
- (void)setCellRightSwitch:(BOOL)isOpen;
//add for 2016/6/16 by CLL 用户清除缓存数据页面更新位置
- (void)updateRightLabelForCellHeight:(CGFloat)h;


- (void)setCellInputText:(NSString*)text isSecretInput:(BOOL)isSecretInput;

@end
