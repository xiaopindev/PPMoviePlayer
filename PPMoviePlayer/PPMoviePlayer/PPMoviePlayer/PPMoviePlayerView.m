//
//  PPMoviePlayerView.m
//  PPMoviePlayer
//
//  Created by xiaopin on 16/10/27.
//  Copyright © 2016年 PPKit. All rights reserved.
//

#import "PPMoviePlayerView.h"

///监听准备播放状态属性
#define PlayerItemKey_Status @"status"
///监听缓冲进度属性
#define PlayerItemKey_LoadedTimeRanges @"loadedTimeRanges"
///监听播放的区域缓存是否为空
#define PlayerItemKey_PlaybackBufferEmpty @"playbackBufferEmpty"
///缓存可以播放的时候调用
#define PlayerItemKey_PlaybackLikelyToKeepUp @"playbackLikelyToKeepUp"

@interface PPMoviePlayerView ()
{
    CGFloat pX,pY,pWidth,pHeight;
}

//播放器核心
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

//播放器属性
@property (nonatomic,weak) id playTimeObserver;
@property (nonatomic,assign) CMTime currentTime;
@property (nonatomic,assign) CMTime duration;

@property (nonatomic,assign) BOOL controlHidden;
@property (nonatomic,strong) NSTimer *controlTimer;

@property (nonatomic,assign) BOOL isSliding;

//顶部视频信息视图
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *btnBack;
@property (nonatomic,strong) UILabel *labTitle;
@property (nonatomic,strong) UIButton *btnToTV;
@property (nonatomic,strong) UIButton *btnShare;
@property (nonatomic,strong) UIButton *btnFavorite;
@property (nonatomic,strong) UIButton *btnDownload;
@property (nonatomic,strong) UIButton *btnMore;

//结束后中间显示的重播按钮
@property (nonatomic,strong) UIButton *btnReplay;
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) UIImageView *alertImageView;
@property (nonatomic,strong) UILabel *alertLabel;

//底部控制视图
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *btnPlayOrPause;
@property (nonatomic,strong) UIButton *btnNextVideo;
@property (nonatomic,strong) UILabel *labStartTime;
@property (nonatomic,strong) UISlider *playProgress;
@property (nonatomic,strong) UIProgressView *loadedProgress;
@property (nonatomic,strong) UILabel *labEndTime;
@property (nonatomic,strong) UIButton *btnQuality;
@property (nonatomic,strong) UIButton *btnVideoList;
@property (nonatomic,strong) UIButton *btnFullScreen;

@end

@implementation PPMoviePlayerView

#pragma mark - 懒加载

#pragma mark - ---头
-(UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
        _topView.backgroundColor = [UIColor colorWithRed:70/255 green:70/255 blue:70/255 alpha:0.8];
        _topView.alpha = 0;
    }
    return _topView;
}

