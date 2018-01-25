//
//  MultiImageBrowserCollectionCell.m
//  HappyLG
//
//  Created by hliu on 2017/12/15.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import "MultiImageBrowserCollectionCell.h"
@implementation MultiImageBrowserCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-20, frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    
    return self;
}

- (void)setAsset:(PHAsset *)asset
{
    self.imageView.image = nil;
    _asset = asset;
    
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = false;
    //原图
    //PHImageManagerMaximumSize

    __weak __typeof__(self) weakSelf = self;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.imageView.image = result;
    }];
}

@end
