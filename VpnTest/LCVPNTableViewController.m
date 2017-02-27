//
//  LCVPNTableViewController.m
//  VpnTest
//
//  Created by luanchen on 2016/12/14.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import "LCVPNTableViewController.h"
#import "LCVPNTableViewCell.h"
#import "LCVPNModel.h"

#define NAVIGATIONBAR_HEIGHT 64
#define SECTION_HEADER_HEIGHT 16
#define CELL_HEIGHT 50


@interface LCVPNTableViewController ()<LCVPNTableViewCellDelegate>

@end

@implementation LCVPNTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.frame = self.view.bounds;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];//不显示多余的分割线
    self.tableView.contentInset = UIEdgeInsetsMake(-NAVIGATIONBAR_HEIGHT/*-SECTION_HEADER_HEIGHT*/, 0, 0, 0);
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 3;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SECTION_HEADER_HEIGHT;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, SECTION_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    LCVPNTableViewCell *cell = (LCVPNTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[LCVPNTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];//设置风格
        cell.delegate = self;
    }
    
    [self setCellData:indexPath tocell:cell];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(deBugLog)NSLog(@"didSelectRowAtIndexPath %ld %ld",(long)indexPath.section,(long)indexPath.row);
    
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [self.delegate didSelectRowAtIndexPath:indexPath];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
- (void)setCellData:(NSIndexPath *)indexPath tocell:(LCVPNTableViewCell *)tocell {
    
    tocell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//后面那个标标的风格；
    tocell.selectionStyle = UITableViewCellSelectionStyleNone;
    tocell.cellType = CellNormal;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
//            case 0:
//                tocell.textLabel.text = @"Default Search Engine";
////                [self setupSearchEngineImage:tocell Position:_positionOfSearchEngine];
//                tocell.positionType = CellFirst;
//                break;
//            case 1:
//            {
//                tocell.textLabel.text = @"Clear Data";
//                tocell.imageView.image = nil;
//                tocell.imageView.image = [self itemImageWithName:@"settings_clear_data" itemSize:CGSizeMake(30, 30)];
//                tocell.positionType = CellLast;
//            }
//                break;
            case 0:
                tocell.textLabel.text = @"VPN状态";
//                tocell.imageView.image = [self itemImageWithName:@"settings_open_last_tab_when_starts_up" itemSize:CGSizeMake(30, 30)];
                tocell.accessoryType = UITableViewCellAccessoryNone;
                tocell.cellType = CellWithRightSwitchAndRightText;
                tocell.positionType = CellOnlyOne;
                
                [tocell setCellRightSwitch:self.vpnModel.status>1];
                
                [tocell setCellRightText:self.vpnModel.statusText];
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        tocell.selectionStyle = UITableViewCellSelectionStyleNone;
        tocell.cellType = CellWithRightText;
        tocell.accessoryType = UITableViewCellAccessoryNone;
        switch (indexPath.row) {
            case 0:
            {
                tocell.textLabel.text = @"类型";
                NSString *type = self.vpnModel.type==0?@"IPSec":@"Other";
                [tocell setCellRightText:[NSString stringWithFormat:@"%@",type]];
//                tocell.imageView.image = [self itemImageWithName:@"settings_tell_friends" itemSize:CGSizeMake(30, 30)];
                tocell.positionType = CellFirst;
                break;
            }
            case 1:
                tocell.textLabel.text = @"服务器";
                [tocell setCellRightText:[NSString stringWithFormat:@"%@",self.vpnModel.adress]];
//                tocell.imageView.image = [self itemImageWithName:@"settings_rate_us" itemSize:CGSizeMake(30, 30)];
                tocell.positionType = CellMiddle;
                break;
            case 2:
                tocell.textLabel.text = @"账户";
                [tocell setCellRightText:[NSString stringWithFormat:@"%@",self.vpnModel.account]];
//                tocell.imageView.image = [self itemImageWithName:@"settings_feedback" itemSize:CGSizeMake(30, 30)];
                tocell.positionType = CellLast;
                break;
//            case 3:
//                tocell.textLabel.text = @"Version";
//                tocell.imageView.image = [self itemImageWithName:@"settings_version" itemSize:CGSizeMake(30, 30)];
//                tocell.accessoryType = UITableViewCellAccessoryNone;
//                [tocell setCellRightText:[NSString stringWithFormat:@"V%@",[self getVersionText]]];//tbd
//                tocell.cellType = CellWithRightText;
//                tocell.positionType = CellMiddle;
//                break;
//            case 4:
//                tocell.textLabel.text = @"Terms & Privacy";
//                tocell.imageView.image = [self itemImageWithName:@"settings_terms_privacy" itemSize:CGSizeMake(30, 30)];
//                tocell.positionType = CellLast;
//                break;
                
            default:
                break;
        }
    }
}


//- (void)setupSearchEngineImage:(SettingsTableViewCell *)tocell Position:(NSInteger)position{
//    switch (position) {
//        case 0:
//            tocell.imageView.image = [self itemImageWithName:@"settings_icon2" itemSize:CGSizeMake(30, 30)];
//            break;
//        case 1:
//            tocell.imageView.image = [self itemImageWithName:@"settings_icon3" itemSize:CGSizeMake(30, 30)];
//            break;
//        case 2:
//            tocell.imageView.image = [self itemImageWithName:@"settings_icon4" itemSize:CGSizeMake(30, 30)];
//            break;
//        case 3:
//            tocell.imageView.image = [self itemImageWithName:@"settings_icon5" itemSize:CGSizeMake(30, 30)];
//            break;
//        case 4:
//            tocell.imageView.image = [self itemImageWithName:@"settings_icon6" itemSize:CGSizeMake(30, 30)];
//            break;
//        case 5:
//            tocell.imageView.image = [self itemImageWithName:@"settings_icon7" itemSize:CGSizeMake(30, 30)];
//            break;
//        case 6:
//            tocell.imageView.image = [self itemImageWithName:@"settings_icon8" itemSize:CGSizeMake(30, 30)];
//            break;
//        case 7:
//            tocell.imageView.image = [self itemImageWithName:@"settings_icon9" itemSize:CGSizeMake(30, 30)];
//            break;
//            
//        default:
//            break;
//    }
//}

- (void)switchedSaveTabIsOn:(BOOL)isOn{
//    if(deBugLog)NSLog(@"switchedSaveTabIsOn %d",isOn);//for Analytics
    if ([self.delegate respondsToSelector:@selector(switchedSaveTabIsOn:)]) {
        [self.delegate switchedSaveTabIsOn:isOn];
    }
}

//-(void)setCellRightSwitch:(BOOL)isOpen{
//    
//    LCVPNTableViewCell *cell = (LCVPNTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    
//    [cell setCellRightSwitch:isOpen];
//    
//
//}

- (NSString *)getVersionText{
    return @"1.0.0";
//    return [SMStaticFunction getAppFullVersion];
}

- (UIImage *)itemImageWithName:(NSString *)imageName itemSize:(CGSize)itemSize{
    
    UIImage *icon = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
