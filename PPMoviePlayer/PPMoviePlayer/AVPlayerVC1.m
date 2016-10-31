//
//  AVPlayerVC1.m
//  PPMoviePlayer
//
//  Created by cdmac on 16/10/26.
//  Copyright © 2016年 chinadailyhk. All rights reserved.
//

#import "AVPlayerVC1.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface AVPlayerVC1 ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerViewController  *playerVC;

@end

@implementation AVPlayerVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    //1.AVPlayerViewController 官方播放器
    [self loadAVPlayerViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadAVPlayerViewController{
    
    // 加载本地音乐
    //    NSURL *movieUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"music1" ofType:@"mp3"]];
    
    // 加载本地视频
    //    NSURL *movieUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video1" ofType:@"mp4"]];
    
    // 加载网络视频
    NSURL *movieUrl = [NSURL URLWithString:@"http://w2.dwstatic.com/1/5/1525/127352-100-1434554639.mp4"];
    
    // 创建播放控制器
    self.player = [AVPlayer playerWithURL:movieUrl];
    self.playerVC = [[AVPlayerViewController alloc] init];
    self.playerVC.player = self.player;
    
    //给AVPlayer一个播放的layer层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = CGRectMake(0, 64, self.view.frame.size.width, 200);
    
    layer.backgroundColor = [UIColor blackColor].CGColor;
    
    //[self.view.layer addSublayer:layer];
    // 1.弹出播放页面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:self.playerVC animated:YES completion:^{
                    // 开始播放
                    [self.playerVC.player play];
                }];
            
        });
}

- (IBAction)playMovie:(id)sender {
    // 2.弹出播放页面
    [self presentViewController:self.playerVC animated:YES completion:^{
        // 开始播放
        [self.playerVC.player play];
    }];
}

@end
