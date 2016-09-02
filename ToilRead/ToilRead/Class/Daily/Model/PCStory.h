//
//  PCStory.h
//  ToilRead
//
//  Created by Peter on 16/9/2.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCStory : NSObject

/** id */
@property (nonatomic , copy) NSString *id;

/** title */
@property (nonatomic , copy) NSString *title;

/** image */
@property (nonatomic , strong) NSArray *images;

@end
