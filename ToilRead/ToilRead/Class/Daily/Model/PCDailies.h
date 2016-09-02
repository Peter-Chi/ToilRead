//
//  PCDailies.h
//  ToilRead
//
//  Created by Peter on 16/9/2.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCDailies : NSObject

/** date */
@property (nonatomic , copy) NSString *date;
/** story */
@property (nonatomic , strong) NSArray *stories;

@end
