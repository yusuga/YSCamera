//
//  TableViewController.m
//  YSCameraExample
//
//  Created by Yu Sugawara on 2015/12/18.
//  Copyright © 2015年 Yu Sugawara. All rights reserved.
//

#import "TableViewController.h"
#import "YSCamera.h"

@interface TableViewController () <YSCameraDelegate>

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSCameraDidSaveCompletion completion = ^(NSDictionary *savedMediaInfo) {
        NSLog(@"savedMediaInfo: %@", savedMediaInfo);
    };
    
    switch (indexPath.row) {
        case 0:
            [YSCamera presentCameraFromViewController:self
                                  videoCaptureAllowed:NO
                                        configuration:nil
                                    didSaveCompletion:completion];
            break;
        case 1:
            [YSCamera presentCameraFromViewController:self
                                  videoCaptureAllowed:YES
                                        configuration:nil
                                    didSaveCompletion:completion];
            break;
        case 2:
            [YSCamera presentCameraFromViewController:self
                                  videoCaptureAllowed:YES
                                        configuration:^(UIImagePickerController *imagePickerController) {
                                            imagePickerController.allowsEditing = YES;
                                        } didSaveCompletion:completion];
            break;
        case 3:
            [YSCamera presentCameraFromViewController:self
                                  videoCaptureAllowed:YES
                                        configuration:nil
                                             delegate:self];
            break;
        default:
            NSAssert(false, @"Unsupported");
            break;
    }
}

- (void)camera:(YSCamera *)camera didFinishPickingImage:(UIImage *)image mediaInfo:(NSDictionary<NSString *,id> *)mediaInfo completion:(void (^)(void))completion
{
    NSLog(@"%s, mediaInfo: %@", __func__, mediaInfo);
    completion();
}

- (void)camera:(YSCamera *)camera didFinishPickingVideoURL:(NSURL *)videoURL mediaInfo:(NSDictionary<NSString *,id> *)mediaInfo completion:(void (^)(void))completion
{
    NSLog(@"%s, mediaInfo: %@", __func__, mediaInfo);
    completion();
}

@end
