//
//  PCMainViewController.m
//  ToilRead
//
//  Created by Peter on 16/8/30.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "PCMainViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "PCTabBarController.h"

@interface PCMainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabelView;

@end

@implementation PCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.mainImageView.image =[UIImage imageNamed:@"mainPlaceHold"];
    
    [[AFHTTPSessionManager manager]GET:@"http://news-at.zhihu.com/api/4/start-image/720*1184" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *url =responseObject[@"img"];
        
        [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:url] ];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.mainImageView.image =[UIImage imageNamed:@"mainPlaceHold"];
    }];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:4 animations:^{
        self.mainImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
    void(^delayedBlock)() = ^{
       // if (!self.mainViewControllerShown) {
        PCTabBarController *vc = [[PCTabBarController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    };
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), delayedBlock);
    
    }

@end
