//
//  PCTopStory.h
//  ToilRead
//
//  Created by Peter on 16/9/3.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCTopStory : NSObject
/** id */
@property (nonatomic , assign) NSNumber *id;

/** title */
@property (nonatomic , copy) NSString *title;

/** image */
@property (nonatomic , copy) NSString *image;
@end
