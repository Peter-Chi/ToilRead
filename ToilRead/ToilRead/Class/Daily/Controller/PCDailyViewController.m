//
//  PCDailyViewController.m
//  ToilRead
//
//  Created by Peter on 16/9/1.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "PCDailyViewController.h"
#import <AFNetworking.h>
#import "PCStory.h"
#import "PCDailyViewCell.h"
#import <MJExtension.h>

@interface PCDailyViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** shuju */
@property (nonatomic , strong) NSArray *stories;

@end

@implementation PCDailyViewController

//-(NSArray *)stories
//{
//    if(!_stories) {
//        _stories=[[NSArray alloc]init];
//    }
//    return _stories;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PCDailyViewCell class]) bundle:nil] forCellReuseIdentifier:@"PCDailyViewCell"];
    self.tableView.rowHeight = 100;
    
   
    [[AFHTTPSessionManager manager]GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
       
        self.stories = [PCStory mj_objectArrayWithKeyValuesArray:responseObject[@"stories"]];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCDailyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PCDailyViewCell"];
    
    cell.story = self.stories[indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}



@end
