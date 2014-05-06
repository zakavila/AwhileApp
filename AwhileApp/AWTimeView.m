//
//  AWTimeView.m
//  AwhileApp
//
//  Created by Matthew Ford on 5/1/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWTimeView.h"
#import "AWArcTextSpinnerCell.h"
#import "AWIconSpinnerCell.h"
#import "AWSpinnerContents.h"

#pragma mark Constants

#define NUMBER_OF_CIRCLES 8

#define AM_PM_CIRCLE_R 2
#define AM_PM_CIRCLE_G 102
#define AM_PM_CIRCLE_B 52
#define DATE_CIRCLE_R 143
#define DATE_CIRCLE_G 197
#define DATE_CIRCLE_B 21
#define HOME_CIRCLE_R 16
#define HOME_CIRCLE_G 66
#define HOME_CIRCLE_B 255
#define HOUR_CIRCLE_R 60
#define HOUR_CIRCLE_G 169
#define HOUR_CIRCLE_B 54
#define MINUTE_CIRCLE_R 0
#define MINUTE_CIRCLE_G 141
#define MINUTE_CIRCLE_B 54
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
#define DATE_FONT_SIZE 25.0f

typedef NS_ENUM(NSInteger, CircleType) {
    CircleTypeMenu = 0,
    CircleTypeAmPm = 1,
    CircleTypeMinute = 2,
    CircleTypeHour = 3,
    CircleTypeDate = 4,
    CircleTypeIncrement = 5,
    CircleTypeValue = 6,
    CircleTypeYou = 7
};

@interface AWTimeView ()
@property (nonatomic, strong) UIImageView *woodRings;
@property (nonatomic, strong) UIImageView *awhileLogo;
@property (nonatomic, strong) UIImageView *menuShadow;
@property (nonatomic, strong) UIView *onView;
@property (nonatomic, strong) UILabel *onLabel;
@property (nonatomic, strong) UIView *atView;
@property (nonatomic, strong) UILabel *atLabel;
@property (nonatomic, strong) CoreTextArcView *dateTextView;
@end

@implementation AWTimeView

