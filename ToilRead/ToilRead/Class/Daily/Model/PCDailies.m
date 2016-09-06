//
//  PCDailies.m
//  ToilRead
//
//  Created by Peter on 16/9/2.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "PCDailies.h"

@implementation PCDailies

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"stories":@"PCStory",
             @"top_stories":@"PCTopStory",
             };
}

@end
