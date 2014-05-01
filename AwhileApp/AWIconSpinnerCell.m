//
//  AWIconSpinnerCell.m
//  AwhileApp
//
//  Created by Zak Avila on 4/22/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWIconSpinnerCell.h"

@implementation AWIconSpinnerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.icon];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.icon.frame = CGRectMake(0.0f, 0.0f, self.icon.bounds.size.width, self.icon.bounds.size.height);
    self.icon.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
    self.icon.center = self.contentView.center;
}

@end
