//
//  MultiImageAllBrowserController.m
//  HappyLG
//
//  Created by hliu on 2017/12/15.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import "MultiImageAllBrowserController.h"
#import "MultiImageBrowserCollectionCell.h"
#import "MultiImagePickerLayout.h"
@interface MultiImageAllBrowserController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *assets;
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation MultiImageAllBrowserController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat minimumLineSpacing = 0.0f;
    CGFloat minimumInteritemSpacing = 0.0f;
    MultiImagePickerLayout *layout = [[MultiImagePickerLayout alloc] initWithMinimumLineSpacing:minimumLineSpacing minimumInteritemSpacing:minimumInteritemSpacing size:CGSizeMake(self.view.bounds.size.width+20, self.view.bounds.size.height-64)];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width+20, self.view.bounds.size.height-64) collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.allowsSelection = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    self.assets = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.collection options:option];
        __weak __typeof__(self) weakSelf = self;
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong __typeof(self) strongSelf = weakSelf;
            
            PHAsset *asset = (PHAsset *)obj;
            if ([asset isEqual:strongSelf.asset]) {
                strongSelf.currentIndex = idx;
            }
            //        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
            [strongSelf.assets addObject:asset];
            if (idx == result.count-1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:strongSelf.currentIndex inSection:0];
                    [strongSelf.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                    strongSelf.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu",(long)(strongSelf.currentIndex+1),(unsigned long)strongSelf.assets.count];
                });
            }
        }];
    });
    
    [self.collectionView registerClass:[MultiImageBrowserCollectionCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MultiImageBrowserCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PHAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width + 20);
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu",(long)(self.currentIndex+1),(unsigned long)self.assets.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
