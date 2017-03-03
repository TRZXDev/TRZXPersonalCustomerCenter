//
//  ComplaintsViewController.m
//  tourongzhuanjia
//
//  Created by Rhino on 16/5/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "ComplaintsViewController.h"
#import "ComplaintsMsgViewController.h"
#import "zhinanCell.h"
#import "TRZXNetwork.h"
#import "UIViewController+APP.h"


#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]
#define moneyColor [UIColor colorWithRed:209.0/255.0 green:187.0/255.0 blue:114.0/255.0 alpha:1]

@interface ComplaintsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataSource;

@property (nonatomic,assign)NSUInteger index;

@property (nonatomic, strong)UIImageView *tickImageView;

@property (nonatomic, strong) UIButton *rightBtn;


@end

@implementation ComplaintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setNaviBar];
    [self createUI];
}

- (void)initData
{
    self.dataSource = @[@"色情",@"赌博",@"敏感信息",@"欺诈",@"违法"];
}
- (void)setNaviBar{
    self.title = @"投诉";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 83, 43);
    [_rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:moneyColor forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0,30,0,-10);
    [_rightBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)saveAction{
    
    if(!_tickImageView){
//        [LCProgressHUD showMessage:@"请选择投诉原因"];
        return ;
    }
    
    ComplaintsMsgViewController *compVc =[[ComplaintsMsgViewController alloc]init];
    compVc.type = self.type;
    compVc.subType = self.dataSource[self.index];
    compVc.targetId =self.targetId;
    compVc.userTitle = self.userTitle;
    [self.navigationController pushViewController:compVc animated:YES];
}

- (void)createUI
{
    [self.view addSubview:self.tableView];
    UIView *headerView             = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UILabel *lable                 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 24)];
    lable.text                     = @"请选择投诉原因";
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
    zhinanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhinanCell"];
    if (!cell) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"zhinanCell" owner:self options:nil]lastObject];
        
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label1.font = [UIFont systemFontOfSize:15];
    cell.label1.text = self.dataSource[indexPath.row];
    cell.backgroundColor = backColor;
    cell.yzImage.hidden = YES;
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    zhinanCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.index = indexPath.row;
    [cell addSubview:self.tickImageView];
    
}

#pragma mark - setter/getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(UIImageView *)tickImageView{
    if (!_tickImageView) {
        _tickImageView = [[UIImageView alloc]init];
        _tickImageView.image = [UIImage imageNamed:@"RCDComplaints_Selected"];
        _tickImageView.frame = CGRectMake(SCREEN_WIDTH - 30, 15, 15, 15);
    }
    return _tickImageView;
}

- (void)leftBarItemAction:(UIBarButtonItem *)gesture
{
    if(self.navigationController.viewControllers.count>1)
    {
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



@end