-(UIButton *)btnBack{
    if(!_btnBack){
        _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnBack.frame = CGRectMake(10, 5, 30, 30);
        [_btnBack setImage:[UIImage imageNamed:@"PPKit_vp_back"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}

-(UILabel *)labTitle{
    if(!_labTitle){
        _labTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _labTitle.textColor = [UIColor whiteColor];
        _labTitle.textAlignment = NSTextAlignmentLeft;
        _labTitle.font = [UIFont systemFontOfSize:15];
    }
    return _labTitle;
}

-(UIButton *)btnToTV{
    if(!_btnToTV){
        _btnToTV = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnToTV.frame = CGRectMake(0, 5, 30, 30);
        [_btnToTV setImage:[UIImage imageNamed:@"PPKit_vp_toTV"] forState:UIControlStateNormal];
        [_btnToTV addTarget:self action:@selector(toTVAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnToTV;
}

-(UIButton *)btnShare{
    if(!_btnShare){
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnShare.frame = CGRectMake(0, 5, 30, 30);
        [_btnShare setImage:[UIImage imageNamed:@"PPKit_vp_share"] forState:UIControlStateNormal];
        [_btnShare addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnShare;
}

-(UIButton *)btnFavorite{
    if(!_btnFavorite){
        _btnFavorite = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnFavorite.frame = CGRectMake(0, 5, 30, 30);
        [_btnFavorite setImage:[UIImage imageNamed:@"PPKit_vp_favorite"] forState:UIControlStateNormal];
        [_btnFavorite addTarget:self action:@selector(favoriteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFavorite;
}

-(UIButton *)btnDownload{
    if(!_btnDownload){
        _btnDownload = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDownload.frame = CGRectMake(0, 5, 30, 30);
        [_btnDownload setImage:[UIImage imageNamed:@"PPKit_vp_download"] forState:UIControlStateNormal];
        [_btnDownload addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDownload;
}

-(UIButton *)btnMore{
    if(!_btnMore){
        pX = self.bounds.size.width - 30 - 5;
        _btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMore.frame = CGRectMake(pX, 5, 30, 30);
        [_btnMore setImage:[UIImage imageNamed:@"PPKit_vp_more"] forState:UIControlStateNormal];
        [_btnMore addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMore;
}

#pragma mark - ---中
-(UIButton *)btnReplay{
    if(!_btnReplay){
        pX = (self.bounds.size.width - 50)/2;
        pY = (self.bounds.size.height - 50)/2;
        _btnReplay = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnReplay.frame = CGRectMake(pX, pY, 50, 50);
        [_btnReplay setImage:[UIImage imageNamed:@"PPKit_vp_play2"] forState:UIControlStateNormal];
        [_btnReplay addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnReplay;
}

- (UIView *)alertView{
    if(!_alertView){
        pY = (self.bounds.size.height - 70)/2;
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, pY, self.bounds.size.width, 70)];
        [_alertView addSubview:self.alertImageView];
        [_alertView addSubview:self.alertLabel];
    }
    return _alertView;
}

- (UIImageView *)alertImageView{
    if(!_alertImageView){
        pX = (self.alertView.frame.size.width - 50)/2;
        _alertImageView = [[UIImageView alloc] initWithFrame:CGRectMake(pX, 0, 50, 50)];
        _alertImageView.image = [UIImage imageNamed:@"PPKit_vp_logo"];
        _alertImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _alertImageView;
}

- (UILabel *)alertLabel{
    if(!_alertLabel){
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.alertView.frame.size.width, 20)];
        _alertLabel.textColor = [UIColor lightGrayColor];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.font = [UIFont systemFontOfSize:10];
    }
    return _alertLabel;
}

#pragma mark - ---尾
-(UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-40, self.bounds.size.width, 40)];
        _bottomView.backgroundColor = [UIColor colorWithRed:70/255 green:70/255 blue:70/255 alpha:0.8];
        _bottomView.alpha = 0;
    }
    return _bottomView;
}

-(UIButton *)btnPlayOrPause{
    if(!_btnPlayOrPause){
        _btnPlayOrPause = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlayOrPause.frame = CGRectMake(5, 5, 30, 30);
        [_btnPlayOrPause setImage:[UIImage imageNamed:@"PPKit_vp_play"] forState:UIControlStateNormal];
        [_btnPlayOrPause addTarget:self action:@selector(playOrPauseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPlayOrPause;
}

-(UIButton *)btnNextVideo{
    if(!_btnNextVideo){
        _btnNextVideo = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNextVideo.frame = CGRectMake(0, 5, 30, 30);
        [_btnNextVideo setImage:[UIImage imageNamed:@"PPKit_vp_next"] forState:UIControlStateNormal];
        [_btnNextVideo addTarget:self action:@selector(nextVideoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNextVideo;
}

-(UILabel *)labStartTime{
    if(!_labStartTime){
        _labStartTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 40, 30)];
        _labStartTime.textAlignment = NSTextAlignmentCenter;
        _labStartTime.textColor = [UIColor whiteColor];
        _labStartTime.font = [UIFont systemFontOfSize:12];
        _labStartTime.text = @"00:00";
    }
    return _labStartTime;
}

-(UISlider *)playProgress{
    if(!_playProgress){
        _playProgress = [[UISlider alloc] initWithFrame:CGRectMake(0, 5, 0, 30)];
        _playProgress.value = 0.0;
        _playProgress.maximumTrackTintColor = [UIColor clearColor];
        //设置播放进度颜色
        //_playProgress.minimumTrackTintColor = [UIColor orangeColor];
        [_playProgress setThumbImage:[UIImage imageNamed:@"PPKit_vp_slider"] forState:UIControlStateNormal];
        
        [_playProgress addTarget:self action:@selector(playerSliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_playProgress addTarget:self action:@selector(playerSliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_playProgress addTarget:self action:@selector(playerSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _playProgress;
}

- (UIProgressView *)loadedProgress{
    if(!_loadedProgress){
        _loadedProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 5, 0, 30)];
        //_loadedProgress.progress = 0.5;
        //设置已经缓存进度
        _loadedProgress.progressTintColor = [UIColor orangeColor];
    }
    return _loadedProgress;
}

-(UILabel *)labEndTime{
    if(!_labEndTime){
        _labEndTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 40, 30)];
        _labEndTime.textAlignment = NSTextAlignmentCenter;
        _labEndTime.textColor = [UIColor whiteColor];
        _labEndTime.font = [UIFont systemFontOfSize:12];
        _labEndTime.text = @"00:00";
    }
    return _labEndTime;
}

-(UIButton *)btnQuality{
    if(!_btnQuality){
        _btnQuality = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnQuality.frame = CGRectMake(0, 5, 50, 30);
        _btnQuality.backgroundColor = [UIColor grayColor];
        _btnQuality.titleLabel.font = [UIFont systemFontOfSize:12];
        [_btnQuality setTitle:@"标准" forState:UIControlStateNormal];
        [_btnQuality setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnQuality addTarget:self action:@selector(qualityAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnQuality;
}

-(UIButton *)btnVideoList{
    if(!_btnVideoList){
        _btnVideoList = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnVideoList.frame = CGRectMake(0, 5, 50, 30);
        [_btnVideoList setImage:[UIImage imageNamed:@"PPKit_vp_list"] forState:UIControlStateNormal];
        [_btnVideoList addTarget:self action:@selector(videoListAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnVideoList;
}

-(UIButton *)btnFullScreen{
    if(!_btnFullScreen){
        _btnFullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnFullScreen.frame = CGRectMake(0, 5, 30, 30);
        [_btnFullScreen setImage:[UIImage imageNamed:@"PPKit_vp_fullscreen"] forState:UIControlStateNormal];
        [_btnFullScreen addTarget:self action:@selector(fullScreenAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFullScreen;
}

#pragma mark - 重载方法

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        //初始化默认属性
        self.backgroundColor = [UIColor blackColor];
        
        _controlHidden = YES;
        _status = PPMoviePlayerStatusUnknown;
        _controlStyle = PPMoviePlayerControlStyleNone;
    }
    return self;
}

//设置标题
-(void)setVideoTitle:(NSString *)videoTitle{
    _videoTitle = videoTitle;
    
    self.labTitle.text = videoTitle;
}

//设置视频播放URL
-(void)setVideoUrl:(NSURL *)videoUrl{
    _videoUrl = videoUrl;
    
    //1.移除监听
    [self removeNotifyObservers];
    
    //2.初始化播放器
    [self initAVPlayerWithUrl:videoUrl];
    
    //3.添加监听
    [self addNotifyObservers];

}

//设置全屏
-(void)setFullScreen:(BOOL)fullScreen{
    _fullScreen = fullScreen;
    
    //1.改变播放界面的尺寸
    self.playerLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    //2.设置重播按钮垂直居中
    if(_btnReplay){
        pX = (self.bounds.size.width - 50)/2;
        pY = (self.bounds.size.height - 50)/2;
        self.btnReplay.frame = CGRectMake(pX, pY, 50, 50);
    }
    
    //3.把提示信息居中
    if(_alertView){
        pY = (self.bounds.size.height - 70)/2;
        _alertView.frame = CGRectMake(0, pY, self.bounds.size.width, 70);
        
        pX = (_alertView.frame.size.width - 50)/2;
        _alertImageView.frame = CGRectMake(pX, 0, 50, 50);
        
        _alertLabel.frame = CGRectMake(0, 50, _alertView.frame.size.width, 20);
    }
    
    //4.重置控制控件布局
    self.topView.frame = CGRectMake(0, 0, self.bounds.size.width, 40);
    self.bottomView.frame = CGRectMake(0, self.bounds.size.height-40, self.bounds.size.width, 40);
    
    //5.设置样式
    if(fullScreen){
        self.controlStyle = PPMoviePlayerControlStyleFullScreen;
    }else{
        self.controlStyle = PPMoviePlayerControlStyleNormal;
    }
}

//设置控制控件样式
-(void)setControlStyle:(PPMoviePlayerControlStyle)controlStyle{
    _controlStyle = controlStyle;
    
    NSLog(@"%s",__FUNCTION__);

    //1.先移除控件
    [self.topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.topView removeFromSuperview];
    
    [self.bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.bottomView removeFromSuperview];
    
    //2.根据样式，重新设置控件布局
    if(self.status == PPMoviePlayerStatusPause || self.status == PPMoviePlayerStatusStop){
        [self addSubview:self.btnReplay];
    }else{
        [self.btnReplay removeFromSuperview];
    }
    
    if(controlStyle == PPMoviePlayerControlStyleNormal){
        //正常布局
        if(!self.showTopBarOnlyFullScreen){
            //如果不是全屏就不显示
            pX = self.btnBack.frame.origin.x + self.btnBack.frame.size.width + 5;
            pWidth = self.bounds.size.width - pX - (self.bounds.size.width - self.btnMore.frame.origin.x);
            self.labTitle.frame = CGRectMake(pX, 5, pWidth, 30);
            
            [self.topView addSubview:self.btnBack];
            [self.topView addSubview:self.labTitle];
            [self.topView addSubview:self.btnMore];
            [self addSubview:self.topView];
        }
    
        CGFloat tmpX;
        pX = self.btnPlayOrPause.frame.origin.x + self.btnPlayOrPause.frame.size.width + 5;
        self.labStartTime.frame = CGRectMake(pX, 5, 40, 30);
        pWidth = pX + 40 + 3;
        tmpX = pWidth;
        pX = self.bounds.size.width - 40 - 3;
        self.labEndTime.frame = CGRectMake(pX, 5, 40, 30);
    
        //算出进度条的动态宽
        pWidth = pX - pWidth;
        self.playProgress.frame = CGRectMake(tmpX, 10, pWidth, 20);
        self.loadedProgress.frame = CGRectMake(tmpX+2, 19, pWidth-4, 20);
        
        [self.bottomView addSubview:self.btnPlayOrPause];
        [self.bottomView addSubview:self.labStartTime];
        [self.bottomView addSubview:self.loadedProgress];
        [self.bottomView addSubview:self.playProgress];
        [self.bottomView addSubview:self.labEndTime];
        [self addSubview:self.bottomView];
        
    } else if (controlStyle == PPMoviePlayerControlStyleFullScreen){
        //全屏布局
        
        //TopBar布局
        pX = self.bounds.size.width - (30*1) - (5*1) - 5;
        self.btnDownload.frame = CGRectMake(pX, 5, 30, 30);
        pX = self.bounds.size.width - (30*2) - (5*2) - 5;
        self.btnFavorite.frame = CGRectMake(pX, 5, 30, 30);
        pX = self.bounds.size.width - (30*3) - (5*3) - 5;
        self.btnShare.frame = CGRectMake(pX, 5, 30, 30);
        pX = self.bounds.size.width - (30*4) - (5*4) - 5;
        self.btnToTV.frame = CGRectMake(pX, 5, 30, 30);
        
        pWidth = pX -5;
        pX = self.btnBack.frame.origin.x + self.btnBack.frame.size.width + 5;
        pWidth = pWidth - pX;
        self.labTitle.frame = CGRectMake(pX, 5, pWidth, 30);
        
        [self.topView addSubview:self.btnBack];
        [self.topView addSubview:self.labTitle];
        [self.topView addSubview:self.btnToTV];
        [self.topView addSubview:self.btnShare];
        [self.topView addSubview:self.btnFavorite];
        [self.topView addSubview:self.btnDownload];
        [self addSubview:self.topView];
        
        //BottomBar布局
        CGFloat tmpX;
        pX = self.btnPlayOrPause.frame.origin.x + self.btnPlayOrPause.frame.size.width + 5;
        self.btnNextVideo.frame = CGRectMake(pX, 5, 30, 30);
        pX = self.btnNextVideo.frame.origin.x + self.btnNextVideo.frame.size.width + 5;
        self.labStartTime.frame = CGRectMake(pX, 5, 40, 30);
        pWidth = pX + 40 + 3;
        tmpX = pWidth;
        
        pX = self.bounds.size.width - 30 - 5;
        self.btnFullScreen.frame = CGRectMake(pX, 5, 30, 30);
        pX = pX - 40 - 5;
        self.btnVideoList.frame = CGRectMake(pX, 5, 40, 30);
        pX = pX - 40 - 5;
        self.btnQuality.frame = CGRectMake(pX, 5, 40, 30);
        pX = pX - 40 - 3;
        self.labEndTime.frame = CGRectMake(pX, 5, 40, 30);
        
        //算出进度条的动态宽
        pWidth = pX - pWidth;
        self.playProgress.frame = CGRectMake(tmpX, 10, pWidth, 20);
        self.loadedProgress.frame = CGRectMake(tmpX+2, 19, pWidth-4, 20);
        
        [self.bottomView addSubview:self.btnPlayOrPause];
        [self.bottomView addSubview:self.btnNextVideo];
        [self.bottomView addSubview:self.labStartTime];
        [self.bottomView addSubview:self.loadedProgress];
        [self.bottomView addSubview:self.playProgress];
        [self.bottomView addSubview:self.labEndTime];
        [self.bottomView addSubview:self.btnQuality];
        [self.bottomView addSubview:self.btnVideoList];
        [self.bottomView addSubview:self.btnFullScreen];
        
        [self addSubview:self.bottomView];
    }
    
//    self.labStartTime.backgroundColor = [UIColor redColor];
//    self.labEndTime.backgroundColor = [UIColor redColor];
//    self.btnFullScreen.backgroundColor = [UIColor redColor];
//    self.btnVideoList.backgroundColor = [UIColor greenColor];
//    self.btnQuality.backgroundColor = [UIColor blueColor];
//    
//    self.btnPlayOrPause.backgroundColor = [UIColor redColor];
//    self.btnNextVideo.backgroundColor = [UIColor greenColor];
//    
//    self.btnToTV.backgroundColor = [UIColor redColor];
//    self.btnShare.backgroundColor = [UIColor greenColor];
//    self.btnFavorite.backgroundColor = [UIColor blueColor];
//    self.btnDownload.backgroundColor = [UIColor redColor];
//    
//    self.labTitle.backgroundColor = [UIColor orangeColor];
//    
//    self.btnBack.backgroundColor =[UIColor redColor];
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    [self removeNotifyObservers];
    
    [self clearControlTimer];
}

#pragma mark - 自定义方法

/**
 初始化播放器
 */
- (void)initAVPlayerWithUrl:(NSURL*)videoUrl{
    NSLog(@"%s",__FUNCTION__);
    
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    
    // 创建 AVPlayer 播放器
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    // 将 AVPlayer 添加到 AVPlayerLayer 上
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    // 设置播放页面大小
    self.playerLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    // 设置画面缩放模式
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // 在视图上添加播放器
    [self.layer addSublayer:self.playerLayer];
    
    //其他设置：
    // 设置音量
    /*
     范围 0 - 1，默认为 1
     */
    //self.player.volume = 0;
    
    // 跳转到指定位置
    /*
     10 / 1 = 10，跳转到第 10 秒的位置处
     CMTimeMake(10, 1) 参数1：分子，参数二：分母， 数学里的分数
     */
    //[self.playerItem seekToTime:CMTimeMake(10, 1)];
    
    // 设置播放速率
    /*
     默认为 1.0 (normal speed)，设为 0.0 时暂停播放。设置后立即开始播放，可放在开始播放后设置
     */
    //self.player.rate = 1.0;
    
    // 获取当前播放速率
    //float rate = self.player.rate;
}

//播放
- (void)play{
    if(self.player && self.videoUrl){
        //显示加载中
        [self showLoading];
        
        //30秒后检测是否播放状态
        [self performSelector:@selector(checkPlayerStatus) withObject:nil afterDelay:30];
        
        //播放
        [self.player play];
        
        //设置正在播放
        _status = PPMoviePlayerStatusPlaying;
        
        //移除重播视图
        [self.btnReplay setImage:[UIImage imageNamed:@"PPKit_vp_play2"] forState:UIControlStateNormal];
        [self.btnReplay removeFromSuperview];
        
        //设置播放按钮状态
        [self.btnPlayOrPause setImage:[UIImage imageNamed:@"PPKit_vp_pause"] forState:UIControlStateNormal];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:playStatusChanged:)]){
            [self.delegate PPMoviePlayerView:self playStatusChanged:PPMoviePlayerStatusPlaying];
        }
    }
}

//从指定时间点播放
- (void)playWithTimeInterval:(NSTimeInterval)timeInterval{
    
    if(self.player && self.videoUrl){
        //跳转到指定的时间点播放
        [self.player seekToTime:CMTimeMake(timeInterval, 1) completionHandler:^(BOOL finished) {
            
            //移除播放按钮
            [self.btnReplay setImage:[UIImage imageNamed:@"PPKit_vp_play2"] forState:UIControlStateNormal];
            [self.btnReplay removeFromSuperview];
        }];
    }
}

//暂停
- (void)pause{
    if(self.player && self.videoUrl){
        [self.player pause];
        _status = PPMoviePlayerStatusPause;
        
        [self addSubview:self.btnReplay];
        
        //设置播放按钮状态
        [self.btnPlayOrPause setImage:[UIImage imageNamed:@"PPKit_vp_play"] forState:UIControlStateNormal];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:playStatusChanged:)]){
            [self.delegate PPMoviePlayerView:self playStatusChanged:PPMoviePlayerStatusPause];
        }
    }
}

- (void)stop{
    [self removeNotifyObservers];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:playStatusChanged:)]){
        [self.delegate PPMoviePlayerView:self playStatusChanged:PPMoviePlayerStatusStop];
    }
}

//检测播放状态
- (void)checkPlayerStatus{
    if(_status == PPMoviePlayerStatusUnknown){
        [self networkFaild];
    }
}

//显示视频加载中...
- (void)showLoading{
    [self hideAlertView];
    [self addSubview:self.alertView];
    NSMutableArray *loadingImages = [NSMutableArray array];
    for (int i = 0; i<=8; i++) {
        [loadingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"PPKit_vp_loading_%d",i]]];
    }
    self.alertImageView.animationImages = loadingImages;
    self.alertImageView.animationDuration = 2.0f;
    self.alertImageView.animationRepeatCount = 0;
    self.alertLabel.text = @"视频加载中";
    
    [self.alertImageView startAnimating];
}

//网络连接失败
- (void)networkFaild{
    [self hideAlertView];
    [self addSubview:self.alertView];
    self.alertImageView.image = [UIImage imageNamed:@"PPKit_vp_netfailed"];
    self.alertLabel.text = @"网络连接失败，请重试！";
}

//网络失速
- (void)networkStalled{
    [self hideAlertView];
    [self addSubview:self.alertView];
    self.alertImageView.image = [UIImage imageNamed:@"PPKit_vp_netstalled"];
    self.alertLabel.text = @"网络不太好，请稍候...";
}

//隐藏提示视图
- (void)hideAlertView{
    if(_alertLabel){
        [self.alertLabel removeFromSuperview];
        self.alertLabel = nil;
    }
    
    if(_alertImageView){
        [self.alertImageView removeFromSuperview];
        if(self.alertImageView.isAnimating){
            [self.alertImageView stopAnimating];
        }
        self.alertImageView = nil;
    }
    
    if(_alertView){
        [self.alertView removeFromSuperview];
        self.alertView = nil;
    }
}

//开启控制视图消失定时器
- (void)startControlTimer{
    [self clearControlTimer];
    
    __weak typeof(self) weakSelf = self;
    self.controlTimer = [NSTimer scheduledTimerWithTimeInterval:12.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
        //隐藏控制视图
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.topView.alpha = 0;
            weakSelf.bottomView.alpha = 0;
        }];
        
        //销毁定时器
        [weakSelf clearControlTimer];
    }];
}

//清楚销毁定时器资源
- (void)clearControlTimer{
    if (self.controlTimer) {
        [self.controlTimer invalidate];
        self.controlTimer = nil;
    }
}

- (NSString *)convertTime:(CGFloat)second {
    // 相对格林时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (second / 3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    
    NSString *showTimeNew = [formatter stringFromDate:date];
    return showTimeNew;
}

#pragma mark - 触摸事件
//1.单点弹出控件视图
- (void)singleTap{
    NSLog(@"%s",__FUNCTION__);
    self.controlHidden = !self.controlHidden;
    __weak typeof(self) weakSelf = self;
    
    if(self.controlHidden){
        //隐藏控制视图
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.topView.alpha = 0;
            weakSelf.bottomView.alpha = 0;
        }];
        
        //销毁定时器
        [self clearControlTimer];
    }else{
        //显示控制视图
        
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf bringSubviewToFront:weakSelf.topView];
            [weakSelf bringSubviewToFront:weakSelf.bottomView];
            weakSelf.topView.alpha = 1;
            weakSelf.bottomView.alpha = 1;
        }];
        
        //开启定时器
        [self startControlTimer];
    }
}

//2.双点暂停
- (void)doubleTap{
    NSLog(@"%s",__FUNCTION__);
    [self pause];
}

//3.左边上下滑动调亮度
//4.右边上下滑动调音量
//5.左右滑动调播放进度
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__FUNCTION__);
    if(self.player){
        if(self.player.status == AVPlayerStatusUnknown){
            NSLog(@"播放未知状态");
        }else if (self.player.status == AVPlayerStatusFailed){
            NSLog(@"播放失败");
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__FUNCTION__);
    UITouch *touch = [touches anyObject];
    
    if([touch view] == self.topView || [touch view] == self.bottomView){
        [self startControlTimer];
    }else{
        if(touch.tapCount == 1){
            [self performSelector:@selector(singleTap) withObject:nil afterDelay:0.3];
        }else if (touch.tapCount == 2){
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
            [self performSelector:@selector(doubleTap) withObject:nil afterDelay:0.3];
        }
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__FUNCTION__);
    UITouch *touch=[touches anyObject];
    //NSLog(@"%@",touch);
    
    //取得当前位置
    CGPoint current=[touch locationInView:self];
    //取得前一个位置
    CGPoint previous=[touch previousLocationInView:self];
    
    NSLog(@"移动前：%@",NSStringFromCGPoint(previous));
    NSLog(@"移动后：%@",NSStringFromCGPoint(current));
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - 按钮事件
//返回点击
- (void)backAction{

    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:backAction:)]){
        [self.delegate PPMoviePlayerView:self backAction:nil];
    }
}

//投屏点击
- (void)toTVAction{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:toTVAction:)]){
        [self.delegate PPMoviePlayerView:self toTVAction:nil];
    }
}

