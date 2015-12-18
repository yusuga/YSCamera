//
//  UIImagePickerController+YSCamera.h
//  YSCameraExample
//
//  Created by Yu Sugawara on 2015/12/18.
//  Copyright © 2015年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSCamera;

@interface UIImagePickerController (YSCamera)

- (YSCamera *)ys_camera;
- (void)ys_setCamera:(YSCamera *)obj;

@end
