//
// Created by efeng on 15/11/8.
// Copyright (c) 2015 buerguo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YIBaseCollectionViewController : YIBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *baseCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) BOOL refreshEnable;

@end