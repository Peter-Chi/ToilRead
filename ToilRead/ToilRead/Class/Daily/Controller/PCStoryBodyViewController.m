//
//  PCStoryBodyViewController.m
//  ToilRead
//
//  Created by Peter on 16/9/3.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "PCStoryBodyViewController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "PCStoryBody.h"
#import <MJExtension.h>
#import "UINavigationBar+Awesome.h"

@interface PCStoryBodyViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation PCStoryBodyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];

    
   // self.hidesBottomBarWhenPushed = YES;
   // self.hidesBottomBarWhenPushed = YES;
   // self.tabBarController.tabBar.hidden = YES;


    self.navigationItem.title = @"";
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    UIImageView *grayLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-gray-small"]];
    grayLogoImageView.frame = CGRectMake((self.view.frame.size.width - 65) / 2.0, 20, 65, 65);
    [self.webView insertSubview:grayLogoImageView atIndex:0];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.webView.scrollView addSubview:self.imageView];
    
    [SVProgressHUD show];
    
    
    NSString *String = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%@",self.id];
    [[AFHTTPSessionManager manager]GET:String parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        PCStoryBody *storyB = [[PCStoryBody alloc]init];
        storyB = [PCStoryBody mj_objectWithKeyValues:responseObject];
        
        NSString *compoundHTML = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=\"%@\"></head><body>%@</body></html>", storyB.css.lastObject, storyB.body];
        [self.webView loadHTMLString:compoundHTML baseURL:nil];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:storyB.image]];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}


@end
