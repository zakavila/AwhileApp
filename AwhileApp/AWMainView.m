//
//  AWMainView.m
//  AwhileApp
//
//  Created by Zak Avila on 4/22/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWMainView.h"
#import "AWArcTextSpinnerCell.h"
#import "AWIconSpinnerCell.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ShareViewController.h"



#pragma mark Constants

#define NUMBER_OF_CIRCLES 7

#define HOME_CIRCLE_R 16
#define HOME_CIRCLE_G 66
#define HOME_CIRCLE_B 255
#define YEAR_CIRCLE_R 16
#define YEAR_CIRCLE_G 66
#define YEAR_CIRCLE_B 255
#define DAY_CIRCLE_R 3
#define DAY_CIRCLE_G 135
#define DAY_CIRCLE_B 191
#define MONTH_CIRCLE_R 53
#define MONTH_CIRCLE_G 169
#define MONTH_CIRCLE_B 225
#define INCREMENT_CIRCLE_R 115
#define INCREMENT_CIRCLE_G 189
#define INCREMENT_CIRCLE_B 225
#define VALUE_CIRCLE_R 184
#define VALUE_CIRCLE_G 214
#define VALUE_CIRCLE_B 230
#define YOU_CIRCLE_R 255
#define YOU_CIRCLE_G 255
#define YOU_CIRCLE_B 255

#define ICON_SPINNER_CELL_IDENTIFIER @"IconSpinnerCellIdentifier"
#define ARCTEXT_SPINNER_CELL_IDENTIFIER @"ArcTextSpinnerCellIdentifier"

#define FOCUSED_FONT_NAME @"HelveticaNeue-Light"
#define UNFOCUSED_FONT_NAME @"HelveticaNeue-UltraLight"
#define FOCUSED_FONT_SIZE 48.0f
#define UNFOCUSED_FONT_SIZE 32.0f

typedef NS_ENUM(NSInteger, CircleType) {
    CircleTypeMenu = 0,
    CircleTypeYear = 1,
    CircleTypeDay = 2,
    CircleTypeMonth = 3,
    CircleTypeIncrement = 4,
    CircleTypeValue = 5,
    CircleTypeYou = 6
};

@interface AWMainView ()
@property (nonatomic, strong) NSMutableArray *circleViews;
@property (nonatomic, strong) UIImageView *awhileLogo;
@property (nonatomic, strong) UIImageView *menuShadow;
@property (nonatomic, strong) UILabel *onLabel;
@property (nonatomic, strong) ZASpinnerView *menuSpinner;
@property (nonatomic, strong) ZASpinnerView *yearSpinner;
@property (nonatomic, strong) ZASpinnerView *daySpinner;
@property (nonatomic, strong) ZASpinnerView *monthSpinner;
@property (nonatomic, strong) ZASpinnerView *incrementSpinner;
@property (nonatomic, strong) ZASpinnerView *valueSpinner;
@property (nonatomic, strong) ZASpinnerView *youSpinner;
@end

@implementation AWMainView

#pragma mark Setup
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpCircles];
    }
    return self;
}

