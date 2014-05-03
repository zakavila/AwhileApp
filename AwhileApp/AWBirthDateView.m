//
//  AWBirthDateView.m
//  AwhileApp
//
//  Created by Deren Kudeki on 4/25/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWBirthDateView.h"
#import "AWArcTextSpinnerCell.h"
#import "AWSpinnerContents.h"

#define NUMBER_OF_CIRCLES 8

#define NEXT_CIRCLE_R 255
#define NEXT_CIRCLE_G 255
#define NEXT_CIRCLE_B 255
#define DAY_CIRCLE_R 60
#define DAY_CIRCLE_G 60
#define DAY_CIRCLE_B 59
#define DAY_LABEL_CIRCLE_R 87
#define DAY_LABEL_CIRCLE_G 87
#define DAY_LABEL_CIRCLE_B 86
#define MONTH_CIRCLE_R 135
#define MONTH_CIRCLE_G 135
#define MONTH_CIRCLE_B 135
#define MONTH_LABEL_CIRCLE_R 157
#define MONTH_LABEL_CIRCLE_G 157
#define MONTH_LABEL_CIRCLE_B 156
#define YEAR_CIRCLE_R 198
#define YEAR_CIRCLE_G 198
#define YEAR_CIRCLE_B 198
#define YEAR_LABEL_CIRCLE_R 218
#define YEAR_LABEL_CIRCLE_G 218
#define YEAR_LABEL_CIRCLE_B 218
#define HEADER_CIRCLE_R 255
#define HEADER_CIRCLE_G 255
#define HEADER_CIRCLE_B 255

#define ARCTEXT_SPINNER_CELL_IDENTIFIER @"ArcTextSpinnerCellIdentifier"

#define FOCUSED_FONT_NAME @"HelveticaNeue-Light"
#define UNFOCUSED_FONT_NAME @"HelveticaNeue-UltraLight"
#define FOCUSED_FONT_SIZE 48.0f
#define UNFOCUSED_FONT_SIZE 32.0f
#define LABEL_FONT_SIZE 24.0f

typedef NS_ENUM(NSInteger, CircleType) {
    CircleTypeNext = 0,
    CircleTypeDay = 1,
    CircleTypeDayLabel = 2,
    CircleTypeMonth = 3,
    CircleTypeMonthLabel = 4,
    CircleTypeYear = 5,
    CircleTypeYearLabel = 6,
    CircleTypeHeader = 7
};

@interface AWBirthDateView ()
@property (nonatomic, strong) NSMutableArray *circleViews;
@property (nonatomic, strong) UIImageView *awhileLogo;
@property (nonatomic, strong) UIImageView *woodRings;
@property (nonatomic, strong) UIImageView *nextButtonView;
@property (nonatomic, strong) CoreTextArcView *dayTextView;
@property (nonatomic, strong) CoreTextArcView *monthTextView;
@property (nonatomic, strong) CoreTextArcView *yearTextView;
@property (nonatomic, strong) CoreTextArcView *yourBirthdayTextView;
@end

@implementation AWBirthDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpCircles];
    }
    return self;
}

