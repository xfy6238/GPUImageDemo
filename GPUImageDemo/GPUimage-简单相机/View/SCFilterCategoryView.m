//
//  SCFilterCategoryView.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/9.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCFilterCategoryView.h"
#import "SCFilterCategoryCell.h"

static NSString  * const kFilterCategoryResueIdentifier = @"kFilterCategoryReuseIdentifier";

@interface SCFilterCategoryView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewlayout;

@property (nonatomic) NSInteger currentIndex;

@end

@implementation SCFilterCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _collectionView.frame = [self bounds];
    _collectionViewlayout.itemSize = CGSizeMake(_itemWidth, CGRectGetHeight(self.frame));
    [_collectionView reloadData];
}

- (void)setItemList:(NSArray<NSString *> *)itemList {
    _itemList = itemList;
}

- (void)setItemFont:(UIFont *)itemFont {
    _itemFont = itemFont;
    [_collectionView reloadData];
}

- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    [_collectionView reloadData];
}

- (void)setItemNormalColor:(UIColor *)itemNormalColor {
    _itemNormalColor = itemNormalColor;
    [_collectionView reloadData];
}

- (void)setItemSelectColor:(UIColor *)itemSelectColor {
    _itemSelectColor = itemSelectColor;
    [_collectionView reloadData];
}

- (void)scorllToIndex:(NSUInteger)index {
    if (_currentIndex == index) {
        return;
    }
    
    if (index >= _itemList.count) {
        return;
    }
    [self selectIndex:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)commonInit {
    [self createCollectionViewLayout];
    _collectionView = [[UICollectionView alloc]initWithFrame:[self bounds] collectionViewLayout:_collectionViewlayout];
    [self addSubview:_collectionView];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [_collectionView registerClass:[SCFilterCategoryCell class] forCellWithReuseIdentifier:kFilterCategoryResueIdentifier];
}

- (void)createCollectionViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    CGFloat itemW = _itemWidth;
    CGFloat itemH = CGRectGetHeight(self.frame);
    layout.itemSize = CGSizeMake(itemW, itemH);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionViewlayout = layout;
}

- (void)selectIndex:(NSIndexPath *)indexPath {
    if (indexPath.row == _currentIndex) {
        return;
    }
    _currentIndex = indexPath.row;
    [_collectionView reloadData];
    
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(filterCategoryView:didScrollToIndex:)]) {
        [self.delegate filterCategoryView:self didScrollToIndex:_currentIndex];
    }
}


//MARK: UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemList ? [_itemList count] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCFilterCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFilterCategoryResueIdentifier forIndexPath:indexPath];
    
    UILabel *lab = cell.titleLab;
    lab.text = _itemList[indexPath.row];
    lab.font = _itemFont;
    lab.textColor = _currentIndex == indexPath.row ? _itemSelectColor : _itemNormalColor;
    
    UIView *bottomLine = cell.bottomLine;
    if (_currentIndex == indexPath.row) {
        bottomLine.hidden = NO;
        bottomLine.backgroundColor = _itemSelectColor;

        CGRect frame = bottomLine.frame;
        frame.size.width = _bottomLineWidth ? _bottomLineWidth : _itemWidth;
        frame.size.height = _bottomLineHeight ? _bottomLineHeight : CGRectGetHeight(frame);
        bottomLine.frame = frame;
        
        bottomLine.layer.cornerRadius = CGRectGetHeight(frame) / 2;
    }else{
        bottomLine.hidden = YES;
    }
    

    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectIndex:indexPath];
}

@end
