//
//  AWHomeView.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWHomeView.h"
#import "CoreTextArcView.h"

@implementation AWHomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:221.0f/255 green:220.0f/255 blue:31.0f/255 alpha:1.0f];
        [self drawText];
        [self drawImages];
        [self drawButtons];
    }
    return self;
}

- (void)drawText
{
    CoreTextArcView *yourAgeText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-480.0f, self.frame.size.width, 120.0f)];
    yourAgeText.backgroundColor = [UIColor clearColor];
    yourAgeText.text = @"Your age";
    yourAgeText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:48.0f];
    yourAgeText.radius = 360.0f;
    yourAgeText.arcSize = 30.0f;
    yourAgeText.shiftV = -220.0f;
    [self addSubview:yourAgeText];
    
    CoreTextArcView *calculatorText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-360.0f+20.0f, self.frame.size.width, 120.0f)];
    calculatorText.backgroundColor = [UIColor clearColor];
    calculatorText.text = @"Calculator";
    calculatorText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:48.0f];
    calculatorText.radius = 240.0f;
    calculatorText.arcSize = 50.0f;
    calculatorText.shiftV = -140.0f;
    [self addSubview:calculatorText];
    
    CoreTextArcView *milestonesText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-240.0f+40.0f, self.frame.size.width, 120.0f)];
    milestonesText.backgroundColor = [UIColor clearColor];
    milestonesText.text = @"+milestones";
    milestonesText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:48.0f];
    milestonesText.radius = 150.0f;
    milestonesText.arcSize = 90.0f;
    milestonesText.shiftV = -80.0f;
    [self addSubview:milestonesText];
}

- (void)drawImages
{
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home"]];
    homeImageView.frame = CGRectMake((self.frame.size.width-75.0f)/2, self.frame.size.height-80.0f, 75.0f, 75.0f);
    [self addSubview:homeImageView];
}

- (void)drawButtons
{
    self.yourAgeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.yourAgeButton];
    
    self.calculatorButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-720.0f)/2, self.frame.size.height-360.0f, 720.0f, 720.0f)];
    self.calculatorButton.layer.cornerRadius = 360.0f;
    [self addSubview:self.calculatorButton];
    
    self.milestonesButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-480.0f)/2, self.frame.size.height-240.0f, 480.0f, 480.0f)];
    self.milestonesButton.layer.cornerRadius = 240.0f;
    [self addSubview:self.milestonesButton];
    
    self.homeButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-240.0f)/2, self.frame.size.height-120.0f, 240.0f, 240.0f)];
    self.homeButton.layer.cornerRadius = 120.0f;
    [self addSubview:self.homeButton];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.0f);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 360.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 147.0f/255, 193.0f/255, 61.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 240.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 58.0f/255, 171.0f/255, 73.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 120.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 4.0f/255, 141.0f/255, 69.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
}



@end
