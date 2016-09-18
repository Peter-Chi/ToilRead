//
//  PCDailyViewController.m
//  ToilRead
//
//  Created by Peter on 16/9/1.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "PCDailyViewController.h"
#import <AFNetworking.h>
#import "PCDailies.h"
#import "PCStory.h"
#import "PCTopStory.h"
#import "PCDailyViewCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "DateUtil.h"
#import <SVProgressHUD.h>
#import "PCStoryBodyViewController.h"
#import "PCHeaderView.h"
#import "SDCycleScrollView.h"
#import "UINavigationBar+Awesome.h"


@interface PCDailyViewController () <UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
#define NAVBAR_CHANGE_POINT 100

@property (weak, nonatomic) IBOutlet UITableView *tableView;


/** 日报 */
@property (nonatomic , strong) NSMutableArray *dailies;

/** 网络请求管理者 */
@property (nonatomic , strong) AFHTTPSessionManager *manager;

@end

@implementation PCDailyViewController

-(AFHTTPSessionManager *)manager
{
    if(!_manager) {
        _manager=[[AFHTTPSessionManager alloc]init];
    }
    return _manager;
}

-(NSMutableArray *)dailies
{
    if(!_dailies) {
        _dailies=[[NSMutableArray alloc]init];
    }
    return _dailies;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];

    
    [PCDailies mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"stories" : @"PCStory",
                 // @"statuses" : [Status class],
                 @"top_stories" : @"PCTopStory"
                 // @"ads" : [Ad class]
                 };
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PCDailyViewCell class]) bundle:nil] forCellReuseIdentifier:@"PCDailyViewCell"];
    self.tableView.rowHeight = 100;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [SVProgressHUD show];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDailies)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDailies)];
    self.tableView.mj_footer.hidden = NO;
   
    
    }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];


    [self scrollViewDidScroll:self.tableView];
   // [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    //去掉线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = self;
    [self.navigationController.navigationBar lt_reset];
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:51.0 / 255
                                      green:153.0 / 255
                                       blue:230.0 / 255
                                      alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        self.tableView.delegate = self;
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
    [self adjustNavigationAlpha];
    
}
- (void)adjustNavigationAlpha
{
    NSInteger secondSectionOffsetY =[self.tableView numberOfRowsInSection:0]*100 + 200;
    
  //  NSLog(@"%ld",(long)secondSectionOffsetY);
    if (self.tableView.contentOffset.y > secondSectionOffsetY) {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        //这里不能直接隐藏navigationbar，会导致tableview的insettop失控
        self.navigationItem.title = @"";
        //缩短背景视图避免其挡住section header
        [self.navigationController.navigationBar setBackgroundLayerHeight:20];
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.navigationItem.title = @"今日热闻";
        NSDictionary * attriBute = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]};
        [self.navigationController.navigationBar setTitleTextAttributes:attriBute];
        
        [self.navigationController.navigationBar setBackgroundLayerHeight:64];
    }
}


-(void)setCycleScrollView
{
    
    NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
    
    NSMutableArray *titles = [[NSMutableArray alloc]init];
    
   PCDailies *daily = self.dailies[0];
    for (PCTopStory *ts in daily.top_stories) {
        [imagesURLStrings addObject:ts.image];
        [titles addObject:ts.title];
         };

    
    CGFloat w = self.view.bounds.size.width;
    
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, 220) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    cycleScrollView.titlesGroup = titles;
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    cycleScrollView.autoScrollTimeInterval =5;
    
    self.tableView.tableHeaderView = cycleScrollView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    PCStoryBodyViewController *storyB = [[PCStoryBodyViewController alloc]init];
    PCDailies *daily = self.dailies[0];
    PCTopStory *topS = daily.top_stories[index];
    storyB.id = topS.id;
    
    [self.navigationController pushViewController:storyB animated:YES];
  
}


- (void)loadNewDailies
{
    [self.manager.operationQueue cancelAllOperations ];
    
    
    [self.manager GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
      
        PCDailies *daily = [[PCDailies alloc]init];
        daily = [PCDailies mj_objectWithKeyValues:responseObject];
        
        if (![daily isEqual:self.dailies.firstObject]) {
            self.dailies = nil;
           
            [self.dailies addObject:daily];
       
        }
        
        
        [self setCycleScrollView];

        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载失败，请检查网络"];

    }];
    

}

- (void)loadMoreDailies
{
    
    [self.manager.operationQueue cancelAllOperations];
    
    PCDailies *lastDaily =self.dailies.lastObject;
    

    NSString *Str = lastDaily.date;
   
    NSString *urlStr = [NSString stringWithFormat:@"http://news.at.zhihu.com/api/4/news/before/%@",Str];
    
    [self.manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        PCDailies *newDaily = [[PCDailies alloc]init];
        newDaily = [PCDailies mj_objectWithKeyValues:responseObject];
        [self.dailies addObject:newDaily];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
        [self.tableView.mj_footer endRefreshing];

    }];
    
}


#pragma mark  UITableViewDataSource
//设置多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dailies.count;
}
//设置多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PCDailies *daily=self.dailies[section];
    return daily.stories.count;
}
//设置组名
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return @"今日热文";
//    }
//    
//    PCDailies *daily=self.dailies[section];
//    return [DateUtil dateString:daily.date fromFormat:@"yyyyMMdd" toFormat:@"MM月dd日 EEEE"];
//   
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor colorWithRed:51.0 / 255
                                             green:153.0 / 255
                                              blue:230.0 / 255
                                             alpha:1];
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    PCDailies *daily=self.dailies[section];
    label.text = [DateUtil dateString:daily.date fromFormat:@"yyyyMMdd" toFormat:@"MM月dd日 EEEE"];
    
    [header addSubview:label];
    return header;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0;
    
    return 44;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    
//    UIView* footerView = [[UIView alloc]init];
//    return footerView;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCDailyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PCDailyViewCell"];
    
    PCDailies *daily=self.dailies[indexPath.section];
  
    cell.story = daily.stories[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PCDailies *daily=self.dailies[indexPath.section];
    PCStory *story= daily.stories[indexPath.row];
    
    PCStoryBodyViewController *storyB = [[PCStoryBodyViewController alloc]init];
    storyB.id = story.id;
   

    [self.navigationController pushViewController:storyB animated:YES];
}




@end
