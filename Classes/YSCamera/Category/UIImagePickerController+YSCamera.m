//
//  UIImagePickerController+YSCamera.m
//  YSCameraExample
//
//  Created by Yu Sugawara on 2015/12/18.
//  Copyright © 2015年 Yu Sugawara. All rights reserved.
//

#import "UIImagePickerController+YSCamera.h"
#import <objc/message.h>
#import "YSCamera.h"

@implementation UIImagePickerController (YSCamera)

- (YSCamera *)ys_camera
{
    return objc_getAssociatedObject(self, @selector(ys_camera));
}

- (void)ys_setCamera:(YSCamera *)obj
{
    objc_setAssociatedObject(self, @selector(ys_camera), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