#pragma mark Setup
- (id)initWithFrame:(CGRect)frame thing:(NSString*)date
{
    self = [super initWithFrame:frame];
    if (self) {
        self.date = date;
        [self setUpCircles];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat circleOffset = ((UIView*)[[self circleViews] objectAtIndex:CircleTypeDate]).frame.origin.y;
    if (point.y < circleOffset)
        return NO;
    return [super pointInside:point withEvent:event];
}

- (void)setUpCircles
{
    self.circleViews = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < NUMBER_OF_CIRCLES; i++) {
        UIView *circleView = [[UIView alloc] init];
        UIColor *backgroundColor;
        if (i == CircleTypeMenu) {
            [circleView addSubview:self.woodRings];
            [circleView addSubview:self.awhileLogo];
            [circleView addSubview:self.menuSpinner];
            [circleView addSubview:self.menuShadow];
            backgroundColor = [UIColor colorWithRed:HOME_CIRCLE_R/255.0f green:HOME_CIRCLE_G/255.0f blue:HOME_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeAmPm) {
            [circleView addSubview:self.amPmSpinner];
            backgroundColor = [UIColor colorWithRed:AM_PM_CIRCLE_R/255.0f green:AM_PM_CIRCLE_G/255.0f blue:AM_PM_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeMinute) {
            [circleView addSubview:self.minuteSpinner];
            backgroundColor = [UIColor colorWithRed:MINUTE_CIRCLE_R/255.0f green:MINUTE_CIRCLE_G/255.0f blue:MINUTE_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeHour) {
            [circleView addSubview:self.hourSpinner];
            backgroundColor = [UIColor colorWithRed:HOUR_CIRCLE_R/255.0f green:HOUR_CIRCLE_G/255.0f blue:HOUR_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeIncrement) {

        }
        else if (i == CircleTypeValue) {

        }
        else if (i == CircleTypeYou) {
         
        }
        else if (i == CircleTypeDate) {
            [circleView addSubview:self.onView];
            [self.onView addSubview:self.onLabel];
            [circleView addSubview:self.atView];
            [self.atView addSubview:self.atLabel];
            [circleView addSubview:self.dateTextView];
            backgroundColor = [UIColor colorWithRed:DATE_CIRCLE_R/255.0f green:DATE_CIRCLE_G/255.0f blue:DATE_CIRCLE_B/255.0f alpha:1.0f];
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
            circleView.layer.borderColor = [UIColor blackColor].CGColor;
            circleView.layer.borderWidth = 1.0f;
            self.awhileLogo.frame = CGRectMake((kScreenWidth/3) - (154/12), 15.0f, 154/2, 42/2);
            [circleView bringSubviewToFront:self.awhileLogo];
            self.menuSpinner.frame = CGRectMake(0.0f, [self unfocusedIconSize]*3/2, [self homeDiameter], [self shownHomeRadius]);
            self.menuSpinner.tableView.frame = CGRectMake(0.0f, [self unfocusedIconSize]*3/2, [self homeDiameter], [self shownHomeRadius]);
            self.menuSpinner.radius = 0.0f;
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self tertiaryBandWidth];
        }
        else if (circleIndex == CircleTypeAmPm) {
            self.amPmSpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, fullRadius);
            self.amPmSpinner.chordLength = [self homeDiameter];
            self.amPmSpinner.radius = previousFullRadius + 2;
            self.amPmSpinner.verticalShift = -55.0f;
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self tertiaryBandWidth];
        }
        else if (circleIndex == CircleTypeMinute) {
            self.minuteSpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, spinnerHeight);
            self.minuteSpinner.radius = previousFullRadius;
            self.minuteSpinner.verticalShift = -55.0f;
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self tertiaryBandWidth];
        }
        else if (circleIndex == CircleTypeHour) {
            self.hourSpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, spinnerHeight);
            self.hourSpinner.radius = previousFullRadius;
            self.hourSpinner.verticalShift = -40.0f;
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self weirdBandWidth];
        }
        else if (circleIndex == CircleTypeIncrement) {
            
        }
        else if (circleIndex == CircleTypeValue) {
            
        }
        else if (circleIndex == CircleTypeYou) {
            
        }
        else if (circleIndex == CircleTypeDate) {
            self.onView.frame = CGRectMake(spinnerOriginX+kScreenWidth/2-[self normalBandWidth]/7-75, 0.0f+12, [self normalBandWidth]/3.5, [self normalBandWidth]/3.5);
            self.onView.layer.cornerRadius = [self normalBandWidth]/7;
            self.onView.layer.masksToBounds = YES;
            self.onLabel.frame = CGRectMake(0.0f, -2.0f, self.onView.frame.size.width, self.onView.frame.size.height);
            
            self.atView.frame = CGRectMake(spinnerOriginX+kScreenWidth/2-[self normalBandWidth]/7+75, 0.0f+12, [self normalBandWidth]/3.5, [self normalBandWidth]/3.5);
            self.atView.layer.cornerRadius = [self normalBandWidth]/7;
            self.atView.layer.masksToBounds = YES;
            self.atLabel.frame = CGRectMake(0.0f, -2.0f, self.atView.frame.size.width, self.atView.frame.size.height);
            
            CGFloat bottomRadiusPadding = fullRadius - floorf((fullRadius*sinf(acosf((kScreenWidth/2)/fullRadius))));
			CGFloat oldCirleTextArcViewHeight = fullRadius;
			
			if (!isnan(bottomRadiusPadding)) {
				oldCirleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_dateTextView setFrame:CGRectMake(0.0, 0.0f, circleView.bounds.size.width, oldCirleTextArcViewHeight)];
			[_dateTextView setRadius:previousFullRadius];
			[_dateTextView setArcSize:20];
			[_dateTextView setShiftV:12.0f];
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self normalBandWidth];
        }

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
        iconCell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Circle_Black", contentValue]];
        iconCell.icon.userInteractionEnabled = YES;
        cell = iconCell;
    }
    else {
        AWArcTextSpinnerCell *arcTextCell = [spinner dequeueReusableCellWithIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
        arcTextCell.circularArcText.text = contentValue;
        arcTextCell.circularArcText.radius = spinner.radius;
        arcTextCell.circularArcText.shiftV = -0.534f*spinner.radius-0.8573f;
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
    [self.delegate timeView:self spinner:spinner didChangeTo:value];
}

- (void)spinner:(ZASpinnerView *)spinner didSelectRowAtIndexPath:(NSIndexPath *)index withContentValue:(NSString *)contentValue
{
    [self.delegate timeView:self spinner:spinner didSelectRowAtIndexPath:index withContentValue:contentValue];
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

- (UIImageView*)woodRings
{
    if (!_woodRings) {
        _woodRings = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WoodRings"]];
    }
    return _woodRings;
}

- (UIImageView*)awhileLogo
{
    if (!_awhileLogo) {
        _awhileLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AwhileLogo"]];
    }
    return _awhileLogo;
}

- (UIView*)onView
{
    if (!_onView) {
        _onView = [[UIView alloc] init];
        _onView.backgroundColor = [UIColor whiteColor];
    }
    return _onView;
}

- (UILabel*)onLabel
{
    if (!_onLabel) {
        _onLabel = [[UILabel alloc] init];
        _onLabel.text = @"on";
        _onLabel.textAlignment = NSTextAlignmentCenter;
        _onLabel.font = [UIFont fontWithName:FOCUSED_FONT_NAME size:14.0f];
        _onLabel.textColor = [UIColor colorWithRed:DATE_CIRCLE_R/255.0f green:DATE_CIRCLE_G/255.0f blue:DATE_CIRCLE_B/255.0f alpha:1.0f];
        _onLabel.backgroundColor = [UIColor clearColor];
    }
    return _onLabel;
}

- (UIView*)atView
{
    if (!_atView) {
        _atView = [[UIView alloc] init];
        _atView.backgroundColor = [UIColor whiteColor];
    }
    return _atView;
}

- (UILabel*)atLabel
{
    if (!_atLabel) {
        _atLabel = [[UILabel alloc] init];
        _atLabel.text = @"@";
        _atLabel.textAlignment = NSTextAlignmentCenter;
        _atLabel.font = [UIFont fontWithName:FOCUSED_FONT_NAME size:17.0f];
        _atLabel.textColor = [UIColor colorWithRed:DATE_CIRCLE_R/255.0f green:DATE_CIRCLE_G/255.0f blue:DATE_CIRCLE_B/255.0f alpha:1.0f];
        _atLabel.backgroundColor = [UIColor clearColor];
    }
    return _atLabel;
}

- (ZASpinnerView*)menuSpinner
{
    if (!_menuSpinner) {
        _menuSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _menuSpinner.spinnerDelegate = self;
        _menuSpinner.contents = [AWSpinnerContents menuContents];
        _menuSpinner.spinnerType = InfiniteLoopSpinner;
        _menuSpinner.startIndex = 2;
        [_menuSpinner registerClass:[AWIconSpinnerCell class] forCellReuseIdentifier:ICON_SPINNER_CELL_IDENTIFIER];
    }
    return _menuSpinner;
}

- (ZASpinnerView*)amPmSpinner
{
    if (!_amPmSpinner) {
        _amPmSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _amPmSpinner.spinnerDelegate = self;
        _amPmSpinner.contents = [AWSpinnerContents amPmContents];
        [_amPmSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _amPmSpinner;
}

- (ZASpinnerView*)minuteSpinner
{
    if (!_minuteSpinner) {
        _minuteSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _minuteSpinner.spinnerDelegate = self;
        _minuteSpinner.contents = [AWSpinnerContents colonMinuteContents];
        [_minuteSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _minuteSpinner;
}

- (ZASpinnerView*)hourSpinner
{
    if (!_hourSpinner) {
        _hourSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _hourSpinner.spinnerDelegate = self;
        _hourSpinner.contents = [AWSpinnerContents hourContents];
        [_hourSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _hourSpinner;
}

- (CoreTextArcView*)dateTextView
{
    if (!_dateTextView) {
        _dateTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
        [_dateTextView setText:self.date];
        [_dateTextView setFont:[UIFont fontWithName:FOCUSED_FONT_NAME size:DATE_FONT_SIZE]];
        [_dateTextView setColor:[UIColor whiteColor]];
        [_dateTextView setBackgroundColor:[UIColor clearColor]];
    }
    return _dateTextView;
}

- (void)setDate:(NSString *)date
{
    [self.dateTextView setText:date];
    _date = date;
}


#pragma mark Helper values

- (CGFloat)arcMultiplierForSpinner:(ZASpinnerView*)spinner andFocused:(BOOL)isFocused
{
    CGFloat returnValue;
    if (spinner == self.hourSpinner)
        returnValue = (isFocused) ? 0.18f : 0.20f;
    else if (spinner == self.minuteSpinner)
        returnValue = (isFocused) ? 0.2f : 0.28f;
    else if (spinner == self.amPmSpinner)
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

- (CGFloat)weirdBandWidth {
    return floorf(((1/(6+4/8.0f))/3)*kScreenHeight);
}

- (CGFloat)tertiaryBandWidth {
    return ([self normalBandWidth]*3-[self weirdBandWidth])/3;
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