- (void)setUpCircles
{
    self.circleViews = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < NUMBER_OF_CIRCLES; i++) {
        UIView *circleView = [[UIView alloc] init];
        UIColor *backgroundColor;
        if (i == CircleTypeMenu) {
            [circleView addSubview:self.menuSpinner];
            [circleView addSubview:self.menuShadow];
            backgroundColor = [UIColor colorWithRed:HOME_CIRCLE_R/255.0f green:HOME_CIRCLE_G/255.0f blue:HOME_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeYear) {
            [circleView addSubview:self.yearSpinner];
            backgroundColor = [UIColor colorWithRed:YEAR_CIRCLE_R/255.0f green:YEAR_CIRCLE_G/255.0f blue:YEAR_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeDay) {
            [circleView addSubview:self.daySpinner];
            backgroundColor = [UIColor colorWithRed:DAY_CIRCLE_R/255.0f green:DAY_CIRCLE_G/255.0f blue:DAY_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeMonth) {
            [circleView addSubview:self.onLabel];
            [circleView addSubview:self.monthSpinner];
            backgroundColor = [UIColor colorWithRed:MONTH_CIRCLE_R/255.0f green:MONTH_CIRCLE_G/255.0f blue:MONTH_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeIncrement) {
            [circleView addSubview:self.incrementSpinner];
            backgroundColor = [UIColor colorWithRed:INCREMENT_CIRCLE_R/255.0f green:INCREMENT_CIRCLE_G/255.0f blue:INCREMENT_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeValue) {
            [circleView addSubview:self.valueSpinner];
            backgroundColor = [UIColor colorWithRed:VALUE_CIRCLE_R/255.0f green:VALUE_CIRCLE_G/255.0f blue:VALUE_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeYou) {
            [circleView addSubview:self.youSpinner];
            backgroundColor = [UIColor colorWithRed:YOU_CIRCLE_R/255.0f green:YOU_CIRCLE_G/255.0f blue:YOU_CIRCLE_B/255.0f alpha:1.0f];
        }
        circleView.backgroundColor = backgroundColor;
        [self.circleViews addObject:circleView];
    }
    [self.circleViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addSubview:(UIView*)obj];
    }];
}

#pragma mark Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat fullRadius = [self homeDiameter]/2;
    CGFloat previousFullRadius = 0.0f;
    CGFloat offScreenRadius = [self homeDiameter]/2 - [self shownHomeRadius];
    for (NSUInteger circleIndex = 0; circleIndex < NUMBER_OF_CIRCLES; circleIndex++) {
        UIView *circleView = [self.circleViews objectAtIndex:circleIndex];
        CGFloat diameter = 2*fullRadius;
        circleView.frame =  CGRectMake(circleView.frame.origin.x, circleView.frame.origin.y, diameter, diameter);
        circleView.layer.cornerRadius = fullRadius;
        circleView.layer.masksToBounds = YES;
        circleView.center = CGPointMake(kScreenWidth/2, kScreenHeight+offScreenRadius);
        CGFloat spinnerOriginX = -circleView.frame.origin.x;
        CGFloat spinnerHeight = [self saggitaForRadius:previousFullRadius] + [self normalBandWidth];
        if (circleIndex == CircleTypeMenu) {
            self.menuSpinner.frame = CGRectMake(0.0f, [self unfocusedIconSize]*3/2, [self homeDiameter], [self shownHomeRadius]);
            self.menuSpinner.radius = 0.0f;
        }
        else if (circleIndex == CircleTypeYear) {
#warning Fix spinner to work with more full circles
            self.yearSpinner.frame = CGRectMake(spinnerOriginX+30, 0.0f, kScreenWidth-60, fullRadius);
            self.yearSpinner.radius = previousFullRadius;
            self.yearSpinner.verticalShift = -65.0f;
            self.yearSpinner.value = @"2014";
        }
        else if (circleIndex == CircleTypeDay) {
            self.daySpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, spinnerHeight);
            self.daySpinner.radius = previousFullRadius;
            self.daySpinner.verticalShift = -55.0f;
            self.daySpinner.value = @"0";
        }
        else if (circleIndex == CircleTypeMonth) {
            self.onLabel.frame = CGRectMake(spinnerOriginX+kScreenWidth/2-[self normalBandWidth]/6, 0.0f, [self normalBandWidth]/3, [self normalBandWidth]/3);
            self.onLabel.layer.cornerRadius = [self normalBandWidth]/6;
            self.onLabel.layer.masksToBounds = YES;
            self.monthSpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, spinnerHeight);
            self.monthSpinner.radius = previousFullRadius;
            self.monthSpinner.verticalShift = -40.0f;
            self.monthSpinner.value = @"Jan";
        }
        else if (circleIndex == CircleTypeIncrement) {
            self.incrementSpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, spinnerHeight);
            self.incrementSpinner.radius = previousFullRadius;
            self.incrementSpinner.verticalShift = -30.0f;
            self.incrementSpinner.value = @"Seconds";
        }
        else if (circleIndex == CircleTypeValue) {
            self.valueSpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, spinnerHeight);
            self.valueSpinner.radius = previousFullRadius;
            self.valueSpinner.verticalShift = -25.0f;
            self.valueSpinner.value = @"0";
        }
        else if (circleIndex == CircleTypeYou) {
            self.youSpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, spinnerHeight);
            self.youSpinner.radius = previousFullRadius;
            self.youSpinner.verticalShift = -20.0f;
            self.youSpinner.value = @"You were";
        }
        previousFullRadius = fullRadius;
        fullRadius = previousFullRadius + [self normalBandWidth];
    }
}