//分享点击
- (void)shareAction{

    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:shareAction:)]){
        [self.delegate PPMoviePlayerView:self shareAction:nil];
    }
}

//收藏点击
- (void)favoriteAction{

    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:favoriteAction:)]){
        [self.delegate PPMoviePlayerView:self favoriteAction:nil];
    }
}

//下载点击
- (void)downloadAction{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:downloadAction:)]){
        [self.delegate PPMoviePlayerView:self downloadAction:nil];
    }
}

//更多点击
- (void)moreAction{

    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:moreAction:)]){
        [self.delegate PPMoviePlayerView:self moreAction:nil];
    }
}

//暂停或播放点击
- (void)playOrPauseAction{
    if(self.status == PPMoviePlayerStatusPlaying){
        [self pause];
    }else{
        [self play];
    }

    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:playOrPauseAction:)]){
        [self.delegate PPMoviePlayerView:self playOrPauseAction:nil];
    }
}

//下一个视频点击
- (void)nextVideoAction{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:nextVideoAction:)]){
        [self.delegate PPMoviePlayerView:self nextVideoAction:nil];
    }
}

//清晰度切换点击
- (void)qualityAction{
 
    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:qualityAction:)]){
        [self.delegate PPMoviePlayerView:self qualityAction:nil];
    }
}

