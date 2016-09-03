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
#import "PCDailyViewCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "DateUtil.h"
#import <SVProgressHUD.h>
#import "PCStoryBodyViewController.h"
#import "PCHeaderView.h"
#import "SDCycleScrollView.h"


@interface PCDailyViewController () <UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


/** 日报 */
@property (nonatomic , strong) NSMutableArray *dailies;

/** 日期 */
@property (nonatomic , strong) NSMutableArray *dates;

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

-(NSMutableArray *)dates
{
    if(!_dates) {
        _dates=[[NSMutableArray alloc]init];
    }
    return _dates;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PCDailyViewCell class]) bundle:nil] forCellReuseIdentifier:@"PCDailyViewCell"];
    self.tableView.rowHeight = 100;
    
    [SVProgressHUD show];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDailies)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDailies)];
    self.tableView.mj_footer.hidden = NO;
   
    [self setCycleScrollView];
   
    }

-(void)setCycleScrollView
{
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    // 情景三：图片配文字
    NSArray *titles = @[@"新建交流QQ群：185534916 ",
                        @"感谢您的支持，如果下载的",
                        @"如果代码在使用过程中出现问题",
                        @"您可以发邮件到gsdios@126.com"
                        ];
    
    CGFloat w = self.view.bounds.size.width;
    
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, w, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
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
    NSLog(@"---点击了第%ld张图片", (long)index);
    
   // [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
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
            self.dates = nil;
            [self.dailies addObject:daily];
            [self.dates addObject:daily.date];
        }
        
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
    NSDate *beforeDate = [[DateUtil stringToDate:self.dates.lastObject format:@"yyyyMMdd"] dateByAddingTimeInterval:-24*60*60];
    NSString *Str = [DateUtil dateString:beforeDate withFormat:@"yyyyMMdd"];
    NSString *urlStr = [NSString stringWithFormat:@"http://news.at.zhihu.com/api/4/news/before/%@",Str];
    
    [self.manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    
        
        PCDailies *daily = [[PCDailies alloc]init];
        daily = [PCDailies mj_objectWithKeyValues:responseObject];
        [self.dailies addObject:daily];
        [self.dates addObject:daily.date];
        
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
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
//设置组名
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"今日热文";
    }
    
    PCDailies *daily=self.dailies[section];
    return [DateUtil dateString:daily.date fromFormat:@"yyyyMMdd" toFormat:@"MM月dd日 EEEE"];
   
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    PCHeaderView* header = [[PCHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
//    PCDailies *daily=self.dailies[section];
//    header.text = [DateUtil dateString:daily.date fromFormat:@"yyyyMMdd" toFormat:@"MM月dd日 EEEE"];
//    
//    return header;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCDailyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PCDailyViewCell"];
    
    PCDailies *daily=self.dailies[indexPath.section];
    PCStory *story=[PCStory mj_objectWithKeyValues:(daily.stories[indexPath.row])];
    cell.story = story;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PCDailies *daily=self.dailies[indexPath.section];
    PCStory *story=[PCStory mj_objectWithKeyValues:(daily.stories[indexPath.row])];
    
    PCStoryBodyViewController *storyB = [[PCStoryBodyViewController alloc]init];
    storyB.id = story.id;

    [self.navigationController pushViewController:storyB animated:YES];
}




@end
