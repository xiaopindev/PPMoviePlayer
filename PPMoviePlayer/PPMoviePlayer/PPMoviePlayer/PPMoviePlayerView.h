//
//  PPMoviePlayerView.h
//  PPMoviePlayer
//
//  Created by xiaopin on 16/10/27.
//  Copyright © 2016年 PPKit. All rights reserved.
//
//  My Blog: http://xiaopin.cnblogs.com
//  Git Hub: https://github.com/xiaopn166
//  QQ交流群：168368234
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef enum : NSUInteger {
    PPMoviePlayerStatusUnknown,
    PPMoviePlayerStatusPause,
    PPMoviePlayerStatusPlaying,
    PPMoviePlayerStatusStop,
} PPMoviePlayerStatus;

typedef enum : NSUInteger {
    PPMoviePlayerControlStyleNone,
    PPMoviePlayerControlStyleNormal,
    PPMoviePlayerControlStyleFullScreen,
} PPMoviePlayerControlStyle;

@protocol PPMoviePlayerViewDelegate;

@interface PPMoviePlayerView : UIView

@property (nonatomic,weak) id<PPMoviePlayerViewDelegate> delegate;

/**
 视频标题，在顶部标题栏显示
 */
@property (nonatomic,strong) NSString *videoTitle;

/**
 视频本地或网络播放路径
 */
@property (nonatomic,strong) NSURL *videoUrl;

/**
 只在全屏的时候显示顶部工具栏
 */
@property (nonatomic,assign) BOOL showTopBarOnlyFullScreen;

/**
 全屏状态
 */
@property (nonatomic,assign,getter=isFullScreen) BOOL fullScreen;

/**
 控制控件显示的样式
 PPMoviePlayerControlStyleNone,什么都没有，默认
 PPMoviePlayerControlStyleNormal,小尺寸的时候简易控件样式
 PPMoviePlayerControlStyleFullScreen,小尺寸的时候简易控件样式
 */
@property (nonatomic,assign) PPMoviePlayerControlStyle controlStyle;

/**
 播放状态
 PPMoviePlayerStatusUnknown,未知状态
 PPMoviePlayerStatusPause,暂停状态
 PPMoviePlayerStatusPlaying,播放状态
 PPMoviePlayerStatusStop,停止状态
 */
@property (nonatomic,assign,readonly) PPMoviePlayerStatus status;

/**
 播放
 */
- (void)play;

/**
 从指定位置开始播放
 
 @param timeInterval <#timeInterval description#>
 */
- (void)playWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 暂停
 */
- (void)pause;

/**
 停止
 */
- (void)stop;

@end

@protocol PPMoviePlayerViewDelegate <NSObject>

@optional
/**
 播放时间改变
 
 @param view           <#view description#>
 @param currentSencond <#currentSencond description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view timeChanged:(NSTimeInterval)currentSencond;

/**
 播放状态改变
 
 @param view   <#view description#>
 @param status <#status description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view playStatusChanged:(PPMoviePlayerStatus)status;

/**
 返回按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view backAction:(id)sender;

/**
 投屏按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view toTVAction:(id)sender;

/**
 分享按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view shareAction:(id)sender;

/**
 收藏按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view favoriteAction:(id)sender;

/**
 下载按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view downloadAction:(id)sender;

/**
 更多按钮点击

 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view moreAction:(id)sender;

/**
 播放暂停按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view playOrPauseAction:(id)sender;

/**
 下一个视频按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view nextVideoAction:(id)sender;

/**
 播放质量切换按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view qualityAction:(id)sender;

/**
 播放列表按钮点击
 
 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view videoListAction:(id)sender;

/**
 全屏/取消全屏点击

 @param view   <#view description#>
 @param sender <#sender description#>
 */
- (void)PPMoviePlayerView:(PPMoviePlayerView*)view fullScreenAction:(id)sender;

@end
