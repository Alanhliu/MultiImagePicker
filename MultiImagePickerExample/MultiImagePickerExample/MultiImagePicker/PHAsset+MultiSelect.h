//
//  PHAsset+MultiSelect.h
//  HappyLG
//
//  Created by hliu on 2017/12/14.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (MultiSelect)

//原图
//PHImageManagerMaximumSize
- (UIImage *)convertPHAssetToImageSize:(CGSize)size;
+ (NSArray *)convertPHAssetsToImages:(NSArray *)assets;

@end
