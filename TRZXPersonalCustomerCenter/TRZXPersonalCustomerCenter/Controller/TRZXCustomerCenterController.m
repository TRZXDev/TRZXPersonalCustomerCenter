//
//  TRZXCustomerCenterController.m
//  TRZXPersonalCustomerCenter
//
//  Created by 张江威 on 2017/2/24.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "TRZXCustomerCenterController.h"
#import "zhinanCell.h"

#import "GuanYuWoMenVC.h"
#import "ZhiNanBangZhuCellVC.h"
#import "ComplaintsViewController.h"


/** 主题颜色 */
#define TRZXMainColor [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]

@interface TRZXCustomerCenterController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic)NSArray *dataArr;

@property (strong, nonatomic)UIButton *backBtn;;

@property (nonatomic, strong) NSString *appKey;
/// 自定义反馈界面配置，在创建反馈界面前设置
@property (nonatomic, strong, readwrite) NSDictionary *customPlist;
@property (nonatomic,strong)NSNumber *count;

@end

@implementation TRZXCustomerCenterController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服中心";
    [self createUI];

}
- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = backColor;
    [self.view addSubview:_tableView];
    _dataArr = @[@"关于我们",@"使用帮助",@"投诉",@"客服电话"];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.scrollEnabled = NO;
    
}

#pragma mark - UITableViewDeleagte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2||indexPath.row == 3) {
        return 55;
    }else{
        return 45;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    zhinanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhinanCell"];
    if (!cell) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"zhinanCell" owner:self options:nil]lastObject];
        
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label1.text = _dataArr[indexPath.row];
    if ([_dataArr[indexPath.row] isEqualToString:@"客服电话"]) {
        cell.label1.font = [UIFont boldSystemFontOfSize:17];
    }else{
        cell.label1.font = [UIFont systemFontOfSize:15];
    }
    cell.backgroundColor = backColor;
    
    return cell;
}
#pragma mark -cell 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //行被选中后，自动变回反选状态的方法
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        GuanYuWoMenVC * guanyuwomen = [[GuanYuWoMenVC alloc] init];
        guanyuwomen.panduanStr = @"guanyu";
        [self.navigationController pushViewController:guanyuwomen animated:YES];
    }
    if (indexPath.row == 1){
        ZhiNanBangZhuCellVC * bangzhu = [[ZhiNanBangZhuCellVC alloc] init];
        [self.navigationController pushViewController:bangzhu animated:YES];
    }
    if (indexPath.row == 2){
        ComplaintsViewController * jubao = [[ComplaintsViewController alloc] init];
        jubao.type = ComplaintsType_Setting;
        [self.navigationController pushViewController:jubao animated:YES];
    }
    if (indexPath.row == 3){
        
        
        [self openScheme:@"tel://4006781693"];
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认拨打" message:@"400-678-1693" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        //        alert.tag = 601;
        //        [alert show];
    }
}


- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Typical usage




//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //如果有多个alertView，需要通过tag值区分
//    //一个警告框里通过buttonIndex来区分点击的是哪个按钮
//    if (alertView.tag == 601) {
//        if (buttonIndex == 0) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006781693"]];
//        }
//    }
//}


