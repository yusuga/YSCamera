//
//  YSCamera.h
//  YSCameraExample
//
//  Created by Yu Sugawara on 2015/12/18.
//  Copyright © 2015年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSCamera;

typedef void (^YSCameraConfiguration)(UIImagePickerController *imagePickerController);
typedef void (^YSCameraDidSaveCompletion)(NSDictionary *savedMediaInfo);

@protocol YSCameraDelegate <NSObject>

- (void)camera:(YSCamera *)camera didFinishPickingImage:(UIImage *)image mediaInfo:(NSDictionary<NSString *,id> *)mediaInfo completion:(void (^)(void))completion;
- (void)camera:(YSCamera *)camera didFinishPickingVideoURL:(NSURL *)videoURL mediaInfo:(NSDictionary<NSString *,id> *)mediaInfo completion:(void (^)(void))completion;

@end

@interface YSCamera : NSObject

+ (void)presentCameraFromViewController:(UIViewController *)parentVC
                    videoCaptureAllowed:(BOOL)videoCaptureAllowed
                          configuration:(YSCameraConfiguration)configuration
                      didSaveCompletion:(YSCameraDidSaveCompletion)didSaveCompletion;

+ (void)presentCameraFromViewController:(UIViewController *)parentVC
                    videoCaptureAllowed:(BOOL)videoCaptureAllowed
                          configuration:(YSCameraConfiguration)configuration
                               delegate:(id<YSCameraDelegate>)delegate;
@property (nonatomic, weak, readonly) id<YSCameraDelegate> delegate;

+ (BOOL)isAvailable;

@end
