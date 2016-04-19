//
//  ImageCollectionViewController.m
//  ALA
//
//  Created by noci on 16/4/19.
//  Copyright © 2016年 noci. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "ShowImageViewController.h"
#import "ImageCollectionViewCell.h"
#import <PhotosUI/PhotosUI.h>

@interface ImageCollectionViewController ()<PHPhotoLibraryChangeObserver,ImageCollectionViewCellDelegate>

@property(nonatomic,strong)NSMutableArray * imageAssetArray;  //选择的图片集合。

@end

@implementation ImageCollectionViewController


- (instancetype)init
{
    //创建流水布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

  //    // 设置cell之间间距
  layout.minimumInteritemSpacing = 0;
   //    // 设置行距
  layout.minimumLineSpacing = 0;
    
    self.imageAssetArray = [NSMutableArray new];

    return [super initWithCollectionViewLayout:layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //判断如果 不是 智能分组的情况下。 或者 智能分组 允许编辑的情况下。 navi右侧的增加按钮.
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"增加" style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
    
    
    
    if (!self.assetCollection || [self.assetCollection canPerformEditOperation:PHCollectionEditOperationAddContent]) {
        
        self.navigationItem.rightBarButtonItem = right;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

-(void)addAction
{
    ShowImageViewController * showImage = [[ShowImageViewController alloc]init];
    showImage.chooseImageArray = self.imageAssetArray;
    [self.navigationController pushViewController:showImage animated:YES];
    
    
    
//    CGRect rect = rand() % 2 == 0 ? CGRectMake(0, 0, 400, 300) : CGRectMake(0, 0, 300, 400);
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0f);
//    [[UIColor colorWithHue:(float)(rand() % 100) / 100 saturation:1.0 brightness:1.0 alpha:1.0] setFill];
//    UIRectFillUsingBlendMode(rect, kCGBlendModeNormal);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    // 增加一张图片到这个资源组别里面。
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        
//        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
//        
//        //是独立分组时.
//        if (self.assetCollection) {
//            PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:self.assetCollection];
//            [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
//        }
//        
//    } completionHandler:^(BOOL success, NSError *error) {
//        if (!success) {
//            NSLog(@"Error creating asset: %@", error);
//        }
//    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    
    
    [[PHPhotoLibrary sharedPhotoLibrary]registerChangeObserver:self];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

-(void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary]unregisterChangeObserver:self];
}

-(void)photoLibraryDidChange:(PHChange *)changeInstance
{
    //当设备资源库 有变化时。
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCollectionViewCell * cell = [ImageCollectionViewCell setupCollectionViewCellWith:collectionView and:indexPath];

    
    //通过资源集合创建对应的一个资源。
    PHAsset * asset = self.assetsFetchResults[indexPath.row];
    //判断是否是动图、
    if (asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
        
        UIImage * badge = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
        cell.imageView.image = badge;
        
    }
    else
    {
        //资源加载管理器。
        PHImageManager * imageManager = [[PHImageManager alloc]init];
        [imageManager requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:1 options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            cell.imageView.image = result;
            
        }];
    }
    
    cell.cellIndex = indexPath.row;
    
    cell.delegate = self;
    
    
    if ([self.imageAssetArray containsObject:asset]) {
        
        [cell updateTheCellUI];
    }

    return cell;
}

-(void)onClickTheCellWith:(NSInteger)CellIndex
{
    //选择的图片资源.
    PHAsset * asset = self.assetsFetchResults[CellIndex];
    
    //判断当前选中的图片中是否有这个图。有则去掉。
    if ([self.imageAssetArray containsObject:asset]) {
        
        [self.imageAssetArray removeObject:asset];
    }
    
    else
    {
        [self.imageAssetArray addObject:asset];
    }
    
    //
    self.title = [NSString stringWithFormat:@"当前选中了%d张图",(int)self.imageAssetArray.count];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(100,100);
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
