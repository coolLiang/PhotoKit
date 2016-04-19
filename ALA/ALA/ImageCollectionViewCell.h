//
//  ImageCollectionViewCell.h
//  ALA
//
//  Created by noci on 16/4/19.
//  Copyright © 2016年 noci. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCollectionViewCellDelegate <NSObject>

-(void)onClickTheCellWith:(NSInteger)CellIndex;

@end


@interface ImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;  //图

@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;  //选择后的图 默认隐藏

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;  //选择按钮

@property (nonatomic,assign)NSInteger cellIndex;

@property (nonatomic,weak)id delegate;


+(instancetype)setupCollectionViewCellWith:(UICollectionView *)collection and:(NSIndexPath *)index;

-(void)updateTheCellUI;

@end
