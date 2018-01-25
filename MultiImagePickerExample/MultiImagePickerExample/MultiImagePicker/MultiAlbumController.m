//
//  MultiAlbumController.m
//  HappyLG
//
//  Created by hliu on 2017/12/9.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import "MultiAlbumController.h"
#import "MultiImagePickerController.h"
#import "PHAsset+MultiSelect.h"
#import "MultiConstant.h"
@interface MultiAlbumController ()<MultiImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray *albums;
@end

@implementation MultiAlbumController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.albums = [NSMutableArray new];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:YES]];
    
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:option];
    
    __block PHAssetCollection *cameraRollCollection;
    
    __weak __typeof__(self) weakSelf = self;
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong __typeof(self) strongSelf = weakSelf;
        
        PHAssetCollection *collection = (PHAssetCollection *)obj;
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            cameraRollCollection = collection;
        } else {
            [strongSelf.albums addObject:collection];
        }
        
        if (idx == result.count-1) {
            [strongSelf.albums insertObject:cameraRollCollection atIndex:0];
            [strongSelf.tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.showDefaultCameraRoll) {
                    MultiImagePickerController *multiImagePickerController = [[MultiImagePickerController alloc] init];
                    multiImagePickerController.delegate = strongSelf;
                multiImagePickerController.hidesBottomBarWhenPushed = YES;
                    multiImagePickerController.selectedAssets = strongSelf.selectedAssets;
                    multiImagePickerController.collection = cameraRollCollection;
                    [strongSelf.navigationController pushViewController:multiImagePickerController animated:NO];
                }
            });
        }
    }];
    
    
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    
    if (authorStatus == PHAuthorizationStatusDenied ||
        authorStatus == PHAuthorizationStatusRestricted) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置->幸福辽工->相册中打开相册访问权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)multiImagePickComplete:(NSMutableArray *)selectedAssets
{
    if ([self.delegate respondsToSelector:@selector(multiImagePickComplete:)]) {
        [self.delegate multiImagePickComplete:selectedAssets];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    PHAssetCollection *collection = self.albums[indexPath.row];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
    
    __block UIImage *image = nil;
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        if (idx == 0) {
            image = [asset convertPHAssetToImageSize:CGSizeMake(35, 35)];
            *stop = YES;
        }
    }];
    
    cell.imageView.image = image != nil ? image:MultiImagePlaceholder;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%lu)",collection.localizedTitle,(unsigned long)result.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHAssetCollection *collection = self.albums[indexPath.row];
    MultiImagePickerController *multiImagePickerController = [[MultiImagePickerController alloc] init];
    multiImagePickerController.delegate = self;
    multiImagePickerController.hidesBottomBarWhenPushed = YES;
    multiImagePickerController.selectedAssets = self.selectedAssets;
    multiImagePickerController.collection = collection;
    [self.navigationController pushViewController:multiImagePickerController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
