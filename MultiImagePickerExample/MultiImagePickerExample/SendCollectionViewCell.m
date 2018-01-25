//
//  SendCollectionViewCell.m
//  HappyLG
//
//  Created by siasun on 2017/12/12.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "SendCollectionViewCell.h"

@interface SendCollectionViewCell ()

@end

@implementation SendCollectionViewCell

- (void)showPlayButton
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.tag = 111;
    CGFloat length = self.bounds.size.width;
    imageView.frame = CGRectMake((length-30)/2, (length-30)/2, 30, 30);
    imageView.image = [UIImage imageNamed:@"play_button"];
    [self.contentView addSubview:imageView];
}

- (void)cleanPlayButton
{
    [[self.contentView viewWithTag:111] removeFromSuperview];
}
@end
