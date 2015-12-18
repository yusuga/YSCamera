//
//  YSCameraLocalization.m
//  YSCameraExample
//
//  Created by Yu Sugawara on 2015/12/18.
//  Copyright © 2015年 Yu Sugawara. All rights reserved.
//

#import "YSCameraLocalization.h"

NSString *YSCameraLocalizedString(NSString *key)
{
    return NSLocalizedStringFromTable(key, @"YSCameraLocalizable", nil);
}
