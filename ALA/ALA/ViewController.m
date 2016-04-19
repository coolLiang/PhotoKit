//
//  ViewController.m
//  ALA
//
//  Created by noci on 16/4/18.
//  Copyright © 2016年 noci. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

#import "ImageCollectionViewController.h"

@interface ViewController ()<PHPhotoLibraryChangeObserver,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray * resultsArray;

@property(nonatomic,strong)UITableView * imageTableView;

@end

@implementation ViewController

static NSString * const AllPhotosReuseIdentifier = @"all";
static NSString * const CollectionCellReuseIdentifier = @"smart";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.imageTableView.delegate = self;
    self.imageTableView.dataSource = self;
    [self.view addSubview:self.imageTableView];
    
    
    
    [self getImageGroup];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)getImageGroup
{
    //条件对象
    PHFetchOptions * allPhotosOptions = [[PHFetchOptions alloc]init];
    
    //降序排列
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    //所有图片的集合
    PHFetchResult * allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    //智能分组图片集合
    PHFetchResult * smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    //自定分组图片集合
    PHFetchResult * diyAlbums = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
    
    self.resultsArray = @[allPhotos,smartAlbums,diyAlbums];
    
    //注册监听。监听图片库的变化。
    [[PHPhotoLibrary sharedPhotoLibrary]registerChangeObserver:self];
    
}

//监听方法  有改变时..
-(void)photoLibraryDidChange:(PHChange *)changeInstance
{
    
}


-(void)dealloc
{
    //移除监听
    [[PHPhotoLibrary sharedPhotoLibrary]unregisterChangeObserver:self];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.resultsArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }
    else
    {
        //每种集合下的分组数量
        PHFetchResult * fetchResult = self.resultsArray[section];
        return fetchResult.count;
    }
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = nil;
    
    static NSString * ID1 = @"all";
    static NSString * ID2 = @"smart";
    
    if (indexPath.section == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
            
        }
         cell.textLabel.text = @"all";
        
        
    } else {
        
        //智能模式下的所有分组
        PHFetchResult *fetchResult = self.resultsArray[indexPath.section];
        //单一分组数据
        PHCollection *collection = fetchResult[indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID2];
        }
        
        //每个分组的名称.
        cell.textLabel.text = collection.localizedTitle;
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        //all photos
        ImageCollectionViewController * image = [[ImageCollectionViewController alloc]init];
        //将所有图片资源集合 传入。
        image.assetsFetchResults = self.resultsArray[0];
        [self.navigationController pushViewController:image animated:YES];
        
    }
    
    //智能分组。or 自定义分组.
    else {
        
        //取出响应的智能分组结果集。
        PHFetchResult * result = self.resultsArray[indexPath.section];
        //通过分组索引 取出相应分组内部的结果集。
        PHCollection * collection = result[indexPath.row];
        //判断。
        if (![collection isKindOfClass:[PHAssetCollection class]]) {
            return;
        }
        //强转为子类。
        PHAssetCollection * assetCollection = (PHAssetCollection *)collection;
        //根据分组资源 获取 响应的 图片资源结果集
        PHFetchResult * assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        
        ImageCollectionViewController * image = [[ImageCollectionViewController alloc]init];
        //将所有图片资源集合 传入。
        image.assetsFetchResults = assetsFetchResult;
        image.assetCollection = assetCollection;
        
        [self.navigationController pushViewController:image animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