//视频列表点击
- (void)videoListAction{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:videoListAction:)]){
        [self.delegate PPMoviePlayerView:self videoListAction:nil];
    }
}

//全屏点击
- (void)fullScreenAction{

    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:fullScreenAction:)]){
        [self.delegate PPMoviePlayerView:self fullScreenAction:nil];
    }
}

#pragma mark - Slider事件
- (void)playerSliderTouchDown:(id)sender {
    [self pause];
}

- (void)playerSliderTouchUpInside:(id)sender {
    _isSliding = NO; // 滑动结束
    [self play];
}

- (void)playerSliderValueChanged:(id)sender {
    _isSliding = YES;
    
    [self pause];
    
    CMTime changedTime = CMTimeMakeWithSeconds(self.playProgress.value, 1.0);
    [self.playerItem seekToTime:changedTime completionHandler:^(BOOL finished) {
        // 跳转完成后做某事
    }];
}

#pragma mark - 监听事件

- (void)removeNotifyObservers{
    NSLog(@"%s",__FUNCTION__);
    
    if(self.player){
        [self.player replaceCurrentItemWithPlayerItem:nil];
    }
    
    if (self.playerItem){
        [self.playerItem removeObserver:self forKeyPath:PlayerItemKey_Status];
        [self.playerItem removeObserver:self forKeyPath:PlayerItemKey_LoadedTimeRanges];
        [self.playerItem removeObserver:self forKeyPath:PlayerItemKey_PlaybackBufferEmpty];
        [self.playerItem removeObserver:self forKeyPath:PlayerItemKey_PlaybackLikelyToKeepUp];
        self.playerItem = nil;
    }
    
    if (self.playTimeObserver) {
        [self.player removeTimeObserver:self.playTimeObserver];
        self.playTimeObserver = nil;
    }
    
    if (self.player) {
        [self.player pause];
        [self.playerLayer removeFromSuperlayer];
        self.playerLayer = nil;
        self.player = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotifyObservers{
    NSLog(@"%s",__FUNCTION__);

    // 监听播放进度
    /*
     NULL 在主线程中执行，每个一秒执行一次该 Block
     */
    __weak typeof(self) weakSelf = self;
    self.playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        
        //设置状态
        _status = PPMoviePlayerStatusPlaying;
        [weakSelf hideAlertView];
        
        // 获取当前播放进度
        /*
         或用 avPlayerItem.currentTime.value/avPlayerItem.currentTime.timescale;
         */
        CMTime currentTime = weakSelf.playerItem.currentTime;
        float currentSecond = CMTimeGetSeconds(currentTime);
        
        // 获取视频总长度
        /*
         转换成秒，或用 duration.value / duration.timescale; 计算
         */
        CMTime duration = weakSelf.playerItem.duration;
        float totalSecond = CMTimeGetSeconds(duration);
        
        //NSLog(@"当前播放进度：%f/%f",currentSecond,totalSecond);
        
        // 更新slider, 如果正在滑动则不更新
        if (_isSliding == NO) {
            weakSelf.playProgress.value = currentSecond;
            weakSelf.labStartTime.text = [weakSelf convertTime:currentSecond];
        }
        
        if(weakSelf.delegate && [weakSelf respondsToSelector:@selector(PPMoviePlayerView:timeChanged:)]){
            [weakSelf.delegate PPMoviePlayerView:weakSelf timeChanged:currentSecond];
        }
        
        if(self.delegate && [weakSelf.delegate respondsToSelector:@selector(PPMoviePlayerView:playStatusChanged:)]){
            [weakSelf.delegate PPMoviePlayerView:weakSelf playStatusChanged:PPMoviePlayerStatusPlaying];
        }
    }];

    // 监听准备播放状态属性
    [self.playerItem addObserver:self forKeyPath:PlayerItemKey_Status options:NSKeyValueObservingOptionNew context:nil];
    
    // 监听缓冲进度属性
    [self.playerItem addObserver:self forKeyPath:PlayerItemKey_LoadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
    
    //监听播放的区域缓存是否为空
    [self.playerItem addObserver:self forKeyPath:PlayerItemKey_PlaybackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
    
    //缓存可以播放的时候调用
    [self.playerItem addObserver:self forKeyPath:PlayerItemKey_PlaybackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:nil];
    
    //跳转到那个时间点播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackJumped:)
                                                 name:AVPlayerItemTimeJumpedNotification
                                               object:self.playerItem];
    //网络不好，加载播放失速
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStalled:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:self.playerItem];
    // 添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    //播放失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFailed:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:self.playerItem];
}

