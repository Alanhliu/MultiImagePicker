//
//  MultiImagePickerLayout.m
//  HappyLG
//
//  Created by hliu on 2017/12/8.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import "MultiImagePickerLayout.h"

@implementation MultiImagePickerLayout

- (id)initWithMinimumLineSpacing:(CGFloat)minimumLineSpacing minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing size:(CGSize)size
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = minimumLineSpacing;
        self.minimumInteritemSpacing = minimumInteritemSpacing;
        self.itemSize = size;
    }
    
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];
}

//当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return NO;
}

@end
