//
//  ViewController.m
//  AV-PlayerVedio
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 Chuckie. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic,strong)AVPlayer *player;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *durationTime;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.totalTime.textColor = [UIColor redColor];
    self.durationTime.textColor = [UIColor redColor];
    self.playerView.backgroundColor = [UIColor grayColor];
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"error = %@",error.description);
    }
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"张又亓-其实不想说再见" ofType:@"mp4"]]];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    AVPlayerLayer *playerPlayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerPlayer.videoGravity = AVLayerVideoGravityResize;
    playerPlayer.frame = CGRectMake(0, 0,self.playerView.bounds.size.width, self.playerView.bounds.size.height);
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"duration" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    
    [self.playerView.layer addSublayer:playerPlayer];
    [self.playerView.layer addSublayer:self.playBtn.layer];
    [self.playerView.layer addSublayer:self.totalTime.layer];
    [self.playerView.layer addSublayer:self.durationTime.layer];
}

- (IBAction)playAudio:(UIButton *)sender {
    
    switch (self.player.timeControlStatus) {
        case AVPlayerTimeControlStatusPaused:
        {
            [self.player play];
        }
            break;
        case AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate:
        {}
            break;
        case AVPlayerTimeControlStatusPlaying:
        {
            [self.player pause];
        }
            break;
        default:
            break;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    self.totalTime.text = [NSString stringWithFormat:@"%.2f",CMTimeGetSeconds(self.player.currentItem.duration)];
    self.durationTime.text = [NSString stringWithFormat:@"%.2f",CMTimeGetSeconds(self.player.currentTime)];
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                // 开始播放
                [self.player play];
                NSLog(@"加载成功");
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"加载失败");
            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"未知资源");
            }
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
