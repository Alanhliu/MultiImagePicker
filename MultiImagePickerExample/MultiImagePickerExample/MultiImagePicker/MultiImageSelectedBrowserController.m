//
//  MultiImageSelectedBrowserController.m
//  HappyLG
//
//  Created by hliu on 2017/12/15.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import "MultiImageSelectedBrowserController.h"
#import "MultiImageScrollView.h"
#import "PHAsset+MultiSelect.h"
@interface MultiImageSelectedBrowserController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL hidden;
@end

@implementation MultiImageSelectedBrowserController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)hideStatusBar
{
    self.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

- (BOOL)prefersStatusBarHidden
{
    return self.hidden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)+20, CGRectGetHeight(self.view.bounds))];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    [self reloadData];
}

- (void)reloadData
{
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu",(long)(self.currentIndex+1),(unsigned long)self.selectedAssets.count];
    for (NSInteger index = 0; index < self.selectedAssets.count; index++) {
        
        CGRect rect = CGRectMake(index * ([UIScreen mainScreen].bounds.size.width + 20), 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        MultiImageScrollView *imageScrollView = [[MultiImageScrollView alloc] initWithFrame:rect];
        PHAsset *asset = self.selectedAssets[index];
        [imageScrollView setAsset:asset];
        [self.scrollView addSubview:imageScrollView];
    }
    
    [self.scrollView setContentSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width + 20) * self.selectedAssets.count, [UIScreen mainScreen].bounds.size.height)];
    [self.scrollView setContentOffset:CGPointMake(self.currentIndex * ([UIScreen mainScreen].bounds.size.width + 20), 0)];
}

- (void)delete
{
    PHAsset *asset = self.selectedAssets[self.currentIndex];
    [self.selectedAssets removeObject:asset];
    
    if (self.selectedAssets.count > 0) {
        if (self.currentIndex != 0) {
            self.currentIndex--;
        }
        [self reloadData];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width + 20);
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu",(long)(self.currentIndex+1),(unsigned long)self.selectedAssets.count];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideStatusBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