- (void) setUpCircles
{
    self.circleViews = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < NUMBER_OF_CIRCLES; i++) {
        UIView *circleView = [[UIView alloc] init];
        UIColor *backgroundColor;
        if (i == CircleTypeNext) {
            [circleView addSubview:self.woodRings];
            [circleView addSubview:self.awhileLogo];
            [circleView addSubview:self.nextButton];
            backgroundColor = [UIColor colorWithRed:NEXT_CIRCLE_R/255.0f green:NEXT_CIRCLE_G/255.0f blue:NEXT_CIRCLE_B/255.0f alpha:0.0f];
        }
        else if (i == CircleTypeDay) {
            [circleView addSubview:self.daySpinner];
            backgroundColor = [UIColor colorWithRed:DAY_CIRCLE_R/255.0f green:DAY_CIRCLE_G/255.0f blue:DAY_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeDayLabel) {
            [circleView addSubview:self.dayTextView];
            backgroundColor = [UIColor colorWithRed:DAY_LABEL_CIRCLE_R/255.0f green:DAY_LABEL_CIRCLE_G/255.0f blue:DAY_LABEL_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeMonth) {
            [circleView addSubview:self.monthSpinner];
            backgroundColor = [UIColor colorWithRed:MONTH_CIRCLE_R/255.0f green:MONTH_CIRCLE_G/255.0f blue:MONTH_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeMonthLabel) {
            [circleView addSubview:self.monthTextView];
            backgroundColor = [UIColor colorWithRed:MONTH_LABEL_CIRCLE_R/255.0f green:MONTH_LABEL_CIRCLE_G/255.0f blue:MONTH_LABEL_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeYear) {
            [circleView addSubview:self.yearSpinner];
            backgroundColor = [UIColor colorWithRed:YEAR_CIRCLE_R/255.0f green:YEAR_CIRCLE_G/255.0f blue:YEAR_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeYearLabel) {
            [circleView addSubview:self.yearTextView];
            backgroundColor = [UIColor colorWithRed:YEAR_LABEL_CIRCLE_R/255.0f green:YEAR_LABEL_CIRCLE_G/255.0f blue:YEAR_LABEL_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeHeader) {
            [circleView addSubview:self.yourBirthdayTextView];
            backgroundColor = [UIColor colorWithRed:HEADER_CIRCLE_R/255.0f green:HEADER_CIRCLE_G/255.0f blue:HEADER_CIRCLE_B/255.0f alpha:1.0f];
        }
        circleView.backgroundColor = backgroundColor;
        [self.circleViews addObject:circleView];
    }
    [self.circleViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addSubview:(UIView*)obj];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat fullRadius = [self nextDiameter]/2;
    CGFloat previousFullRadius = 0.0f;
    CGFloat offScreenRadius = [self nextDiameter]/2 - [self shownNextRadius];
    for (NSUInteger circleIndex = 0; circleIndex < NUMBER_OF_CIRCLES; circleIndex++)
    {
        UIView *circleView = [self.circleViews objectAtIndex:circleIndex];
        CGFloat diameter = 2*fullRadius;
        circleView.frame =  CGRectMake(circleView.frame.origin.x, circleView.frame.origin.y, diameter, diameter);
        circleView.layer.cornerRadius = fullRadius;
        circleView.layer.masksToBounds = YES;
        circleView.center = CGPointMake(kScreenWidth/2, kScreenHeight+offScreenRadius);
        CGFloat spinnerOriginX = -circleView.frame.origin.x;
        CGFloat spinnerHeight = [self saggitaForRadius:previousFullRadius] + [self normalBandWidth];
        
        if (circleIndex == CircleTypeNext) {
            self.awhileLogo.frame = CGRectMake((kScreenWidth/3) - (154/12), 15.0f, 154/2, 42/2);
            self.nextButton.frame = CGRectMake((kScreenWidth/3) - (154/12) - 10, 30.0f, 100, 100);
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self normalBandWidth];
        }
        else if (circleIndex == CircleTypeDay) {
            #warning Fix spinner to work with more full circles
            self.daySpinner.frame = CGRectMake(spinnerOriginX+30, 0.0f, kScreenWidth-60, fullRadius);
            self.daySpinner.radius = previousFullRadius;
            self.daySpinner.verticalShift = -65.0f;
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self weirdBandWidth];
        }
        else if (circleIndex == CircleTypeDayLabel) {
            CGFloat bottomRadiusPadding = fullRadius - floorf((fullRadius*sinf(acosf((kScreenWidth/2)/fullRadius))));
			CGFloat oldCirleTextArcViewHeight = fullRadius;
			
			if (!isnan(bottomRadiusPadding)) {
				oldCirleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_dayTextView setFrame:CGRectMake(0.0, 0.0f, circleView.bounds.size.width, oldCirleTextArcViewHeight)];
			[_dayTextView setRadius:previousFullRadius];
			[_dayTextView setArcSize:12];
			[_dayTextView setShiftV:22.0f];
            
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self normalBandWidth];
        }
        else if (circleIndex == CircleTypeMonth) {
            self.monthSpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, spinnerHeight);
            self.monthSpinner.radius = previousFullRadius;
            self.monthSpinner.verticalShift = -35.0f;
            
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self weirdBandWidth];
        }
        else if (circleIndex == CircleTypeMonthLabel) {
            CGFloat bottomRadiusPadding = fullRadius - floorf((fullRadius*sinf(acosf((kScreenWidth/2)/fullRadius))));
			CGFloat oldCirleTextArcViewHeight = fullRadius;
			
			if (!isnan(bottomRadiusPadding)) {
				oldCirleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_monthTextView setFrame:CGRectMake(0.0, 0.0f, circleView.bounds.size.width, oldCirleTextArcViewHeight)];
			[_monthTextView setRadius:previousFullRadius];
			[_monthTextView setArcSize:12];
			[_monthTextView setShiftV:11.0f];
            
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self normalBandWidth];
        }
        else if (circleIndex == CircleTypeYear) {
            self.yearSpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, spinnerHeight);
            self.yearSpinner.radius = previousFullRadius;
            self.yearSpinner.verticalShift = -15.0f;
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self weirdBandWidth];
        }
        else if (circleIndex == CircleTypeYearLabel) {
            CGFloat bottomRadiusPadding = fullRadius - floorf((fullRadius*sinf(acosf((kScreenWidth/2)/fullRadius))));
			CGFloat oldCirleTextArcViewHeight = fullRadius;
			
			if (!isnan(bottomRadiusPadding)) {
				oldCirleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_yearTextView setFrame:CGRectMake(0.0, 0.0f, circleView.bounds.size.width, oldCirleTextArcViewHeight)];
			[_yearTextView setRadius:previousFullRadius];
			[_yearTextView setArcSize:7];
			[_yearTextView setShiftV:5.0f];
            
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self normalBandWidth];
        }
        else if (circleIndex == CircleTypeHeader) {
            CGFloat bottomRadiusPadding = fullRadius - floorf((fullRadius*sinf(acosf((kScreenWidth/2)/fullRadius))));
			CGFloat oldCirleTextArcViewHeight = fullRadius;
			
			if (!isnan(bottomRadiusPadding)) {
				oldCirleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_yourBirthdayTextView setFrame:CGRectMake(0.0, 0.0f, circleView.bounds.size.width, oldCirleTextArcViewHeight)];
			[_yourBirthdayTextView setRadius:previousFullRadius];
			[_yourBirthdayTextView setArcSize:30];
			[_yourBirthdayTextView setShiftV:-5.0f];
            
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self normalBandWidth];
        }
        
        //previousFullRadius = fullRadius;
        //fullRadius = previousFullRadius + [self normalBandWidth];
    }
}

