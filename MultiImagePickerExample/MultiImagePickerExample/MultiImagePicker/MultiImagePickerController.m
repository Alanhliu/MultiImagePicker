//
//  MultiImagePickerController.m
//  HappyLG
//
//  Created by hliu on 2017/12/8.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import "MultiImagePickerController.h"
#import "MultiImagePickerLayout.h"
#import "MultilmagePickerCollectionCell.h"
#import "MultiImagePiackCameraCell.h"
#import "MultiImageAllBrowserController.h"
#import "MultiConstant.h"
@interface MultiImagePickerController ()<UICollectionViewDelegate,UICollectionViewDataSource,MultilmageCollectionCellDelegate,PHPhotoLibraryChangeObserver,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *assets;
@property (nonatomic, strong) PHFetchResult *result;
@property (nonatomic, strong) UIBarButtonItem *browseItem;
@property (nonatomic, strong) UIBarButtonItem *completeItem;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation MultiImagePickerController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController setToolbarHidden:NO animated:YES];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController setToolbarHidden:YES animated:YES];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.navigationItem.title = self.collection.localizedTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    [self.navigationController.toolbar setBarTintColor:[UIColor blackColor]];
    
    self.navigationController.toolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44);
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.browseItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStyleDone target:self action:@selector(browse)];
    self.browseItem.tintColor = [UIColor whiteColor];
    
    self.completeItem = [[UIBarButtonItem alloc] initWithCustomView:self.completeButton];
    
    [self browse_complete_item_control];
    
    NSArray *toolBarItems = [[NSArray alloc] initWithObjects:self.browseItem,spaceItem,self.completeItem, nil];
    
    self.toolbarItems = toolBarItems;
    
    
    if (!self.selectedAssets) {
        self.selectedAssets = [NSMutableArray new];
    }
    
    NSInteger column = 3;
    CGFloat minimumLineSpacing = 4.0f;
    CGFloat minimumInteritemSpacing = 2.0f;
    
    CGFloat length = (self.view.bounds.size.width - (column-1)*minimumLineSpacing)/column;
    
    MultiImagePickerLayout *layout = [[MultiImagePickerLayout alloc] initWithMinimumLineSpacing:minimumLineSpacing minimumInteritemSpacing:minimumInteritemSpacing size:CGSizeMake(length, length)];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44) collectionViewLayout:layout];
    self.collectionView.allowsSelection = YES;
    self.collectionView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self refetchAssets];
    
    [self.collectionView registerClass:[MultilmagePickerCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[MultiImagePiackCameraCell class] forCellWithReuseIdentifier:@"cameraCell"];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)refetchAssets
{
    self.assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    self.result = [PHAsset fetchAssetsInAssetCollection:self.collection options:option];
    
    __weak __typeof__(self) weakSelf = self;
    [self.result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong __typeof(self) strongSelf = weakSelf;
        
        PHAsset *asset = (PHAsset *)obj;
        //        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        [strongSelf.assets addObject:asset];
        if (idx == strongSelf.result.count-1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.collectionView reloadData];
            });
        }
    }];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    PHFetchResultChangeDetails *details = [changeInstance changeDetailsForFetchResult:self.result];
    if ([details hasIncrementalChanges]) {
        [details.removedObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = obj;
            if ([self.selectedAssets containsObject:asset]) {
                [self.selectedAssets removeObject:asset];
            }
        }];
        
        [self refetchAssets];
    }
    return;
    
    //这里本想不刷新collectionView，靠增减动画处理，但会有些重复和闪退的问题
    dispatch_sync(dispatch_get_main_queue(), ^{
        @try
        {
            [self.collectionView performBatchUpdates:^{
                if (details.removedObjects.count > 0) {
                    
                    NSIndexSet *indexSet = details.removedIndexes;
                    [self.assets removeObjectsAtIndexes:indexSet];
                    [self.collectionView deleteItemsAtIndexPaths:[self indexSetToIndexPaths:indexSet]];
                }
                
                if (details.insertedObjects.count > 0) {
                    
                    NSIndexSet *indexSet = details.insertedIndexes;
                    [self.assets insertObjects:details.insertedObjects atIndexes:indexSet];
                    [self.collectionView insertItemsAtIndexPaths:[self indexSetToIndexPaths:indexSet]];
                }
                
                if (details.changedObjects.count > 0) {
                    
                    [details enumerateMovesWithBlock:^(NSUInteger fromIndex, NSUInteger toIndex) {
                        NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:fromIndex inSection:0];
                        NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
                        [self.assets exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];

                        [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                    }];
                }
            } completion:nil];
        }
        @catch (NSException *e)
        {
            [self.collectionView reloadData];
        }
        @finally
        {
            
        }
    });
}

