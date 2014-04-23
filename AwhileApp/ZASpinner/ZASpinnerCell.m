//
//  ZACircularTableViewCell.m
//  ZACircularTableView
//
//  Created by Zak Avila on 4/9/14.
//  Copyright (c) 2014 Zak Avila. All rights reserved.
//

#import "ZASpinnerCell.h"

@interface ZASpinnerCell ()

@end

@implementation ZASpinnerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
										 
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.contentView.bounds = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
}

@end
