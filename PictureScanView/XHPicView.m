//
//  XHPicView.m
//  PictureScanView
//
//  Created by xhliang on 15/12/30.
//  Copyright © 2015年 xhliang. All rights reserved.
//

#import "XHPicView.h"

#define kScreenSizeWidth [UIScreen mainScreen].bounds.size.width

#define kScreenSizeHeight [UIScreen mainScreen].bounds.size.height

@interface XHPicView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation XHPicView

//初始化 网络图片
-(instancetype)initWithFrame:(CGRect)frame withImgUrl:(NSString *)imgUrl
{
    if (self = [super initWithFrame:frame]) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _flowLayout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:_flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_collectionView];
    }
    return self;
}

@end

@implementation PicCell

@end