- (NSMutableArray<NSIndexPath *> *)indexSetToIndexPaths:(NSIndexSet *)indexSet
{
    NSMutableArray *indexPaths = [NSMutableArray new];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
    }];
    return indexPaths;
}

#pragma mark - button Action
- (void)browse
{
    PHAsset *asset = self.selectedAssets.firstObject;
    MultiImageAllBrowserController *multiImageAllBrowserController = [[MultiImageAllBrowserController alloc] init];
    multiImageAllBrowserController.asset = asset;
    multiImageAllBrowserController.collection = self.collection;
    [self.navigationController pushViewController:multiImageAllBrowserController animated:YES];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)complete
{
    [self.delegate multiImagePickComplete:self.selectedAssets];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        MultiImagePiackCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cameraCell" forIndexPath:indexPath];
        return cell;
    } else {
        MultilmagePickerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.delegate = self;
        PHAsset *asset = self.assets[indexPath.row-1];
        
        [cell.checkButton removeFromSuperview];
        
        BOOL contains = NO;
        if ([self.selectedAssets containsObject:asset]) {
            contains = YES;
        } else {
            contains = NO;
        }
        [cell configureCellContains:contains];
        
        [cell setAsset:asset];
        [cell setEnabled:YES];
        return cell;
    }
}

- (void)selecteOneAsset:(PHAsset *)asset inCell:(MultilmagePickerCollectionCell *)cell
{
    if (cell.checkButton.isSelected) {
        [cell.checkButton setImage:MultiImageUnChecked forState:UIControlStateNormal];
        [cell.checkButton setSelected:!cell.checkButton.selected];
        if ([self.selectedAssets containsObject:asset]) {
            [self.selectedAssets removeObject:asset];
        }
    } else {
        if (self.selectedAssets.count != 9) {
            [cell.checkButton setImage:MultiImageChecked forState:UIControlStateNormal];
            
            ///
            /*
            [cell.checkButton setImage:nil forState:UIControlStateNormal];
            [cell.checkButton setBackgroundColor:[UIColor greenColor]];
            [cell.checkButton setTitle:[@(self.selectedAssets.count+1) stringValue] forState:UIControlStateNormal];
            
            CABasicAnimation *scaleAmimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAmimation.fromValue = [NSNumber numberWithFloat:1.0f];
            scaleAmimation.toValue = [NSNumber numberWithFloat:1.3f];
            [cell.checkButton.layer addAnimation:scaleAmimation forKey:@"scaleAmimation"];
             */
            ///
            
            [cell.checkButton setSelected:!cell.checkButton.selected];
        }
    }
    
    [cell setNeedsDisplay];
    
    if (self.selectedAssets.count == 9) {
        [self imageMostCountAlert];
    }
    
    if (cell.checkButton.selected) {
        [self.selectedAssets addObject:asset];
    }
    
    [self browse_complete_item_control];
}

- (void)browse_complete_item_control
{
    if (self.selectedAssets.count > 0) {
        self.browseItem.enabled = YES;
        self.completeItem.enabled = YES;
        [self.completeButton setTitle:[NSString stringWithFormat:@"完成(%lu)",(unsigned long)self.selectedAssets.count] forState:UIControlStateNormal];
    } else {
        self.browseItem.enabled = NO;
        self.completeItem.enabled = NO;
        [self.completeButton setTitle:@"完成" forState:UIControlStateNormal];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.selectedAssets.count < 9) {
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        } else {
            [self imageMostCountAlert];
        }
    } else {
        PHAsset *asset = self.assets[indexPath.row-1];
        MultiImageAllBrowserController *multiImageAllBrowserController = [[MultiImageAllBrowserController alloc] init];
        multiImageAllBrowserController.asset = asset;
        multiImageAllBrowserController.collection = self.collection;
        [self.navigationController pushViewController:multiImageAllBrowserController animated:YES];
    }
}

#pragma mark - imagePickerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo
{
    __block PHAsset *asset;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    fetchOptions.fetchLimit = 1;
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        asset = obj;
    }];
    
    if (self.selectedAssets.count < 9) {
        [self.selectedAssets addObject:asset];
        [self.imagePicker dismissViewControllerAnimated:YES completion:^{
            [self complete];
        }];
    }
}

- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    return _imagePicker;
}

- (void)imageMostCountAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你最多只能选择9张照片" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    return;
}

- (UIButton *)completeButton
{
    if (!_completeButton) {
        _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _completeButton.backgroundColor = [UIColor redColor];
        [_completeButton.layer setCornerRadius:6];
        [_completeButton.layer setMasksToBounds:YES];
        [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
        _completeButton.frame = CGRectMake(0, 0, 60, 30);
        _completeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_completeButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