#pragma mark Spinner
- (CGFloat)spinner:(ZASpinnerView *)spinner heightForRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString *)contentValue
{
    CGFloat returnValue;
    if (spinner == self.menuSpinner) {
        returnValue = [self focusedIconSize]+20.0f;
    }
    else {
        CGRect dummyRect = CGRectIntegral([contentValue boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:FOCUSED_FONT_NAME size:FOCUSED_FONT_SIZE]} context:nil]);
        returnValue = dummyRect.size.height+ceilf(dummyRect.size.width*0.5);
    }
    return returnValue;
}

- (ZASpinnerCell *)spinner:(ZASpinnerView *)spinner cellForRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString *)contentValue
{
    ZASpinnerCell *cell;
    if (spinner == self.menuSpinner) {
        AWIconSpinnerCell *iconCell = [spinner dequeueReusableCellWithIdentifier:ICON_SPINNER_CELL_IDENTIFIER];
        iconCell.icon.image = [UIImage imageNamed:contentValue];
        cell = iconCell;
    }
    else {
        AWArcTextSpinnerCell *arcTextCell = [spinner dequeueReusableCellWithIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
        arcTextCell.circularArcText.text = contentValue;
        arcTextCell.circularArcText.radius = spinner.radius;
        arcTextCell.circularArcText.shiftV = -0.534f*spinner.radius-0.8573f;
        if (spinner == self.youSpinner)
            arcTextCell.circularArcText.color = [UIColor colorWithRed:HOME_CIRCLE_R/255.0f green:HOME_CIRCLE_G/255.0f blue:HOME_CIRCLE_B/255.0f alpha:1.0f];
        else
            arcTextCell.circularArcText.color = [UIColor whiteColor];
        cell = arcTextCell;
    }
    return cell;
}

- (void)spinner:(ZASpinnerView *)spinner styleForCell:(ZASpinnerCell *)cell whileFocused:(BOOL)isFocused
{
    if (spinner == self.menuSpinner) {
        [self styleIconsForSpinner:spinner styleForCell:cell whileFocused:isFocused];
    }
    else {
        [self styleArcTextForSpinner:spinner styleForCell:cell whileFocused:isFocused];
    }
}

- (void)spinner:(ZASpinnerView *)spinner didChangeTo:(NSString *)value
{
    [self.delegate mainView:self spinner:spinner didChangeTo:value];
    [spinner setValue:(value)];
    NSString * day = [_daySpinner value];
    NSString * month = [_monthSpinner value];
    NSString * year = [_yearSpinner value];
    NSString * increment = [_incrementSpinner value];
    NSString * val = [_valueSpinner value];
    NSString * you = [_youSpinner value];

    if ([value isEqualToString: @"Share"]) {
        ShareViewController *shareViewController = [[ShareViewController alloc] init];
        [FBLoginView class];
        // Set loginUIViewController as root view controller
        [[self window] setRootViewController:shareViewController];
    }
    
    if ([value isEqualToString: @"Alarm"]) {
        EKEventEditViewController* vc = [[EKEventEditViewController alloc] init];
        EKEventStore* eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {            vc.eventStore = eventStore;
            EKEvent* event = [EKEvent eventWithEventStore:eventStore];
            // Prepopulate all kinds of useful information with you event.
            event.title = [NSString stringWithFormat:@"%@ %@ %@ on", you, val, increment];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", day, month, year];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"d-MMM-yy";
            NSDate *date = [dateFormatter dateFromString:dateString];
            event.startDate = date;
            event.endDate = date;
            event.URL = [NSURL URLWithString:@"awhile.appspot.com"];
            //event.notes = @"This event will be awesome!";
            NSMutableArray *myAlarmsArray = [[NSMutableArray alloc] init];
            EKAlarm *arrAlarm = [EKAlarm alarmWithAbsoluteDate:date];
            [myAlarmsArray addObject:arrAlarm];
            
            event.alarms = myAlarmsArray;
            event.allDay = YES;
            vc.event = event;
            
            vc.editViewDelegate = self;
            [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
        }];
        
         
         
    }
}
         
- (void)eventEditViewController:(EKEventEditViewController*)controller
                        didCompleteWithAction:(EKEventEditViewAction)action
{
            [controller dismissViewControllerAnimated:YES completion:nil];
            //[self dismissViewControllerAnimated:YES completion:nil];
}
    

- (void)spinner:(ZASpinnerView*)spinner didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (spinner == self.menuSpinner)
        [self.delegate mainView:self spinner:spinner didSelectRowAtIndexPath:indexPath];
}


