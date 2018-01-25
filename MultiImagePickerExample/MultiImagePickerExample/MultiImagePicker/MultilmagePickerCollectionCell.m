//
//  MultilmagePickerCollectionCell.m
//  HappyLG
//
//  Created by hliu on 2017/12/9.
//  Copyright © 2017年 hliu. All rights reserved.
//

#import "MultilmagePickerCollectionCell.h"
#import "MultiConstant.h"
@interface MultilmagePickerCollectionCell()

@property (nonatomic, strong) UIImage *image;

@end

@implementation MultilmagePickerCollectionCell

static UIImage *checkedIcon;
static UIColor *selectedColor;
static UIColor *disabledColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        checkedIcon = [UIImage imageNamed:@"selected_image"];
        selectedColor   = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.enabled = YES;
    }
    return self;
}

- (void)setAsset:(PHAsset *)asset
{
    _asset = asset;
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = false;
    //原图
    //PHImageManagerMaximumSize
    NSInteger retinaMultiplier = [UIScreen mainScreen].scale;
    CGSize retinaSquare = CGSizeMake(self.bounds.size.width * retinaMultiplier, self.bounds.size.height * retinaMultiplier);
    
    __weak __typeof__(self) weakSelf = self;
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:retinaSquare contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.image = result;
        [strongSelf setNeedsDisplay];
    }];
}

- (void)configureCellContains:(BOOL)contains
{
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkButton.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 30, 0, 30, 30);
    [self.checkButton addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    if (contains) {
        [self.checkButton setSelected:YES];
        [self.checkButton setImage:MultiImageChecked forState:UIControlStateNormal];
    } else {
        [self.checkButton setSelected:NO];
        [self.checkButton setImage:MultiImageUnChecked forState:UIControlStateNormal];
    }
    
    [self.contentView addSubview:self.checkButton];
}

- (void)check:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(selecteOneAsset:inCell:)]) {
        [self.delegate selecteOneAsset:self.asset inCell:self];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawThumbnailInRect:rect];
    
//    if (!self.isEnabled)
//        [self drawDisabledViewInRect:rect];
//    
    if (self.checkButton.selected)
        [self drawSelectedViewInRect:rect];
}

- (void)drawThumbnailInRect:(CGRect)rect
{
    [self.image drawInRect:rect];
}

- (void)drawSelectedViewInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, selectedColor.CGColor);
    CGContextFillRect(context, rect);
//    [checkedIcon drawAtPoint:CGPointMake(CGRectGetMaxX(rect) - checkedIcon.size.width, CGRectGetMinY(rect))];
}

- (void)drawDisabledViewInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, disabledColor.CGColor);
    CGContextFillRect(context, rect);
}

@end
