//
//  SendTableViewController.m
//  HappyLG
//
//  Created by siasun on 2017/11/23.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "SendTableViewController.h"
#import "SendCollectionViewCell.h"
#import "PHAsset+MultiSelect.h"
#import "MultiAlbumController.h"
#import "MultiImageSelectedBrowserController.h"
@interface SendTableViewController ()<MultiAlbumControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, copy) NSString *random;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBarItem;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedAssets;

@end

@implementation SendTableViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark - send
- (IBAction)send:(id)sender {
    
}

#pragma mark - button Action
#pragma mark - image button Action
- (IBAction)imageButtonAction:(id)sender {
    
    MultiAlbumController *multiAlbumController = [[MultiAlbumController alloc] init];
    multiAlbumController.hidesBottomBarWhenPushed = YES;
    multiAlbumController.delegate = self;
    multiAlbumController.selectedAssets = self.selectedAssets;
    multiAlbumController.showDefaultCameraRoll = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: multiAlbumController];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - video button Action
- (IBAction)videoButtonAction:(id)sender {
    
}

#pragma mark - url Button Action
- (IBAction)urlButtonAction:(id)sender {
   
}

#pragma mark - MultiAlbumControllerDelegate
- (void)multiImagePickComplete:(NSMutableArray *)selectedAssets
{
    self.selectedAssets = selectedAssets;
    [self.collectionView reloadData];
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SendCollectionViewCell" forIndexPath:indexPath];
    PHAsset *asset = self.selectedAssets[indexPath.row];
    
    [cell cleanPlayButton];
    
    UIImage *image = [asset convertPHAssetToImageSize:CGSizeMake(80,80)];
    cell.imageView.image = image;
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        [cell showPlayButton];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    MultiImageSelectedBrowserController *multiImageBrowserController = [[MultiImageSelectedBrowserController alloc] init];
    multiImageBrowserController.selectedAssets = self.selectedAssets;
    multiImageBrowserController.currentIndex = index;
    [self.navigationController pushViewController:multiImageBrowserController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
