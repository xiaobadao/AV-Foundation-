//
//  ViewController.m
//  AV-Vedio
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 Chuckie. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<AVPlayerViewControllerDelegate,AVPictureInPictureControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pipVedioPlayer];
}
- (IBAction)playerBtn:(UIButton *)sender {
    
}

- (void)pipVedioPlayer {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"error = %@",[error description]);
    }
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.allowsPictureInPicturePlayback = YES;
    playerViewController.delegate = self;
    //
    NSURL *urlVideo = [[NSBundle mainBundle] URLForResource:@"张又亓-其实不想说再见" withExtension:@"mp4"];
    AVAsset *asset = [AVAsset assetWithURL:urlVideo];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:^{
        
    }];

}
- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController {
    return YES;
}
- (void)playerViewController:(AVPlayerViewController *)playerViewController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler {
    [self presentViewController:playerViewController animated:YES completion:^{
        completionHandler(YES);
    }];
}
@end
