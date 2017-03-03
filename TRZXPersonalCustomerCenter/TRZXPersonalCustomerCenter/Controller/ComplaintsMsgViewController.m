//
//  ComplaintsMsgViewController.m
//  tourongzhuanjia
//
//  Created by Rhino on 16/5/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "ComplaintsMsgViewController.h"
#import "ComplaintsTitleTableViewCell.h"
#import "AJPhotoPickerViewController.h"
#import "TRZXKit.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AJPhotoBrowserViewController.h"
//#import "ComPlaintsChooseChatMsgViewController.h"

#import "TRZXNetwork.h"
#import "UIViewController+APP.h"
#import <AVFoundation/AVFoundation.h>



#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define moneyColor [UIColor colorWithRed:209.0/255.0 green:187.0/255.0 blue:114.0/255.0 alpha:1]

static NSInteger photoCount = 9;

@interface ComplaintsMsgViewController ()<UITableViewDelegate,UITableViewDataSource,AJPhotoPickerProtocol,AJPhotoBrowserDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    ComplaintsTitleTableViewCell *firstCell;
    ComplaintsTitleTableViewCell *secondCell;
}


@property (nonatomic,strong) UITableView      *tableView;
@property (nonatomic,strong) NSArray          *dataSource;
@property (weak, nonatomic ) UICollectionView *collectionview;
@property (nonatomic,strong) NSMutableArray   *photoArray;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation ComplaintsMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = 1;
    [self initData];
    [self setNaviBar];
    [self createUI];
}

- (void)initData
{
    if (self.type == 1) {
    self.dataSource = @[@"图片证据",@""];
    }else if(self.type == 2)
    {
    self.dataSource = @[@"聊天记录",@"图片证据",@""];
    }
}

- (void)setNaviBar
{
    self.title = @"投诉";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 83, 43);
    [_rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:moneyColor forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0,40,0,10);
    [_rightBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)createUI
{
    [self.view addSubview:self.tableView];
    UIView *headerView             = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UILabel *lable                 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 24)];
    lable.text                     = @"请举证";
    lable.font                     = [UIFont systemFontOfSize:14];
    lable.textColor                = zideColor;
    [headerView addSubview:lable];
    self.tableView.tableHeaderView = headerView;
    
}

#pragma mark - cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        
        if (indexPath.row == 1) {
            return [self tableView:tableView cellForChoosePhotos:indexPath];
        }else
        {
            return [self tableView:tableView cellForTitle:indexPath];
        }
    }else
    {
        if (indexPath.row == 2) {
            return [self tableView:tableView cellForChoosePhotos:indexPath];
        }else
        {
            return [self tableView:tableView cellForTitle:indexPath];
        }
    }
    return [UITableViewCell new];
    
}
- (ComplaintsTitleTableViewCell *)tableView:(UITableView *)tableView cellForTitle:(NSIndexPath *)indexPath
{
    ComplaintsTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ComplaintsTitleTableViewCell" owner:self options:nil] firstObject];
    }
    
    cell.titlesLabel.text = self.dataSource[indexPath.row];
    if (self.photoArray.count > 0) {
        cell.statusLable.text = [NSString stringWithFormat:@"%ld张",(unsigned long)self.photoArray.count];
    }
    
    cell.titlesLabel.textColor = heizideColor;
    cell.titlesLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == 0) {
        firstCell = cell;
    }else if (indexPath.row == 1)
    {
        secondCell = cell;
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForChoosePhotos:(NSIndexPath *)indexPath
{
    //照片
    UITableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:@"photos"];
    if (cells == nil) {
        cells = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"photos"];
    }
    cells.contentView.backgroundColor = backColor;
    for (UIView *view in cells.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
//    SCREEN_WIDTH/3 * 3+7.5*2+10
    UICollectionView *collec = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4 + 7.5*2+20) collectionViewLayout:flow];
    collec.backgroundColor = [UIColor whiteColor];
    collec.delegate = self;
    collec.dataSource  =self;
    self.collectionview = collec;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"midCell"];
    [cells.contentView addSubview:self.collectionview];
    cells.selectionStyle = UITableViewCellSelectionStyleNone;
    return cells;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == 1) {
        [self presentPhotoCheckOver];
    }else
    {
        if (indexPath.row == 0) {
            //聊天记录
//            ComPlaintsChooseChatMsgViewController *chat =[[ComPlaintsChooseChatMsgViewController alloc]init];
//            chat.targetId                      = self.targetId;
//            chat.userName                      = self.userTitle;
//            chat.conversationType              = ConversationType_PRIVATE;
//            chat.title                         = self.userTitle;
//            
//            [self.navigationController pushViewController:chat animated:YES];
            
        }else if(indexPath.row == 1)
        {
            [self presentPhotoCheckOver];
        }
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        if (indexPath.row == 1) {
            return SCREEN_WIDTH/3 * 3+7.5*2+10;
        }
    }else if(self.type == 2)
    {
        if (indexPath.row == 2) {
            return SCREEN_WIDTH/3 * 3+7.5*2+10;
        }
    }
    return 44;
}

