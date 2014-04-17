//
//  AWYoullBeView.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWYoullBeView.h"
#import "CoreTextArcView.h"

@implementation AWYoullBeView

- (id)initWithFrame:(CGRect)frame andData:(AWDataModel*)data
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataModel = data;
        [self drawText];
        [self drawImages];
        [self drawSpinners];
        [self drawButtons];
    }
    return self;
}

- (void)drawText
{
    CoreTextArcView *youllBeText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-480.0f, self.frame.size.width, 120.0f)];
    youllBeText.backgroundColor = [UIColor clearColor];
    youllBeText.text = @"You'll be:";
    youllBeText.color = [UIColor colorWithRed:250.0f/255 green:172.0f/255 blue:24.0f/255 alpha:1.0f];
    youllBeText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:54.0f];
    youllBeText.radius = 390.0f;
    youllBeText.arcSize = 30.0f;
    youllBeText.shiftV = -205.0f;
    [self addSubview:youllBeText];
    
    CoreTextArcView *oldOnText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-255.0f+10.0f, self.frame.size.width, 120.0f)];
    oldOnText.backgroundColor = [UIColor clearColor];
    oldOnText.text = @"Old on:";
    oldOnText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    oldOnText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:46.0f];
    oldOnText.radius = 195.0f;
    oldOnText.arcSize = 40.0f;
    oldOnText.shiftV = -75.0f;
    [self addSubview:oldOnText];
    
    CoreTextArcView *milestonesText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-135.0f+20.0f, self.frame.size.width, 100.0f)];
    milestonesText.backgroundColor = [UIColor clearColor];
    milestonesText.text = @"+milestones";
    milestonesText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    milestonesText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f];
    milestonesText.radius = 70.0f;
    milestonesText.arcSize = 100.0f;
    milestonesText.shiftV = -45.0f;
    [self addSubview:milestonesText];
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
    [self.valueSpinner setFocusedFontSize:44.0f];
    [self.valueSpinner setUnfocusedFontSize:44.0f];
    [self.valueSpinner setFocusedFontColor:[UIColor whiteColor]];
    [self.valueSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
    [self.valueSpinner setFontName:@"HelveticaNeue-Bold"];
    [self.valueSpinner setIsInfinite:YES];
    [self addSubview:self.valueSpinner];
    
    self.incrementSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height-320.0f+10.0f, self.frame.size.width, 120.0f)];
    [self.incrementSpinner setContents:[self incrementSpinnerContents]];
    [self.incrementSpinner setRadius:220.0f];
    [self.incrementSpinner setVerticalShift:360.0f];
    [self.incrementSpinner setExtraSpacing:15.0f];
    [self.incrementSpinner setFocusedFontSize:38.0f];
    [self.incrementSpinner setUnfocusedFontSize:38.0f];
    [self.incrementSpinner setFocusedFontColor:[UIColor whiteColor]];
    [self.incrementSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
    [self.incrementSpinner setFontName:@"HelveticaNeue-Bold"];
    [self addSubview:self.incrementSpinner];
    
    self.daySpinner = [[ZASpinnerView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height-195.0f, self.frame.size.width, 195.0f)];
    [self.daySpinner setContents:[self daySpinnerContents]];
    [self.daySpinner setRadius:190.0f];
    [self.daySpinner setVerticalShift:135.0f];
    [self.daySpinner setExtraSpacing:0.0f];
    [self.daySpinner setFocusedFontSize:20.0f];
    [self.daySpinner setUnfocusedFontSize:20.0f];
    [self.daySpinner setFocusedFontColor:[UIColor whiteColor]];
    [self.daySpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
    [self.daySpinner setFontName:@"HelveticaNeue-Bold"];
    [self addSubview:self.daySpinner];
    
    self.monthSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectMake(0.0f+(self.frame.size.width-280.0f)/2, self.frame.size.height-160.0f, 280.0f, 160.0f)];
    [self.monthSpinner setContents:[self monthSpinnerContents]];
    [self.monthSpinner setRadius:141.0f];
    [self.monthSpinner setVerticalShift:35.0f];
    [self.monthSpinner setExtraSpacing:0.0f];
    [self.monthSpinner setFocusedFontSize:18.0f];
    [self.monthSpinner setUnfocusedFontSize:18.0f];
    [self.monthSpinner setFocusedFontColor:[UIColor whiteColor]];
    [self.monthSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
    [self.monthSpinner setFontName:@"HelveticaNeue-Bold"];
    [self addSubview:self.monthSpinner];
    
    self.yearSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectMake(0.0f+(self.frame.size.width-200.0f)/2, self.frame.size.height-125.0f, 200.0f, 125.0f)];
    [self.yearSpinner setContents:[self monthSpinnerContents]];
    [self.yearSpinner setRadius:101.0f];
    [self.yearSpinner setVerticalShift:20.0f];
    [self.yearSpinner setExtraSpacing:0.0f];
    [self.yearSpinner setFocusedFontSize:18.0f];
    [self.yearSpinner setUnfocusedFontSize:18.0f];
    [self.yearSpinner setFocusedFontColor:[UIColor whiteColor]];
    [self.yearSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
    [self.yearSpinner setFontName:@"HelveticaNeue-Bold"];
    [self addSubview:self.yearSpinner];
}

- (void)drawButtons
{
    self.milestonesButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-190.0f)/2, self.frame.size.height-95.0f, 190.0f, 190.0f)];
    self.milestonesButton.layer.cornerRadius = 95.0f;
    [self addSubview:self.milestonesButton];
    
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
    CGContextSetRGBFillColor(context, 251.0f/255, 234.0f/255, 7.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 320.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 248.0f/255, 177.0f/255, 50.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 255.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 242.0f/255, 147.0f/255, 30.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 195.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 229.0f/255, 94.0f/255, 36.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 160.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 239.0f/255, 59.0f/255, 35.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 125.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 226.0f/255, 30.0f/255, 40.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 95.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 189.0f/255, 32.0f/255, 37.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 45.0f, 0, M_PI, YES);
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

- (void)spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value
{
    
}

@end