- (ZASpinnerView*)daySpinner
{
    if (!_daySpinner) {
        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date]];
        
        _daySpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _daySpinner.spinnerDelegate = self;
        _daySpinner.contents = [AWSpinnerContents dayContentsForMonthIndex:0];
        _daySpinner.startIndex = [components day] - 1;
        _daySpinner.spinnerName = @"daySpinner";
        [_daySpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _daySpinner;
}

- (CoreTextArcView*)dayTextView
{
    if (!_dayTextView) {
        _dayTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
        [_dayTextView setText:@"Day:"];
        [_dayTextView setFont:[UIFont fontWithName:FOCUSED_FONT_NAME size:LABEL_FONT_SIZE]];
        [_dayTextView setColor:[UIColor whiteColor]];
        [_dayTextView setBackgroundColor:[UIColor clearColor]];
    }
    return _dayTextView;
}

- (ZASpinnerView*)monthSpinner
{
    if (!_monthSpinner) {
         NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:[NSDate date]];
        
        _monthSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _monthSpinner.spinnerDelegate = self;
        _monthSpinner.contents = [AWSpinnerContents monthContents];
        _monthSpinner.startIndex = [components month] - 1;
        _monthSpinner.spinnerName = @"monthSpinner";
        [_monthSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _monthSpinner;
}

- (CoreTextArcView*)monthTextView
{
    if (!_monthTextView) {
        _monthTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
        [_monthTextView setText:@"Month:"];
        [_monthTextView setFont:[UIFont fontWithName:FOCUSED_FONT_NAME size:LABEL_FONT_SIZE]];
        [_monthTextView setColor:[UIColor whiteColor]];
        [_monthTextView setBackgroundColor:[UIColor clearColor]];
    }
    return _monthTextView;
}

- (ZASpinnerView*)yearSpinner
{
    if (!_yearSpinner) {
        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
        
        _yearSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _yearSpinner.spinnerDelegate = self;
        _yearSpinner.spinnerType = InfiniteCountSpinner;
        _yearSpinner.startIndex = [components year] + 75;
        _yearSpinner.spinnerName = @"yearSpinner";
        [_yearSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _yearSpinner;
}

- (CoreTextArcView*)yearTextView
{
    if (!_yearTextView) {
        _yearTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
        [_yearTextView setText:@"Year:"];
        [_yearTextView setFont:[UIFont fontWithName:FOCUSED_FONT_NAME size:LABEL_FONT_SIZE]];
        [_yearTextView setColor:[UIColor whiteColor]];
        [_yearTextView setBackgroundColor:[UIColor clearColor]];
    }
    return _yearTextView;
}

- (CoreTextArcView*)yourBirthdayTextView
{
    if (!_yourBirthdayTextView) {
        _yourBirthdayTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
        [_yourBirthdayTextView setText:@"Your birthday:"];
        [_yourBirthdayTextView setFont:[UIFont fontWithName:UNFOCUSED_FONT_NAME size:48.0f]];
        [_yourBirthdayTextView setColor:[UIColor blackColor]];
        [_yourBirthdayTextView setBackgroundColor:[UIColor clearColor]];
    }
    return _yourBirthdayTextView;
}

- (UIButton*)nextButton
{
    if (!_nextButton)
    {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_nextButton addTarget:self action:@selector(nextButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_nextButton setImage:[UIImage imageNamed:@"NextButton"] forState:UIControlStateNormal];
        //[_nextButton.imageView setImage:[UIImage imageNamed:@"NextButton"]];
    }
    return _nextButton;
}

- (void)nextButtonTouched:(id)sender {
	UIButton *nextButton = (UIButton *)sender;
	
	if ([self.delegate respondsToSelector:@selector(birthDateView:nextButtonTouched:)]) {
		[self.delegate birthDateView:self nextButtonTouched:nextButton];
	}
}

- (CGFloat)spinner:(ZASpinnerView *)spinner heightForRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString *)contentValue
{
    CGFloat returnValue;
    CGRect dummyRect = CGRectIntegral([contentValue boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:FOCUSED_FONT_NAME size:FOCUSED_FONT_SIZE]} context:nil]);
    returnValue = dummyRect.size.height+ceilf(dummyRect.size.width*0.5);
    return returnValue;
}