#pragma mark -userFeedBack
- (void)click{
    
    //    self.environment = YWEnvironmentRelease;
    
    self.appKey = @"23344831";
    
    //    self.feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:self.appKey];
    
    //    _feedbackKit.environment = self.environment;
    
    //#warning 设置App自定义扩展反馈数据
    //    _feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
    //                             @"visitPath":@"登陆->关于->反馈",
    //                             @"应用自定义扩展信息":@"开发者可以根据需要设置不同的自定义信息，方便在反馈系统中查看"};
    //#warning 自定义反馈页面配置
    //    _feedbackKit.customUIPlist = [NSDictionary dictionaryWithObjectsAndKeys:@"/te\'st\\Value1\"", @"testKey1", @"test<script>alert(\"error.yaochen\")</alert>Value2", @"testKey2", nil];
    //
    //    _feedbackKit.hideContactInfoView = YES;
    //
    NSString *URL= @"" == nil ?@"":@"";//个人头像先默认
    self.customPlist = @{@"bgColor":@"#d1bb72",@"color":@"#ffffff",@"avatar":URL,@"toAvatar":@""
                         };
    //    _feedbackKit.customUIPlist = self.customPlist;
    //可使用自定义配置：
    ////        _feedbackKit.customUIPlist = @{@"bgColor":@"#d1bb72",//消息气泡背景色
    //                                       @"color":@"#ffffff",//消息内容文字颜色
    //                                       @"avatar":URL,//当前登录账号的头像,string，为http url
    //    //                                   @"toAvatar":@"",//客服账号的头像,string，为http url
    //                                       @"themeColor":@"#d7000f",//标题栏自定义颜色
    //                                       @"profilePlaceholder": @"联系方式",
    //                                       @"chatInputPlaceholder": @"您的反馈建议",
    //                                       @"profileUpdatePlaceholder": @"联系方式",
    //                                       @"profileUpdateCancelBtnText": @"取消",
    //                                       @"profileUpdateConfirmBtnText": @"确定",
    ////                                       @"sendBtnText": @"发消息",
    ////                                       @"sendBtnTextColor": @"white",
    ////                                       @"sendBtnBgColor": @"red",
    //                                       @"hideLoginSuccess": @(YES),//隐藏登录成功的toast
    //                                       @"profileTitle":@"联系方式",
    //                                       @"profileUpdateTitle":@"您的联系方式",
    //                                       @"profileUpdateDesc":@"欢迎您的反馈建议"};
    
}
- (void)loadMessageCount
{
    //    [_feedbackKit getUnreadCountWithCompletionBlock:^(NSNumber *unreadCount, NSError *error) {
    //        if ( error == nil ) {
    //
    //            NSInteger count = [unreadCount integerValue];
    //            if (count >0) {
    //                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    //                zhinanCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //
    //                cell.zhanshiLabel.text = [NSString stringWithFormat:@"%@条",unreadCount];
    //                cell.zhanshiLabel.textColor = TRZXMainColor;
    //                cell.zhanshiLabel.textAlignment = NSTextAlignmentRight;
    //            }
    //
    //        } else {
    //            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
    //            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title description:nil
    //                                                                  type:TWMessageBarMessageTypeError];
    //        }
    //    }];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    zhinanCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.zhanshiLabel.text = [NSString stringWithFormat:@"%@",self.count];
    cell.zhanshiLabel.textColor = TRZXMainColor;
    cell.zhanshiLabel.textAlignment = NSTextAlignmentRight;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


//- (void)_openFeedbackViewController
//{
//    __weak typeof(self) weakSelf = self;
//
//    [_feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
//        if ( viewController != nil ) {
////#warning 这里可以设置你需要显示的标题
//            viewController.title = @"建议反馈";
//
//
//            [viewController.navigationController.navigationBar setHidden:YES];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
//            viewController.navigationItem.backBarButtonItem = nil;
//
//            [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TRZXMainColor,UITextAttributeTextColor,nil]];
//
//            [weakSelf presentViewController:nav animated:YES completion:nil];
//
//            _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [_backBtn setAdjustsImageWhenHighlighted:NO];
//            [_backBtn setTitleColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1]  forState:UIControlStateNormal];
//            [_backBtn setTitle:@"关闭" forState:UIControlStateNormal];
//            _backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//            [_backBtn addTarget:weakSelf action:@selector(actionQuitFeedback) forControlEvents:UIControlEventTouchUpInside];
//            _backBtn.frame = CGRectMake(0, 0, 40, 43);
//
//            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_backBtn];
//
//            __weak typeof(nav) weakNav = nav;
//
//            [viewController setOpenURLBlock:^(NSString *aURLString, UIViewController *aParentController) {
//
//                UIViewController *webVC = [[UIViewController alloc] initWithNibName:nil bundle:nil];
//
//                UIWebView *webView = [[UIWebView alloc] initWithFrame:webVC.view.bounds];
//                webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//
//                [webVC.view addSubview:webView];
//                [weakNav pushViewController:webVC animated:YES];
//                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aURLString]]];
//            }];
//        } else {
//            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
//            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title description:nil
//                                                                  type:TWMessageBarMessageTypeError];
//        }
//    }];
//}

- (void)customerLeft
{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setAdjustsImageWhenHighlighted:NO];
    //    [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //    [_backBtn.layer setCornerRadius:15.0];
    //    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(14,10,12,63);
    //    _backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    //    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    //    [_backBtn setTitleColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1]  forState:UIControlStateNormal];
    //    _backBtn.titleEdgeInsets = UIEdgeInsetsMake(15,0,11,25);
    //    [_backBtn addTarget:weakSelf action:@selector(actionQuitFeedback) forControlEvents:UIControlEventTouchUpInside];
    //    _backBtn.frame = CGRectMake(0, 0, 83, 43);
    //    [viewController.navigationController.navigationBar addSubview:_backBtn];
    
    
}
- (void)actionQuitFeedback
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    zhinanCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.zhanshiLabel.text = @"";
    cell.zhanshiLabel.textColor = TRZXMainColor;
    cell.zhanshiLabel.textAlignment = NSTextAlignmentRight;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)goBackView:(UIButton *)sender{
    
    [[self navigationController] popViewControllerAnimated:YES];
}
- (void)actionCleanMemory:(id)sender
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end

