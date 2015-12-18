//
//  YSCamera.h
//  YSCameraExample
//
//  Created by Yu Sugawara on 2015/12/18.
//  Copyright © 2015年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YSCameraConfiguration)(UIImagePickerController *imagePickerController);
typedef void (^YSCameraDidSaveCompletion)(NSDictionary *savedMediaInfo);

@interface YSCamera : NSObject

+ (void)presentCameraFromViewController:(UIViewController *)parentVC
                    videoCaptureAllowed:(BOOL)videoCaptureAllowed
                          configuration:(YSCameraConfiguration)configuration
                      didSaveCompletion:(YSCameraDidSaveCompletion)didSaveCompletion;

+ (BOOL)isAvailable;

@end
