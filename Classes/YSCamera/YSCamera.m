//
//  YSCamera.m
//  YSCameraExample
//
//  Created by Yu Sugawara on 2015/12/18.
//  Copyright © 2015年 Yu Sugawara. All rights reserved.
//

#import "YSCamera.h"
#import <MRProgress/MRProgress.h>
#import "UIImagePickerController+YSCamera.h"
#import "YSCameraLocalization.h"

@interface YSCamera () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIImagePickerController *imagePickerController;

@property (nonatomic, weak, readwrite) id<YSCameraDelegate> delegate;
@property (nonatomic, copy) YSCameraDidSaveCompletion didSaveCompletion;

@end

@implementation YSCamera

+ (void)presentCameraFromViewController:(UIViewController *)parentVC
                    videoCaptureAllowed:(BOOL)videoCaptureAllowed
                          configuration:(YSCameraConfiguration)configuration
                      didSaveCompletion:(YSCameraDidSaveCompletion)didSaveCompletion
{
    [self presentCameraFromViewController:parentVC
                      videoCaptureAllowed:videoCaptureAllowed
                            configuration:configuration
                        didSaveCompletion:didSaveCompletion
                                 delegate:nil];
}

+ (void)presentCameraFromViewController:(UIViewController *)parentVC
                    videoCaptureAllowed:(BOOL)videoCaptureAllowed
                          configuration:(YSCameraConfiguration)configuration
                               delegate:(id<YSCameraDelegate>)delegate
{
    [self presentCameraFromViewController:parentVC
                      videoCaptureAllowed:videoCaptureAllowed
                            configuration:configuration
                        didSaveCompletion:nil
                                 delegate:delegate];
}

+ (void)presentCameraFromViewController:(UIViewController *)parentVC
                    videoCaptureAllowed:(BOOL)videoCaptureAllowed
                          configuration:(YSCameraConfiguration)configuration
                      didSaveCompletion:(YSCameraDidSaveCompletion)didSaveCompletion
                               delegate:(id<YSCameraDelegate>)delegate
{
    NSParameterAssert([NSThread isMainThread]);
    NSParameterAssert(!(didSaveCompletion && delegate));
    
    if (![self isAvailable]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:YSCameraLocalizedString(@"Camera is not available")
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        
        [parentVC presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    YSCamera *camera = [[YSCamera alloc] init];
    camera.delegate = delegate;
    camera.imagePickerController = picker;
    camera.didSaveCompletion = didSaveCompletion;
    
    [picker ys_setCamera:camera];
    
    picker.delegate = camera;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    if (videoCaptureAllowed) {
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    if (configuration) configuration(picker);
    
    [parentVC presentViewController:picker animated:YES completion:nil];
}

+ (BOOL)isAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    void (^showHUD)() = ^{
        [MRProgressOverlayView showOverlayAddedTo:picker.view
                                            title:YSCameraLocalizedString(@"Saving…")
                                             mode:MRProgressOverlayViewModeIndeterminateSmall
                                         animated:YES];
        
    };
    void (^dismissHUD)() = ^{
        [MRProgressOverlayView dismissOverlayForView:picker.view
                                            animated:YES];
    };
    
    UIImage *image = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    if (image) {
        showHUD();
        
        if (self.delegate) {
            __weak typeof(self) wself = self;
            [self.delegate camera:self didFinishPickingImage:image mediaInfo:info completion:^{
                dismissHUD();
                [wself dismiss];
            }];
            return;
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge_retained void * _Nullable)info);
        return;
    }
    
    NSURL *URL = info[UIImagePickerControllerMediaURL];
    if (URL) {
        showHUD();
        
        if (self.delegate) {
            __weak typeof(self) wself = self;
            [self.delegate camera:self didFinishPickingVideoURL:URL mediaInfo:info completion:^{
                dismissHUD();
                [wself dismiss];
            }];
            return;
        }
        
        UISaveVideoAtPathToSavedPhotosAlbum(URL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), (__bridge_retained void * _Nullable)(info));
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:YSCameraLocalizedString(@"Unknown error")
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) wself = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [wself dismiss];
                                            }]];
    
    [self.imagePickerController presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismiss];
}

#pragma mark - Image

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self mediaDidFinishSavingWithError:error mediaInfo:(__bridge NSDictionary<NSString *,id> *)(contextInfo)];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self mediaDidFinishSavingWithError:error mediaInfo:(__bridge NSDictionary<NSString *,id> *)(contextInfo)];
}

- (void)mediaDidFinishSavingWithError:(NSError *)error mediaInfo:(NSDictionary<NSString *, id> *)info
{
    [MRProgressOverlayView dismissOverlayForView:self.imagePickerController.view
                                        animated:YES];
    
    if (error) {
        NSLog(@"%s, error: %@, info: %@", __func__, error, info);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:error.localizedDescription
                                                                       message:error.localizedFailureReason ?: error.localizedRecoverySuggestion
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof(self) wself = self;
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [wself dismiss];
                                                }]];
        
        [self.imagePickerController presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (self.didSaveCompletion) self.didSaveCompletion(info);
    [self dismiss];
}

- (void)dismiss
{
    UIImagePickerController *picker = self.imagePickerController;
    [picker ys_setCamera:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
