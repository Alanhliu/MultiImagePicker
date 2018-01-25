//
//  PHAsset+MultiSelect.m
//  HappyLG
//
//  Created by siasun on 2017/12/14.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "PHAsset+MultiSelect.h"

@implementation PHAsset (MultiSelect)

- (UIImage *)convertPHAssetToImageSize:(CGSize)size
{
    __block UIImage *image;
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = true;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(size.width*scale, size.height*scale);
    
    
    [[PHImageManager defaultManager] requestImageForAsset:self targetSize:targetSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image = result;
    }];
    return image;
}

+ (NSArray *)convertPHAssetsToImages:(NSArray *)assets
{
    NSMutableArray *mArray = [NSMutableArray new];
    for (PHAsset *asset in assets) {
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.synchronous = true;
        //原图
        //PHImageManagerMaximumSize
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [mArray addObject:result];
        }];
    }
    return [mArray copy];
}
@end
