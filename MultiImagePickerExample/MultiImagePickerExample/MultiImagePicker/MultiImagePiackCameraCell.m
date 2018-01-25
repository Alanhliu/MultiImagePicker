//
//  MultiImagePiackCameraCell.m
//  HappyLG
//
//  Created by hliu on 2018/1/2.
//  Copyright © 2018年 hliu. All rights reserved.
//

#import "MultiImagePiackCameraCell.h"
#import "MultiConstant.h"
@implementation MultiImagePiackCameraCell
{
    UIImageView *_imageView;
    UILabel *_label;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:54/255.0 blue:55/255.0 alpha:1];
        self.contentView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:54/255.0 blue:55/255.0 alpha:1];
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake((frame.size.width-MultiImageCameraLength)/2, (frame.size.height-MultiImageCameraLength)/2-10, MultiImageCameraLength, MultiImageCameraLength);
        _imageView.image = MultiImageCamera;
        [self.contentView addSubview:_imageView];
        
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake((frame.size.width-60)/2, (frame.size.height-20)/2+15, 60, 20);
        _label.font = [UIFont systemFontOfSize:14];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"拍摄照片";
        _label.textColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
        [self.contentView addSubview:_label];
    }
    return self;
}

@end
