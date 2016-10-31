//
//  AVPlayerVC2.m
//  PPMoviePlayer
//
//  Created by cdmac on 16/10/26.
//  Copyright © 2016年 chinadailyhk. All rights reserved.
//

#import "AVPlayerVC2.h"
#import "PPMoviePlayerView.h"

#define IOS9Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@interface AVPlayerVC2 ()<PPMoviePlayerViewDelegate>

@property (nonatomic,strong) PPMoviePlayerView *moviePlayer;
@property (nonatomic,assign) BOOL isLandscape;

@end

@implementation AVPlayerVC2

- (PPMoviePlayerView *)moviePlayer{
    if(!_moviePlayer){
        _moviePlayer = [[PPMoviePlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/1.776)];
        _moviePlayer.delegate = self;
        _moviePlayer.controlStyle = PPMoviePlayerControlStyleNormal;
    }
    
    return _moviePlayer;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (BOOL)prefersStatusBarHidden{
    return YES;
}
#endif

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
 
    [self.view addSubview:self.moviePlayer];
    [self.view bringSubviewToFront:self.moviePlayer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
#endif
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    if(self.moviePlayer){
        [self.moviePlayer stop];
        self.moviePlayer = nil;
    }
}

#pragma mark --屏幕旋转
// 视图控制器旋转到某个尺寸
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    NSLog(@"%f,%f",size.width,size.height);
    if (size.height > size.width)
    {
        NSLog(@"-------当前设备方向是竖屏-------");
        self.moviePlayer.frame = CGRectMake(0, 0, size.width, size.width/1.776);
        self.moviePlayer.fullScreen = NO;
    }
    else
    {
        NSLog(@"-------当前设备方向是横屏-------");
        if(self.moviePlayer.isFullScreen){
            return;
        }
        CGFloat height = [UIScreen mainScreen].bounds.size.width;
        CGFloat width = [UIScreen mainScreen].bounds.size.height;
        
        self.moviePlayer.frame = CGRectMake(0, 0, width, height);
        self.moviePlayer.fullScreen = YES;
    }
}
- (IBAction)playVideo1:(id)sender {
    NSURL *movieUrl = [NSURL URLWithString:@"http://w2.dwstatic.com/1/5/1525/127352-100-1434554639.mp4"];
    self.moviePlayer.videoTitle = @"video title1";
    self.moviePlayer.videoUrl = movieUrl;
    [self.moviePlayer play];
}
- (IBAction)playVideo2:(id)sender {
//    NSURL *movieUrl = [NSURL URLWithString:@"http://w2.dwstatic.com/1/5/1525/127352-100-1434554639.mp4"];
    NSURL *movieUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"cdvideo" ofType:@"mp4"]];
    self.moviePlayer.videoTitle = @"video title2";
    self.moviePlayer.videoUrl = movieUrl;
    [self.moviePlayer play];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - PPMoviePlayerViewDelegate

/**
 播放时间改变
 
 @param view           <#view description#>
 @param currentSencond <#currentSencond description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view timeChanged:(NSTimeInterval)currentSencond{
    NSLog(@"%s",__FUNCTION__);
}


/**
 播放状态改变
 
 @param view   <#view description#>
 @param status <#status description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view playStatusChanged:(PPMoviePlayerStatus)status{
    NSLog(@"%s",__FUNCTION__);
}


/**
 返回按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view backAction:(id)sender{
    NSLog(@"%s",__FUNCTION__);
    
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 投屏按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view toTVAction:(id)sender{
    NSLog(@"%s",__FUNCTION__);
}


/**
 分享按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view shareAction:(id)sender{
    NSLog(@"%s",__FUNCTION__);
}


/**
 收藏按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view favoriteAction:(id)sender{
    NSLog(@"%s",__FUNCTION__);
}


/**
 下载按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view downloadAction:(id)sender{
    NSLog(@"%s",__FUNCTION__);
}


/**
 更多按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view moreAction:(id)sender{
    NSLog(@"%s",__FUNCTION__);
}


/**
 播放暂停按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view playOrPauseAction:(id)sender{
    NSLog(@"%s",__FUNCTION__);
}


/**
 下一个视频按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view nextVideoAction:(id)sender{
    NSLog(@"%s",__FUNCTION__);
}


/**
 播放质量切换按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view qualityAction:(id)sender{
    NSLog(@"%s",__FUNCTION__);
}


/**
 播放列表按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view videoListAction:(id)sender{
    NSLog(@"%s",__FUNCTION__);
}


/**
 全屏/取消全屏点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view fullScreenAction:(id)sender{
    NSLog(@"%s",__FUNCTION__);
}


@end
