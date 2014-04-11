//
//  AWYouAreView.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWYouAreView.h"

@implementation AWYouAreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:242.0f/255 green:147.0f/255 blue:30.0f/255 alpha:1.0f];
        [self drawText];
        [self drawImages];
        [self drawSpinners];
        [self drawButtons];
    }
    return self;
}

- (void)drawText
{
    CoreTextArcView *youAreText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-480.0f, self.frame.size.width, 120.0f)];
    youAreText.backgroundColor = [UIColor clearColor];
    youAreText.text = @"You are:";
    youAreText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    youAreText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:48.0f];
    youAreText.radius = 390.0f;
    youAreText.arcSize = 23.0f;
    youAreText.shiftV = -205.0f;
    [self addSubview:youAreText];
    
    self.valueText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-390.0f+10.0f, self.frame.size.width, 120.0f)];
    self.valueText.backgroundColor = [UIColor clearColor];
    self.valueText.text = @"1038441600";
    self.valueText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    self.valueText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:52.0f];
    self.valueText.radius = 300.0f;
    self.valueText.arcSize = 50.0f;
    self.valueText.shiftV = -150.0f;
    [self addSubview:self.valueText];
    
    CoreTextArcView *oldText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-220.0f+10.0f, self.frame.size.width, 120.0f)];
    oldText.backgroundColor = [UIColor clearColor];
    oldText.text = @"Old";
    oldText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    oldText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:52.0f];
    oldText.radius = 125.0f;
    oldText.arcSize = 32.0f;
    oldText.shiftV = -60.0f;
    [self addSubview:oldText];
    
    CoreTextArcView *milestonesText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-135.0f+20.0f, self.frame.size.width, 100.0f)];
    milestonesText.backgroundColor = [UIColor clearColor];
    milestonesText.text = @"+milestones";
    milestonesText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    milestonesText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0f];
    milestonesText.radius = 80.0f;
    milestonesText.arcSize = 110.0f;
    milestonesText.shiftV = -25.0f;
    [self addSubview:milestonesText];
}

- (void)drawImages
{
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home"]];
    homeImageView.frame = CGRectMake((self.frame.size.width-30.0f)/2, self.frame.size.height-35.0f, 30.0f, 30.0f);
    [self addSubview:homeImageView];
}

- (void)drawSpinners
{
    self.incrementSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height-300.0f+10.0f, self.frame.size.width, 120.0f)];
    [self.incrementSpinner setContents:[self incrementSpinnerContents]];
    [self.incrementSpinner setRadius:260.0f];
    [self.incrementSpinner setVerticalShift:460.0f];
    [self.incrementSpinner setFocusedFontSize:32.0f];
    [self.incrementSpinner setUnfocusedFontSize:32.0f];
    [self.incrementSpinner setFocusedFontColor:[UIColor whiteColor]];
    [self.incrementSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
    [self.incrementSpinner setFontName:@"HelveticaNeue-Bold"];
    [self addSubview:self.incrementSpinner];
}

- (void)drawButtons
{
    self.milestonesButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-270.0f)/2, self.frame.size.height-135.0f, 270.0f, 270.0f)];
    self.milestonesButton.layer.cornerRadius = 135.0f;
    [self addSubview:self.milestonesButton];
    
    self.homeButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-120.0f)/2, self.frame.size.height-60.0f, 120.0f, 120.0f)];
    self.homeButton.layer.cornerRadius = 60.0f;
    [self addSubview:self.homeButton];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.0f);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 390.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 229.0f/255, 94.0f/255, 36.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 300.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 239.0f/255, 59.0f/255, 35.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 220.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 226.0f/255, 31.0f/255, 39.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 135.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 189.0f/255, 32.0f/255, 37.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 60.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 128.0f/255, 21.0f/255, 34.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
}

- (NSArray*)incrementSpinnerContents
{
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    [contents addObject:@"Seconds"];
    [contents addObject:@"Minutes"];
    [contents addObject:@"Hours"];
    [contents addObject:@"Days"];
    [contents addObject:@"Weeks"];
    [contents addObject:@"Months"];
    [contents addObject:@"Years"];
    [contents addObject:@"Decades"];
    return contents;
}

@end
