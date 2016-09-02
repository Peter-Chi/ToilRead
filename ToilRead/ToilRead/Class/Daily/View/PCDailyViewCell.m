//
//  PCDailyViewCell.m
//  ToilRead
//
//  Created by Peter on 16/9/2.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "PCDailyViewCell.h"
#import "PCStory.h"
#import <UIImageView+WebCache.h>

@interface PCDailyViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iamgeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PCDailyViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setStory:(PCStory *)story
{
    _story = story;
  
    [self.iamgeImageView sd_setImageWithURL:[NSURL URLWithString:story.images[0]]];
    
    self.titleLabel.text = story.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
