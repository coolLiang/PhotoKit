//
//  ImageCollectionViewController.h
//  ALA
//
//  Created by noci on 16/4/19.
//  Copyright © 2016年 noci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ImageCollectionViewController : UICollectionViewController

@property(nonatomic,strong)PHFetchResult * assetsFetchResults; //所以资源结果

@property(nonatomic,strong)PHAssetCollection * assetCollection; //单一分组资源结果(智能分组)

@end
