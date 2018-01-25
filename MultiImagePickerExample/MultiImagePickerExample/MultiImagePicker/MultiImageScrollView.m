//
//  MultiImageScrollView.m
//  HappyLG
//
//  Created by hliu on 2017/12/15.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import "MultiImageScrollView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface MultiImageScrollView()<UIScrollViewDelegate>
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playItem;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@end

@implementation MultiImageScrollView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.minimumZoomScale = 1;
        self.maximumZoomScale = 2;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)setAsset:(PHAsset *)asset
{
    _asset = asset;
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        [self.imageView removeFromSuperview];
        
        PHImageManager *manager = [PHImageManager defaultManager];
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
        [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            self.playItem = [AVPlayerItem playerItemWithAsset:asset];
            self.player = [AVPlayer playerWithPlayerItem:self.playItem];
            
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            self.playerLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            [self.layer addSublayer:self.playerLayer];
            
            [self.player play];
        }];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];

    } else {
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.synchronous = false;
        //原图
        //PHImageManagerMaximumSize
        NSInteger retinaMultiplier = [UIScreen mainScreen].scale;
        CGSize retinaSquare = CGSizeMake(self.bounds.size.width * retinaMultiplier, self.bounds.size.height * retinaMultiplier);
        
        __weak __typeof__(self) weakSelf = self;
        [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:retinaSquare contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            __strong __typeof(self) strongSelf = weakSelf;
            strongSelf.imageView.image = result;
        }];
    }
}

-(void)didPlayToEndTime:(NSNotification *)notification
{
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}
@end