- (void)presentPhotoCheckOver
{
    if (self.photoArray.count == photoCount) {
        NSString *string = [NSString stringWithFormat:@"最多选择%ld张照片哦~~",photoCount - self.photoArray.count];
        UIAlertView *alertM = [[UIAlertView alloc] initWithTitle:@"" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertM show];
        return;
    }
    [self presentChoosePhoto];
}

- (UIImage*)imageWithImage :( UIImage*)image scaledToSize :(CGSize)newSize;

{
    
    // Create a graphics image context
    
    UIGraphicsBeginImageContext(newSize);
    
    
    
    // Tell the old image to draw in this new context, with the desired
    
    // new size
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    
    
    // Get the new image from the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    // End the context
    
    UIGraphicsEndImageContext();
    
    
    
    // Return the new image.
    
    return newImage;
    
}
#pragma mark -collectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"midCell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *im = [[UIImageView alloc] initWithFrame:cell.bounds];
    
    im.contentMode = UIViewContentModeScaleAspectFill;
    im.layer.masksToBounds = YES;
    im.userInteractionEnabled  = YES;
    if (indexPath.row == self.photoArray.count && self.photoArray.count != photoCount) {
        im.image = [UIImage imageNamed:@"AlbumAddBtn"];
    }else{
        im.image = self.photoArray[indexPath.row];
    }
    
    [cell.contentView addSubview:im];
    
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.photoArray.count == 9) {
        return self.photoArray.count;
    }
    return self.photoArray.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_WIDTH/3 - 7.5, SCREEN_WIDTH/3 - 7.5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 7.5;
}
//最多9张图片
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.row == self.photoArray.count) {
        [self presentPhotoCheckOver];
    }else
    {
        [self showBig:indexPath.row];
    }
}
#pragma mark - 照片选择
- (void)presentChoosePhoto
{
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    picker.maximumNumberOfSelection = photoCount - self.photoArray.count;
    picker.multipleSelection = YES;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BoPhotoPickerProtocol-----------选择照片-------
//取消选中
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//选中
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    
    for (int i = 0; i <assets.count; i ++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [self.photoArray insertObject:tempImg atIndex:0];
        if (self.photoArray.count > photoCount) {
            [self.photoArray removeLastObject];
        }
    }
    
    CGFloat height = SCREEN_WIDTH/3 * (((int)self.photoArray.count / 3)+1) + 7.5*2+10;
    self.collectionview.height = height;
    [self.collectionview reloadData];
    if (self.type == 1) {
        secondCell = firstCell;
    }
    if (self.photoArray.count == 0) {
       secondCell.statusLable.text = @"未选择";
    }else{
       secondCell.statusLable.text = [NSString stringWithFormat:@"%ld张",(unsigned long)self.photoArray.count];
    }

    [picker dismissViewControllerAnimated:NO completion:nil];
}
//超过最大选择项时
- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker {

    NSString *string = [NSString stringWithFormat:@"最多只能选择%ld张照片哦~~",photoCount - self.photoArray.count];
    UIAlertView *alertM = [[UIAlertView alloc] initWithTitle:@"" message:string delegate:picker cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alertM show];
}
//点击相册
- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker {
    [self checkCameraAvailability:^(BOOL auth) {
        if (!auth) {

            UIAlertView *alertM = [[UIAlertView alloc] initWithTitle:@"" message:@"没有访问相机权限~~" delegate:picker cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertM show];
            return;
        }
        
        [picker dismissViewControllerAnimated:NO completion:nil];
        UIImagePickerController *cameraUI = [UIImagePickerController new];
        cameraUI.allowsEditing = NO;
        cameraUI.delegate = self;
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
        
        [self presentViewController: cameraUI animated: YES completion:nil];
    }];
}
- (void)checkCameraAvailability:(void (^)(BOOL auth))block {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                if (block) {
                    block(granted);
                }
            } else {
                if (block) {
                    block(granted);
                }
            }
        }];
        return;
    }
    if (block) {
        block(status);
    }
}
//使用照片--拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage;
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (self.photoArray.count<photoCount) {
        [self.photoArray addObject:originalImage];
    }else
    {   [self.photoArray removeObjectAtIndex:0];
        [self.photoArray addObject:originalImage];
    }
    if (self.type == 1) {
        secondCell = firstCell;
    }
    if (self.photoArray.count == 0) {
        secondCell.statusLable.text = @"未选择";
    }else
    {
        secondCell.statusLable.text = [NSString stringWithFormat:@"%ld张",(unsigned long)self.photoArray.count];
    }
    CGFloat height = SCREEN_WIDTH/3 * (((int)self.photoArray.count / 3)+1) + 7.5*2+10;
    self.collectionview.height = height;
    [self.collectionview reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---------------------图片浏览器相关----------------------~```````````````````````````````````
#pragma mark --删除按钮被点击
- (void)photoBrowser:(AJPhotoBrowserViewController *)vc deleteWithIndex:(NSInteger)index
{
    [self.photoArray removeObjectAtIndex:index];
    if (self.type == 1) {
        secondCell = firstCell;
    }
    if (self.photoArray.count == 0) {
        secondCell.statusLable.text = @"未选择";
    }else
    {
        secondCell.statusLable.text = [NSString stringWithFormat:@"%ld张",(unsigned long)self.photoArray.count];
    }
    CGFloat height = SCREEN_WIDTH/3 * (((int)self.photoArray.count / 3)+1) + 7.5*2+10;
    self.collectionview.height = height;
    [self.collectionview reloadData];
}
#pragma mark ---点击完成按钮
- (void)photoBrowser:(AJPhotoBrowserViewController *)vc didDonePhotos:(NSArray *)photos {
    [vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---弹出图片浏览器
- (void)showBig:(NSInteger)index
{
    AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:self.photoArray index:index];
    photoBrowserViewController.delegate = self;
    [self presentViewController:photoBrowserViewController animated:YES completion:nil];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(7.5/2, 7.5/2, 7.5/2, 7.5/2);
}

#pragma maek - 提交按钮点击事件~~~++++++++++++++++++++++++++++++++++++++++++++++
- (void)saveAction
{

    NSString *messageAlert;
    if (self.type == 0) {
        //指南----->>>>
        if (self.photoArray.count == 0) {
            messageAlert = @"请上传图片证据";
            [self alertWithTitle:@"" message:messageAlert];
            return;
        }
    }else
    {
        //聊天----->>>>
        if (self.photoArray.count == 0 && self.chatMsgArray.count == 0  ) {
            messageAlert = @"请上传相关信息";
            [self alertWithTitle:@"" message:messageAlert];
            return;
        }
    }
    
   [self postData];
}
#pragma mark - 上传数据---------------------------------------------------------------------------------
- (void)postData
{
//    NSDictionary *params = @{
//                             @"requestType":@"Complaint_Api",
//                             @"reason":reason?reason:self.subType,//
//                             @"beComplaintId":beComplaintId?beComplaintId:self.targetId//
//                             };
//    [TRZXNetwork uploadWithImage:<#(UIImage *)#> url:<#(NSString *)#> name:<#(NSString *)#> type:<#(NSString *)#> params:<#(NSDictionary *)#> progressBlock:<#^(int64_t bytesRead, int64_t totalBytes)progressBlock#> callbackBlock:^(id object, NSError *error) {
//
//        
//        if ([json[@"status_code"] isEqualToString:@"200"]) {
//            
//            NSArray *array = self.navigationController.viewControllers;
//            UIViewController *viewController = array[array.count-3];
//            [self.navigationController popToViewController:viewController animated:YES];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
    
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertM = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alertM show];
}
#pragma mark - setter/getter------------------------------------------------------------------------
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = backColor;
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)setChatMsgArray:(NSArray *)chatMsgArray
{
    _chatMsgArray = chatMsgArray;
    if (firstCell == nil) {
        if (self.chatMsgArray.count == 0) {
            firstCell.statusLable.text = @"未选择";
        }else
        {
            firstCell.statusLable.text = [NSString stringWithFormat:@"%ld条消息",(unsigned long)self.chatMsgArray.count];
        }
    }
}

//照片
- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
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
