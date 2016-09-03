//
//  PCHeaderView.m
//  ToilRead
//
//  Created by Peter on 16/9/3.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "PCHeaderView.h"
@interface PCHeaderView()
/** 文字标签 */
@property (nonatomic, weak) UILabel *label;
@end

@implementation PCHeaderView

//- (UILabel*)label
//{
//    if (_label == nil) {
//        _label = [[UILabel alloc] init];
//    }
//    return _label;
//}

- (void)setText:(NSString*)text
{
    if (_text != text) {
        _text = [text copy];
        [self buildHeaderView];
    }
}

- (void)buildHeaderView
{
    self.contentView.backgroundColor = [UIColor blueColor];
    self.label.frame = self.frame;
    self.label.text = self.text;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor whiteColor];
    
    [self addSubview:self.label];
}
@end
