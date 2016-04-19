//
//  ImageCollectionViewCell.m
//  ALA
//
//  Created by noci on 16/4/19.
//  Copyright © 2016年 noci. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

+(instancetype)setupCollectionViewCellWith:(UICollectionView *)collection and:(NSIndexPath *)index
{
    static NSString * ID = @"ImageCollectionViewCell";
    
    ImageCollectionViewCell *cell =  [collection dequeueReusableCellWithReuseIdentifier:ID forIndexPath:index];
    
    return cell;
}

-(void)updateTheCellUI
{
    self.chooseImageView.hidden = !self.chooseImageView.hidden;
}

- (IBAction)chooseButtonAction:(id)sender {
    
    [self updateTheCellUI];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickTheCellWith:)]) {
        
        [self.delegate onClickTheCellWith:self.cellIndex];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
