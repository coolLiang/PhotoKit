//
//  ShowImageViewController.m
//  ALA
//
//  Created by noci on 16/4/19.
//  Copyright © 2016年 noci. All rights reserved.
//

#import "ShowImageViewController.h"


@interface ShowImageViewController ()

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.chooseImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        PHAsset * assets = obj;
        
        PHImageManager * imageManager = [[PHImageManager alloc]init];
        
        UIImageView * imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(20, 20 + idx * 110, 100, 100);
        
        [imageManager requestImageForAsset:assets targetSize:CGSizeMake(100, 100) contentMode:1 options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            imageV.image = result;
            
        }];
        
        [self.view addSubview:imageV];
        
        
    }];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
