//
//  MultilmagePickerCollectionCell.h
//  HappyLG
//
//  Created by hliu on 2017/12/9.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class MultilmagePickerCollectionCell;

@protocol MultilmageCollectionCellDelegate <NSObject>

- (void)selecteOneAsset:(PHAsset *)asset inCell:(MultilmagePickerCollectionCell *)cell;

@end

@interface MultilmagePickerCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, weak) id<MultilmageCollectionCellDelegate> delegate;
- (void)configureCellContains:(BOOL)contains;

@end