- (ZASpinnerCell *)spinner:(ZASpinnerView *)spinner cellForRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString *)contentValue
{
    ZASpinnerCell *cell;
    AWArcTextSpinnerCell *arcTextCell = [spinner dequeueReusableCellWithIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    arcTextCell.circularArcText.text = contentValue;
    arcTextCell.circularArcText.radius = spinner.radius;
    arcTextCell.circularArcText.shiftV = -0.534f*spinner.radius-0.8573f;
    arcTextCell.circularArcText.color = [UIColor whiteColor];
    cell = arcTextCell;
    
    return cell;
}

- (void)spinner:(ZASpinnerView *)spinner styleForCell:(ZASpinnerCell *)cell whileFocused:(BOOL)isFocused
{
    [self styleArcTextForSpinner:spinner styleForCell:cell whileFocused:isFocused];
    
}

- (void)spinner:(ZASpinnerView *)spinner didChangeTo:(NSString *)value
{
    [self.delegate birthDateView:self spinner:spinner didChangeTo:value];
}

- (void)mainView:(AWBirthDateView*)birthDateView spinner:(ZASpinnerView*)spinner didSelectRowAtIndexPath:(NSIndexPath*)indexPath withContentValue:(NSString*)contentValue
{
    [self.delegate birthDateView:self spinner:spinner didSelectRowAtIndexPath:indexPath withContentValue:contentValue];
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
    if (spinner == self.yearSpinner)
    {
        arcTextCell.circularArcText.arcSize = [self arcMultiplierForSpinner:spinner andFocused:isFocused]*dummyRect.size.width/2.3;
    }
    else if (spinner == self.monthSpinner)
    {
        arcTextCell.circularArcText.arcSize = [self arcMultiplierForSpinner:spinner andFocused:isFocused]*dummyRect.size.width*1.3;
    }
    else
    {
        arcTextCell.circularArcText.arcSize = [self arcMultiplierForSpinner:spinner andFocused:isFocused]*dummyRect.size.width*1.7;
    }
    arcTextCell.circularArcText.bounds = CGRectMake(0.0f, 0.0f, arcTextCell.bounds.size.width+(dummyRect.size.width*1.3-arcTextCell.bounds.size.width), arcTextCell.bounds.size.height);
    [arcTextCell.circularArcText setNeedsDisplay];
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

- (UIImageView*)nextButtonView
{
    if (!_awhileLogo) {
        _awhileLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NextButton"]];
    }
    return _awhileLogo;
}

- (CGFloat)unfocusedIconSize
{
    return floorf(35.0f/568*kScreenHeight);
}

- (CGFloat)normalBandWidth {
    return floorf((1/(6+4/8.0f))*kScreenHeight);
}

- (CGFloat)weirdBandWidth {
    return floorf(((1/(6+4/8.0f))/3)*kScreenHeight);
}


- (CGFloat)saggitaForRadius:(CGFloat)radius
{
    return floorf(radius-sqrtf(powf(radius,2.0f)-powf(kScreenWidth/2.0f,2)));
}

- (CGFloat)nextDiameter {
    return floorf(3.5f/4.25f*kScreenWidth);
}

- (CGFloat)shownNextRadius {
    return floorf(1.5f/(7+5/8.0f)*kScreenHeight);
}

- (CGFloat)arcMultiplierForSpinner:(ZASpinnerView*)spinner andFocused:(BOOL)isFocused
{
    CGFloat returnValue;
    if (spinner == self.daySpinner)
        returnValue = (isFocused) ? 0.2f : 0.28f;
    else if (spinner == self.monthSpinner)
        returnValue = (isFocused) ? 0.18f : 0.20f;
    else if (spinner == self.yearSpinner)
        returnValue = (isFocused) ? 0.33f : 0.35f;
    return returnValue;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
