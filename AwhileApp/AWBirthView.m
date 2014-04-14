//
//  AWBirthView.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWBirthView.h"
#import "CoreTextArcView.h"

@interface AWBirthView ()
@property (nonatomic, strong) CoreTextArcView *yourText;
@property (nonatomic, strong) CoreTextArcView *firstText;
@property (nonatomic, strong) CoreTextArcView *secondText;
@property (nonatomic, strong) CoreTextArcView *thirdText;
@end

@implementation AWBirthView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:201.0f/255 green:158.0f/255 blue:103.0f/255 alpha:1.0f];
        [self drawText];
        [self drawSpinners];
        [self drawButtons];
    }
    return self;
}

- (void)drawText
{
    self.yourText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-480.0f, self.frame.size.width, 120.0f)];
    self.yourText.backgroundColor = [UIColor clearColor];
    self.yourText.text = @"";
    self.yourText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    self.yourText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:48.0f];
    self.yourText.radius = 360.0f;
    self.yourText.arcSize = 45.0f;
    self.yourText.shiftV = -190.0f;
    [self addSubview:self.yourText];
    
    self.firstText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-380.0f, self.frame.size.width, 120.0f)];
    self.firstText.backgroundColor = [UIColor clearColor];
    self.firstText.text = @"";
    self.firstText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    self.firstText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0f];
    self.firstText.radius = 380.0f;
    self.firstText.shiftV = -155.0f;
    [self addSubview:self.firstText];
    
    self.secondText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-300.0f, self.frame.size.width, 120.0f)];
    self.secondText.backgroundColor = [UIColor clearColor];
    self.secondText.text = @"";
    self.secondText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    self.secondText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0f];
    self.secondText.radius = 300.0f;
    self.secondText.shiftV = -115.0f;
    [self addSubview:self.secondText];
    
    self.thirdText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-210.0f, self.frame.size.width, 120.0f)];
    self.thirdText.backgroundColor = [UIColor clearColor];
    self.thirdText.text = @"";
    self.thirdText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    self.thirdText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0f];
    self.thirdText.radius = 210.0f;
    self.thirdText.shiftV = -70.0f;
    [self addSubview:self.thirdText];
    
    CoreTextArcView *nextText = [[CoreTextArcView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-60.0f, self.frame.size.width, 60.0f)];
    nextText.backgroundColor = [UIColor clearColor];
    nextText.text = @"Next";
    nextText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.75f];
    nextText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0f];
    nextText.radius = 1000.0f;
    nextText.arcSize = 4.0f;
    nextText.shiftV = -500.0f;
    [self addSubview:nextText];
}

- (void)drawSpinners
{
    
}

- (void)drawButtons
{
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-260.0f)/2, self.frame.size.height-130.0f, 260.0f, 260.0f)];
    self.nextButton.layer.cornerRadius = 130.0f;
    [self addSubview:self.nextButton];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.0f);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 380.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 177.0f/255, 127.0f/255, 74.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 300.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 148.0f/255, 97.0f/255, 54.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 210.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 126.0f/255, 79.0f/255, 35.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height, 130.0f, 0, M_PI, YES);
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 105.0f/255, 61.0f/255, 24.0f/255, 1.0f);
    CGContextDrawPath(context, kCGPathFill);
}

- (void)showBirthtime
{
    self.yourText.text = @"Your birthtime:";
    self.firstText.text = @"Hour";
    self.firstText.arcSize = 7.0f;
    self.secondText.text = @"Minute";
    self.secondText.arcSize = 12.0f;
    self.thirdText.text = @"Time";
    self.thirdText.arcSize = 12.0f;
}

- (void)showBirthday
{
    self.yourText.text = @"Your birthday:";
    self.firstText.text = @"Year";
    self.firstText.arcSize = 6.0f;
    self.secondText.text = @"Month";
    self.secondText.arcSize = 12.0f;
    self.thirdText.text = @"Day";
    self.thirdText.arcSize = 10.0f;
}

@end
