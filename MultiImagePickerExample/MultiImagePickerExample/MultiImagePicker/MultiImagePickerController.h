//
//  MultiImagePickerController.h
//  HappyLG
//
//  Created by hliu on 2017/12/8.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol MultiImagePickerControllerDelegate <NSObject>

- (void)multiImagePickComplete:(NSMutableArray *)selectedAssets;

@end

@interface MultiImagePickerController : UIViewController
@property (nonatomic, weak) id<MultiImagePickerControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) PHAssetCollection *collection;
@end
