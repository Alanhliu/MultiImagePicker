//
//  SendCollectionViewCell.h
//  HappyLG
//
//  Created by siasun on 2017/12/12.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)showPlayButton;

- (void)cleanPlayButton;

@end
