//
//  ZACircularTableViewCell.m
//  ZACircularTableView
//
//  Created by Zak Avila on 4/9/14.
//  Copyright (c) 2014 Zak Avila. All rights reserved.
//

#import "ZASpinnerTableViewCell.h"

@interface ZASpinnerTableViewCell ()

@end

@implementation ZASpinnerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.circularTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.height, self.frame.size.height)];
        self.circularTextLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        self.circularTextLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.circularTextLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.circularTextLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.height, self.frame.size.height);
}

@end
