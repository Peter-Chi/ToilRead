//
//  PCStoryBody.h
//  ToilRead
//
//  Created by Peter on 16/9/3.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCStoryBody : NSObject
/** body */
@property (nonatomic , copy) NSString *body;

/** image */
@property (nonatomic , copy) NSString *image;

/** css */
@property (nonatomic , strong) NSArray *css;
@end
