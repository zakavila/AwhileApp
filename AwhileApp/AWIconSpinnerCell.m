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
        
        self.icon = [[UIImageView alloc] initWithFrame:self.frame];
        [self.contentView addSubview:self.icon];
        [self.contentView bringSubviewToFront:self.icon];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.icon.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    if (self.icon.backgroundColor == [UIColor redColor])
        self.icon.bounds = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    else
        self.icon.bounds = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
}

@end
