//
//  AWSArcTextSpinnerCell.m
//  AwhileApp
//
//  Created by Zak Avila on 4/22/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWArcTextSpinnerCell.h"

@implementation AWArcTextSpinnerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.circularArcText = [[CoreTextArcView alloc] initWithFrame:self.frame];
        self.circularArcText.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.circularArcText];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.circularArcText.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.circularArcText.bounds = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
}

@end