- (void)playbackJumped:(NSNotification *)notification {
    NSLog(@"视频播放已跳转");
    
}

- (void)playbackStalled:(NSNotification *)notification {
    NSLog(@"网络不好,视频加载失速");
    [self networkStalled];
}

- (void)playbackFinished:(NSNotification *)notification {
    NSLog(@"视频播放完成通知");
    
    //1.重置状态
    //self.playerItem = [notification object];
    [self.playerItem seekToTime:kCMTimeZero]; // item 跳转到初始
    //[_player play]; // 循环播放
    
    _status = PPMoviePlayerStatusStop;
    
    //2.显示重播按钮
    [self.btnReplay setImage:[UIImage imageNamed:@"PPKit_vp_replay"] forState:UIControlStateNormal];
    [self addSubview:self.btnReplay];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(PPMoviePlayerView:playStatusChanged:)]){
        [self.delegate PPMoviePlayerView:self playStatusChanged:PPMoviePlayerStatusStop];
    }
}

- (void)playbackFailed:(NSNotification *)notification{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:PlayerItemKey_Status]) {
        // 获取视频准备播放状态
        /*
         AVPlayerItemStatusUnknown,      状态未知
         AVPlayerItemStatusReadyToPlay,  准备好播放
         AVPlayerItemStatusFailed        准备失败
         */
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        
        if (status == AVPlayerItemStatusUnknown){
            NSLog(@"AVPlayerItemStatusUnknown");
        }else if (status == AVPlayerItemStatusReadyToPlay){
            NSLog(@"AVPlayerItemStatusReadyToPlay");
            //1.获取视频长度
            self.duration = item.duration;
            self.playProgress.maximumValue = CMTimeGetSeconds(item.duration);
            self.labEndTime.text = [self convertTime:CMTimeGetSeconds(item.duration)];
            
            //2. 视频播放
            [self.player play];
            
            //3.显示控件
            self.topView.alpha = 1;
            self.bottomView.alpha = 1;
            [self bringSubviewToFront:self.topView];
            [self bringSubviewToFront:self.bottomView];
            //开启定时器
            [self startControlTimer];
            
        }else if (status == AVPlayerItemStatusFailed){
            NSLog(@"AVPlayerItemStatusFailed");
        }
    }else if ([keyPath isEqualToString:PlayerItemKey_LoadedTimeRanges]) {
        // 监听缓冲进度属性
        
        // 获取视频缓冲进度
        NSArray<NSValue *> *loadedTimeRanges = self.playerItem.loadedTimeRanges;
        
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];  // 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        
        float loadedDuration = startSeconds + durationSeconds;                      // 计算缓冲总进度
        //NSLog(@"当前缓存进度：%f",loadedDuration);
        
        [self.loadedProgress setProgress:loadedDuration / CMTimeGetSeconds(self.duration) animated:YES]; // 更新缓冲条
    }else if ([keyPath isEqualToString:PlayerItemKey_PlaybackBufferEmpty]) {
        // 监听播放的区域缓存是否为空
        
    }else if ([keyPath isEqualToString:PlayerItemKey_PlaybackLikelyToKeepUp]) {
        // 缓存可以播放的时候调用
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
