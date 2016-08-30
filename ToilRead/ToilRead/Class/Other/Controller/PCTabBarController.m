//
//  PCTabBarController.m
//  ToilRead
//
//  Created by Peter on 16/8/31.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "PCTabBarController.h"
#import "PCNavigationController.h"

@interface PCTabBarController ()

@end

@implementation PCTabBarController

+ (void)initialize
{
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
// 添加子控制器
    [self setupChildVc:[[UIViewController alloc] init] title:@"日报" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    [self setupChildVc:[[UIViewController alloc] init] title:@"微博" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    [self setupChildVc:[[UIViewController alloc] init] title:@"段子" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    [self setupChildVc:[[UIViewController alloc] init] title:@"我" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];


}

- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    vc.view.backgroundColor = [UIColor redColor];
    // vc.tabBarItem.badgeValue =@"1";//未读消息提醒数字
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    PCNavigationController *nav = [[PCNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
