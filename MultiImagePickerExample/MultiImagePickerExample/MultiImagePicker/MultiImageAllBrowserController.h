//
//  MultiImageAllBrowserController.h
//  HappyLG
//
//  Created by hliu on 2017/12/15.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface MultiImageAllBrowserController : UIViewController

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) PHAssetCollection *collection;

@end