#pragma mark Spinner Helper

- (void)styleIconsForSpinner:(ZASpinnerView*)spinner styleForCell:(ZASpinnerCell*)cell whileFocused:(BOOL)isFocused
{
    AWIconSpinnerCell *iconCell = (AWIconSpinnerCell*)cell;
    if (isFocused) {
        iconCell.icon.bounds = CGRectMake(0.0f, 0.0f, [self focusedIconSize], [self focusedIconSize]);
        iconCell.icon.alpha = 1.0f;
    }
    else {
        iconCell.icon.bounds = CGRectMake(0.0f, 0.0f, [self unfocusedIconSize], [self unfocusedIconSize]);
        iconCell.icon.alpha = 0.75f;
    }
}

- (void)styleArcTextForSpinner:(ZASpinnerView*)spinner styleForCell:(ZASpinnerCell*)cell whileFocused:(BOOL)isFocused
{
    AWArcTextSpinnerCell *arcTextCell = (AWArcTextSpinnerCell*)cell;
    UIFont *textFont;
    if (isFocused)
        textFont = [UIFont fontWithName:FOCUSED_FONT_NAME size:FOCUSED_FONT_SIZE];
    else
        textFont = [UIFont fontWithName:UNFOCUSED_FONT_NAME size:UNFOCUSED_FONT_SIZE];
    arcTextCell.circularArcText.font = textFont;
    CGRect dummyRect = CGRectIntegral([arcTextCell.circularArcText.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: textFont} context:nil]);
    arcTextCell.circularArcText.arcSize = [self arcMultiplierForSpinner:spinner andFocused:isFocused]*dummyRect.size.width;
    arcTextCell.circularArcText.bounds = CGRectMake(0.0f, 0.0f, arcTextCell.bounds.size.width+(dummyRect.size.width-arcTextCell.bounds.size.width), arcTextCell.bounds.size.height);
    [arcTextCell.circularArcText setNeedsDisplay];
}


#pragma mark Lazyloading

- (UIImageView*)menuShadow
{
    if (!_menuShadow) {
        _menuShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MenuShadow"]];
    }
    return _menuShadow;
}

- (UIImageView*)awhileLogo
{
    if (!_awhileLogo) {
        _awhileLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AwhileLogo"]];
    }
    return _awhileLogo;
}

- (UILabel*)onLabel
{
    if (!_onLabel) {
        _onLabel = [[UILabel alloc] init];
        _onLabel.text = @"on";
        _onLabel.textAlignment = NSTextAlignmentCenter;
        _onLabel.font = [UIFont fontWithName:FOCUSED_FONT_NAME size:16.0f];
        _onLabel.textColor = [UIColor colorWithRed:MONTH_CIRCLE_R/255.0f green:MONTH_CIRCLE_G/255.0f blue:MONTH_CIRCLE_B/255.0f alpha:1.0f];
        _onLabel.backgroundColor = [UIColor whiteColor];
    }
    return _onLabel;
}

- (ZASpinnerView*)menuSpinner
{
    if (!_menuSpinner) {
        _menuSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _menuSpinner.spinnerDelegate = self;
        _menuSpinner.contents = [self menuSpinnerContents];
        _menuSpinner.startIndex = 2;
        [_menuSpinner registerClass:[AWIconSpinnerCell class] forCellReuseIdentifier:ICON_SPINNER_CELL_IDENTIFIER];
    }
    return _menuSpinner;
}

