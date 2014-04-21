//
//  AWMilestoneView.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWMilestoneView.h"
#import "CoreTextArcView.h"

@implementation AWMilestoneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self drawText];
        [self drawImages];
        [self drawSpinners];
        [self drawButtons];
    }
    return self;
}

- (void)drawText
{
    CoreTextArcView *tellMeText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-480.0f, self.frame.size.width, 120.0f)];
    tellMeText.backgroundColor = [UIColor clearColor];
    tellMeText.text = @"Tell me:";
    tellMeText.color = [UIColor colorWithRed:199.0f/255 green:168.0f/255 blue:207.0f/255 alpha:1.0f];
    tellMeText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:54.0f];
    tellMeText.radius = 390.0f;
    tellMeText.arcSize = 25.0f;
    tellMeText.shiftV = -205.0f;
    [self addSubview:tellMeText];
    
    CoreTextArcView *beforeText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-255.0f+10.0f, self.frame.size.width, 120.0f)];
    beforeText.backgroundColor = [UIColor clearColor];
    beforeText.text = @"Before:";
    beforeText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    beforeText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:46.0f];
    beforeText.radius = 195.0f;
    beforeText.arcSize = 40.0f;
    beforeText.shiftV = -75.0f;
    [self addSubview:beforeText];
    
    CoreTextArcView *addText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-135.0f+20.0f, self.frame.size.width, 100.0f)];
    addText.backgroundColor = [UIColor clearColor];
    addText.text = @"+Add";
    addText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    addText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f];
    addText.radius = 70.0f;
    addText.arcSize = 40.0f;
    addText.shiftV = -45.0f;
    [self addSubview:addText];
}

- (void)drawImages
{
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home"]];
    homeImageView.frame = CGRectMake((self.frame.size.width-20.0f)/2, self.frame.size.height-25.0f, 20.0f, 20.0f);
    [self addSubview:homeImageView];
}

- (void)drawSpinners
{
    self.valueSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height-385.0f+5.0f, self.frame.size.width, 120.0f)];
    [self.valueSpinner setContents:[self daySpinnerContents]];
    [self.valueSpinner setRadius:390.0f];
    [self.valueSpinner setVerticalShift:700.0f];
//    [self.valueSpinner setFocusedFontSize:44.0f];
//    [self.valueSpinner setUnfocusedFontSize:44.0f];
    [self.valueSpinner setFocusedFontColor:[UIColor whiteColor]];
    [self.valueSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
//    [self.valueSpinner setFontName:@"HelveticaNeue-Bold"];
    [self addSubview:self.valueSpinner];
    
    self.incrementSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height-320.0f+10.0f, self.frame.size.width, 120.0f)];
    [self.incrementSpinner setContents:[self incrementSpinnerContents]];
    [self.incrementSpinner setRadius:220.0f];
    [self.incrementSpinner setVerticalShift:360.0f];
    [self.incrementSpinner setExtraSpacing:15.0f];
//    [self.incrementSpinner setFocusedFontSize:38.0f];
//    [self.incrementSpinner setUnfocusedFontSize:38.0f];
    [self.incrementSpinner setFocusedFontColor:[UIColor whiteColor]];
    [self.incrementSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
//    [self.incrementSpinner setFontName:@"HelveticaNeue-Bold"];
    [self addSubview:self.incrementSpinner];
    
    self.daySpinner = [[ZASpinnerView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height-195.0f, self.frame.size.width, 195.0f)];
    [self.daySpinner setContents:[self daySpinnerContents]];
    [self.daySpinner setRadius:190.0f];
    [self.daySpinner setVerticalShift:135.0f];
    [self.daySpinner setExtraSpacing:0.0f];
//    [self.daySpinner setFocusedFontSize:20.0f];
//    [self.daySpinner setUnfocusedFontSize:20.0f];
    [self.daySpinner setFocusedFontColor:[UIColor whiteColor]];
    [self.daySpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
//    [self.daySpinner setFontName:@"HelveticaNeue-Bold"];
    [self addSubview:self.daySpinner];
    
    self.monthSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectMake(0.0f+(self.frame.size.width-280.0f)/2, self.frame.size.height-160.0f, 280.0f, 160.0f)];
    [self.monthSpinner setContents:[self monthSpinnerContents]];
    [self.monthSpinner setRadius:141.0f];
    [self.monthSpinner setVerticalShift:35.0f];
    [self.monthSpinner setExtraSpacing:0.0f];
//    [self.monthSpinner setFocusedFontSize:18.0f];
//    [self.monthSpinner setUnfocusedFontSize:18.0f];
    [self.monthSpinner setFocusedFontColor:[UIColor whiteColor]];
    [self.monthSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
//    [self.monthSpinner setFontName:@"HelveticaNeue-Bold"];
    [self addSubview:self.monthSpinner];
    
    self.yearSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectMake(0.0f+(self.frame.size.width-200.0f)/2, self.frame.size.height-125.0f, 200.0f, 125.0f)];
    [self.yearSpinner setContents:[self monthSpinnerContents]];
    [self.yearSpinner setRadius:101.0f];
    [self.yearSpinner setVerticalShift:20.0f];
    [self.yearSpinner setExtraSpacing:0.0f];
//    [self.yearSpinner setFocusedFontSize:18.0f];
//    [self.yearSpinner setUnfocusedFontSize:18.0f];
    [self.yearSpinner setFocusedFontColor:[UIColor whiteColor]];
    [self.yearSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
//    [self.yearSpinner setFontName:@"HelveticaNeue-Bold"];
    [self addSubview:self.yearSpinner];
}

- (void)drawButtons
{
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-190.0f)/2, self.frame.size.height-95.0f, 190.0f, 190.0f)];
    self.addButton.layer.cornerRadius = 95.0f;
    [self addSubview:self.addButton];
    
    self.homeButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-90.0f)/2, self.frame.size.height-45.0f, 90.0f, 90.0f)];
    self.homeButton.layer.cornerRadius = 45.0f;
    [self addSubview:self.homeButton];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.0f);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 385.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 178.0f/255, 141.0f/255, 192.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 320.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 198.0f/255, 168.0f/255, 206.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 255.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 225.0f/255, 203.0f/255, 227.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 195.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 206.0f/255, 202.0f/255, 230.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 160.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 149.0f/255, 149.0f/255, 201.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 125.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 95.0f/255, 103.0f/255, 174.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 95.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 72.0f/255, 87.0f/255, 168.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 45.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 56.0f/255, 83.0f/255, 164.0f/255, 1.0f);
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

- (NSArray*)daySpinnerContents
{
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    for (int dayIndex = 1; dayIndex < 32; dayIndex++) {
        [contents addObject:[NSString stringWithFormat:@"%02d", dayIndex]];
    }
    return contents;
}

- (NSArray*)monthSpinnerContents
{
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    for (int monthIndex = 1; monthIndex < 13; monthIndex++) {
        [contents addObject:[NSString stringWithFormat:@"%02d", monthIndex]];
    }
    return contents;
}

@end
