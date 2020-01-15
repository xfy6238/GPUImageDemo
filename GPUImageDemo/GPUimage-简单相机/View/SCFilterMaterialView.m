//
//  SCFilterMaterialView.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/9.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCFilterMaterialView.h"
#import "SCFilterMaterialViewCell.h"

static NSString *const kSCFilterMateralViewReuseIdenifier = @"SCFilterMaterialViewReuseIdentifier";

@interface SCFilterMaterialView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic) NSInteger  currentIndex;

@property (nonatomic, weak) SCFilterMaterialModel *selectMaterialModel;

@end


@implementation SCFilterMaterialView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

//MARK: Public

- (void)scrllToIndex:(NSInteger)index {
    if (_currentIndex == index) {
        return;
    }
    if (index >= _itemList.count) {
        return;
    }
    [self selectIndex:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)scrollToTop {
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
}

- (void)commonInit {
    [self createCollectionViewLayout];
    self.collectionView = [[UICollectionView alloc]initWithFrame:[self bounds] collectionViewLayout:_collectionViewLayout];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[SCFilterMaterialViewCell class] forCellWithReuseIdentifier:kSCFilterMateralViewReuseIdenifier];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self selectIndex:0];
    });
}

- (void)createCollectionViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 0;
    
    CGFloat itemW = 60;
    CGFloat itemH = 100;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionViewLayout = layout;
}

- (void)selectIndex:(NSIndexPath *)indexPath {
    SCFilterMaterialViewCell *lastSelectCell = (SCFilterMaterialViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    SCFilterMaterialViewCell *currentSelectCell = (SCFilterMaterialViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    lastSelectCell.isSelect = NO;
    currentSelectCell.isSelect = YES;
    
    self.currentIndex = indexPath.row;
    self.selectMaterialModel = self.itemList[self.currentIndex];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(filteMateralView: didScrollviewToIndex:)]) {
        [self.delegate filteMateralView:self didScrollviewToIndex:indexPath.row];
    }
}

//MARK: Custom Accessor
- (void)setItemList:(NSArray<SCFilterMaterialModel *> *)itemList {
    _itemList = itemList;
    [self.collectionView reloadData];
    if ([itemList containsObject:self.selectMaterialModel]) {
        NSInteger index = [itemList indexOfObject:self.selectMaterialModel];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else{
        [self scrollToTop];
    }
}

//MARK: UICollctionviewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCFilterMaterialViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSCFilterMateralViewReuseIdenifier forIndexPath:indexPath];
    cell.filterMaterialModel = self.itemList[indexPath.row];
    cell.isSelect = cell.filterMaterialModel == self.selectMaterialModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectIndex:indexPath];
}

@end