- (ZASpinnerView*)yearSpinner
{
    if (!_yearSpinner) {
        _yearSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _yearSpinner.spinnerDelegate = self;
        _yearSpinner.isInfinite = YES;
        _yearSpinner.startIndex = 2014;
        [_yearSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _yearSpinner;
}

- (ZASpinnerView*)daySpinner
{
    if (!_daySpinner) {
        _daySpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _daySpinner.spinnerDelegate = self;
        _daySpinner.contents = [self daySpinnerContents];
        [_daySpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _daySpinner;
}

- (ZASpinnerView*)monthSpinner
{
    if (!_monthSpinner) {
        _monthSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _monthSpinner.spinnerDelegate = self;
        _monthSpinner.contents = [self monthSpinnerContents];
        [_monthSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _monthSpinner;
}

- (ZASpinnerView*)incrementSpinner
{
    if (!_incrementSpinner) {
        _incrementSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _incrementSpinner.spinnerDelegate = self;
        _incrementSpinner.contents = [self incrementSpinnerContents];
        [_incrementSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _incrementSpinner;
}

- (ZASpinnerView*)valueSpinner
{
    if (!_valueSpinner) {
        _valueSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _valueSpinner.spinnerDelegate = self;
        _valueSpinner.isInfinite = YES;
        [_valueSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _valueSpinner;
}

- (ZASpinnerView*)youSpinner
{
    if (!_youSpinner) {
        _youSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _youSpinner.spinnerDelegate = self;
        _youSpinner.contents = [self youSpinnerContents];
        [_youSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _youSpinner;
}


#pragma mark Spinner Contents

- (NSArray*)menuSpinnerContents
{
    return @[@"Birthday", @"Time", @"Calculator", @"Alarm", @"Share"];
}

- (NSArray*)daySpinnerContents
{
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSUInteger currDay = 0; currDay < 32; currDay++)
        [returnArray addObject:[NSString stringWithFormat:@"%d", currDay]];
    return returnArray;
}

- (NSArray*)monthSpinnerContents
{
    return @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
}

- (NSArray*)incrementSpinnerContents
{
    return @[@"Seconds", @"Minutes", @"Hours", @"Days", @"Weeks", @"Months", @"Years", @"Decades"];
}

- (NSArray*)youSpinnerContents
{
    return @[@"You were", @"You are", @"You'll be"];
}


#pragma mark Helper values

- (CGFloat)arcMultiplierForSpinner:(ZASpinnerView*)spinner andFocused:(BOOL)isFocused
{
    CGFloat returnValue;
    if (spinner == self.youSpinner)
        returnValue = (isFocused) ? 0.1f : 0.1f;
    else if (spinner == self.valueSpinner)
        returnValue = (isFocused) ? 0.12f : 0.12f;
    else if (spinner == self.incrementSpinner)
        returnValue = (isFocused) ? 0.15f : 0.15f;
    else if (spinner == self.monthSpinner)
        returnValue = (isFocused) ? 0.18f : 0.20f;
    else if (spinner == self.daySpinner)
        returnValue = (isFocused) ? 0.2f : 0.28f;
    else if (spinner == self.yearSpinner)
        returnValue = (isFocused) ? 0.33f : 0.35f;
    return returnValue;
}

- (CGFloat)unfocusedIconSize
{
    return floorf(35.0f/568*kScreenHeight);
}

- (CGFloat)focusedIconSize
{
    return floorf(50.0f/568*kScreenHeight);
}

- (CGFloat)normalBandWidth {
    return floorf((1/(7+5/8.0f))*kScreenHeight);
}

- (CGFloat)saggitaForRadius:(CGFloat)radius
{
    return floorf(radius-sqrtf(powf(radius,2.0f)-powf(kScreenWidth/2.0f,2)));
}

- (CGFloat)homeDiameter {
    return floorf(3.5f/4.25f*kScreenWidth);
}

- (CGFloat)shownHomeRadius {
    return floorf(1.5f/(7+5/8.0f)*kScreenHeight);
}

@end