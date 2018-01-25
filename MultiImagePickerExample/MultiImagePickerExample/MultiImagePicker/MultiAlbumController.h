//
//  MultiAlbumController.h
//  HappyLG
//
//  Created by hliu on 2017/12/9.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol MultiAlbumControllerDelegate <NSObject>

@required
- (void)multiImagePickComplete:(NSMutableArray *)selectedAssets;

@end

@interface MultiAlbumController : UITableViewController
@property (nonatomic, weak) id<MultiAlbumControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) BOOL showDefaultCameraRoll;

@end
