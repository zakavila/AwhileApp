//
//  AWYoullBeView.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWYoullBeView.h"
#import "CoreTextArcView.h"

#define NUMBER_OF_CIRCLES 8

#define VERTICAL_MARGIN 20.0f

// year spinner
#define TOTAL_TIME_SPINNER_TEXT_VIEW_VERTICAL_MARGIN 14.0f

// day spinner
#define DAY_SPINNER_TEXT_VIEW_VERTICAL_MARGIN 14.0f

// month spinner
#define MONTH_SPINNER_TEXT_VIEW_VERTICAL_MARGIN 14.0f

// old on circle text view
#define OLD_ON_CIRCLE_TEXT_VIEW_LOWER_PADDING -6.0f

// youll be circle text view
#define YOULL_BE_CIRCLE_TEXT_VIEW_LOWER_PADDING 0.0f

// home button
#define HOME_BUTTON_HORIZONTAL_MARGIN 30.0f

// home image view
#define HOME_IMAGE_VIEW_VERTICAL_MARGIN 14.0f

// screen dimensions
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, CircleType) {
	CircleTypeHome = 0,
	CircleTypeYear = 1,
	CircleTypeDay = 2,
	CircleTypeMonth = 3,
	CircleTypeOldOn = 4,
	CircleTypeUnits = 5,
	CircleTypeTotalTime = 6,
	CircleTypeYoullBe = 7
};

@interface AWYoullBeView () <ZASpinnerViewDelegate>

@property (nonatomic, strong) UIImageView *homeImageView;
@property CoreTextArcView *oldOnCircleTextView;
@property CoreTextArcView *youllBeCircleTextView;

@end

@implementation AWYoullBeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self setUpCircles];
		
		// home image view
		[self addSubview:self.homeImageView];

		self.backgroundColor = [UIColor whiteColor];
    }
	
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (id)initWithFrame:(CGRect)frame andData:(AWDataModel*)data {
    self = [self initWithFrame:frame];
	
    if (self) {
		self.dataModel = data;
    }
	
    return self;
}

#pragma mark - Set up circles

- (void)setUpCircles {
	NSMutableArray *circleViews = [NSMutableArray array];
	
	for (NSUInteger i = 0; i < NUMBER_OF_CIRCLES; i++) {
		UIView *circleView = [[UIView alloc] initWithFrame:CGRectZero];
		
		UIColor *backgroundColor;
		
		if (i == CircleTypeHome) {
			_homeButton = [[UIButton alloc] initWithFrame:CGRectZero];
			[_homeButton addTarget:self action:@selector(homeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];

			[circleView addSubview:_homeButton];
			
			backgroundColor = [UIColor colorWithRed:174.0/255.0 green:0 blue:26.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeYear) {
			
			[circleView addSubview:self.yearSpinner];
			
			backgroundColor = [UIColor colorWithRed:207.0/255.0 green:0 blue:16.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeDay) {
			
			[circleView addSubview:self.daySpinner];
			
			backgroundColor = [UIColor colorWithRed:251.0/255.0 green:24.0/255.0 blue:18.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeMonth) {
			
			[circleView addSubview:self.monthSpinner];
			
			backgroundColor = [UIColor colorWithRed:225.0/255.0 green:70.0/255.0 blue:22.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeOldOn) {
			_oldOnCircleTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
			[_oldOnCircleTextView setText:@"Old on:"];
			[_oldOnCircleTextView setFont:[self circleFont]];
			[_oldOnCircleTextView setColor:[UIColor whiteColor]];
			[_oldOnCircleTextView setBackgroundColor:[UIColor clearColor]];
			
			[circleView addSubview:_oldOnCircleTextView];
			
			backgroundColor = [UIColor colorWithRed:238.0/255.0 green:127.0/255.0 blue:9.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeUnits) {
			
			[circleView addSubview:self.incrementSpinner];
			
			backgroundColor = [UIColor colorWithRed:245.0/255.0 green:163.0/255.0 blue:40.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeTotalTime) {
			
			[circleView addSubview:self.totalTimeSpinner];
			
			backgroundColor = [UIColor colorWithRed:238.0/255.0 green:222.0/255.0 blue:23.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeYoullBe) {
			_youllBeCircleTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
			[_youllBeCircleTextView setText:@"You'll be"];
			[_youllBeCircleTextView setFont:[self circleFont]];
			[_youllBeCircleTextView setColor:[UIColor colorWithRed:205.0/255.0 green:0 blue:0 alpha:1.0]];
			[_youllBeCircleTextView setBackgroundColor:[UIColor clearColor]];
			
			[circleView addSubview:_youllBeCircleTextView];
			
			[circleView setBackgroundColor:[UIColor whiteColor]];
		}
		
		[circleView setClipsToBounds:YES];
		[circleView setBackgroundColor:backgroundColor];
		
		[circleViews addObject:circleView];
	}
	
	[circleViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UIView *circleView = (UIView *)obj;
		
		[self addSubview:circleView];
	}];
	
	_circleViews = [circleViews copy];
}

#pragma mark - Circle font

- (UIFont *)circleFont
{
	UIFont *circleFont = [UIFont fontWithName:[self fontName] size:48.0f];
	return circleFont;
}

- (UIFont*)unfocusedCircleFont
{
    return [UIFont fontWithName:[self fontName] size:36.0f];
}

#pragma mark - Font name 

- (NSString *)fontName {
	NSString *fontName = @"HelveticaNeue-Thin";
	
	return fontName;
}

#pragma mark - Unfocused color

- (UIColor *)unfocusedColor {
	UIColor *unfocusedColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	
	return unfocusedColor;
}

#pragma mark - Focused color

- (UIColor *)focusedColor {
	UIColor *focusedColor = [UIColor whiteColor];
	
	return focusedColor;
}

#pragma mark - Home button touched

- (void)homeButtonTouched:(id)sender {
	UIButton *homeButton = (UIButton *)sender;
	
	if ([self.delegate respondsToSelector:@selector(awYoullBeView:homeButtonTouched:)]) {
		[self.delegate awYoullBeView:self homeButtonTouched:homeButton];
	}
}

- (void)spinner:(ZASpinnerView *)spinner didChangeTo:(NSString *)value
{
    
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
        [contents addObject:[NSString stringWithFormat:@"%d", dayIndex]];
    }
    return contents;
}

- (NSArray*)monthSpinnerContents
{
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    [contents addObject:@"Jan"];
    [contents addObject:@"Feb"];
    [contents addObject:@"Mar"];
    [contents addObject:@"Apr"];
    [contents addObject:@"May"];
    [contents addObject:@"Jun"];
    [contents addObject:@"Jul"];
    [contents addObject:@"Aug"];
    [contents addObject:@"Sep"];
    [contents addObject:@"Oct"];
    [contents addObject:@"Nov"];
    [contents addObject:@"Dec"];
    return contents;
}

- (ZASpinnerView *)totalTimeSpinner
{
    if (!_totalTimeSpinner) {
		_totalTimeSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
		_totalTimeSpinner.spinnerDelegate = self;
		[_totalTimeSpinner setIsInfinite:YES];
		[_totalTimeSpinner setUnfocusedFont:[self unfocusedCircleFont]];
		[_totalTimeSpinner setFocusedFont:[self circleFont]];
        [_totalTimeSpinner setExtraSpacing:-5.0f];
		[_totalTimeSpinner setFocusedFontColor:[UIColor whiteColor]];
		[_totalTimeSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
	}
	
	return _totalTimeSpinner;
}

- (ZASpinnerView*)incrementSpinner
{
    if (!_incrementSpinner) {
		_incrementSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
		_incrementSpinner.spinnerDelegate = self;
		[_incrementSpinner setContents:[self incrementSpinnerContents]];
		[_incrementSpinner setUnfocusedFont:[self unfocusedCircleFont]];
		[_incrementSpinner setFocusedFont:[self circleFont]];
        [_incrementSpinner setExtraSpacing:0.0f];
		[_incrementSpinner setFocusedFontColor:[UIColor whiteColor]];
		[_incrementSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
	}
	
	return _incrementSpinner;
}

- (ZASpinnerView *)monthSpinner
{
    if (!_monthSpinner) {
		_monthSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
		_monthSpinner.spinnerDelegate = self;
		[_monthSpinner setContents:[self monthSpinnerContents]];
		[_monthSpinner setUnfocusedFont:[self unfocusedCircleFont]];
		[_monthSpinner setFocusedFont:[self circleFont]];
        [_monthSpinner setExtraSpacing:-5.0f];
		[_monthSpinner setFocusedFontColor:[UIColor whiteColor]];
		[_monthSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
	}
	
	return _monthSpinner;
}

- (ZASpinnerView *)daySpinner
{
    if (!_daySpinner) {
		_daySpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
		_daySpinner.spinnerDelegate = self;
		[_daySpinner setContents:[self daySpinnerContents]];
		[_daySpinner setUnfocusedFont:[self unfocusedCircleFont]];
		[_daySpinner setFocusedFont:[self circleFont]];
        [_daySpinner setExtraSpacing:-5.0f];
		[_daySpinner setFocusedFontColor:[UIColor whiteColor]];
		[_daySpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
	}
	
	return _daySpinner;
}

- (ZASpinnerView *)yearSpinner
{
    if (!_yearSpinner) {
		_yearSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
		_yearSpinner.spinnerDelegate = self;
        [_yearSpinner setIsInfinite:YES];
        [_yearSpinner setStartIndex:2014];
        [_yearSpinner setUnfocusedFont:[self unfocusedCircleFont]];
		[_yearSpinner setFocusedFont:[self circleFont]];
        [_yearSpinner setExtraSpacing:-5.0f];
		[_yearSpinner setFocusedFontColor:[UIColor whiteColor]];
		[_yearSpinner setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
	}
	
	return _yearSpinner;
}

#pragma mark - Home image view

- (UIImageView *)homeImageView {
	if (!_homeImageView) {
		_homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home"]];
	}
	
	return _homeImageView;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	// circles
	CGFloat initialRadius = (kScreenWidth - 2*HOME_BUTTON_HORIZONTAL_MARGIN)/2;
	CGFloat availableHeight = kScreenHeight - (VERTICAL_MARGIN + initialRadius + self.awhileBar.bounds.size.height + self.awhileBarPaddingView.bounds.size.height);
	CGFloat radiusDelta = floorf(availableHeight/(NUMBER_OF_CIRCLES - 1));
	CGFloat radius = initialRadius;
	CGFloat previousRadius = radius;
	
	NSUInteger index = 0;
	
	for (UIView *circleView in self.circleViews) {
		CGRect frame = circleView.frame;
		
		CGFloat diameter = 2*radius;
		
		frame.size.width = diameter;
		frame.size.height = diameter;
		
		[circleView.layer setCornerRadius:radius];
		[circleView setFrame:frame];
		
		[circleView setCenter:CGPointMake(kScreenWidth/2, kScreenHeight)];
		
		if (index == CircleTypeHome) {
			[_homeButton setFrame:circleView.bounds];
		}
		
		else if (index == CircleTypeYear) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat yearSpinnerHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				yearSpinnerHeight += bottomRadiusPadding;
			}
			
			[_yearSpinner setFrame:CGRectMake(-circleView.frame.origin.x, 0, self.bounds.size.width, radius)];
			
			[_yearSpinner setRadius:radius];
            [_yearSpinner setVerticalShift:-40.0f];
            [_yearSpinner setArcMultiplier:6.2f];
		}
		
		else if (index == CircleTypeDay) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat daySpinnerHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				daySpinnerHeight += bottomRadiusPadding;
			}
			
			[_daySpinner setFrame:CGRectMake(-circleView.frame.origin.x, 0, self.bounds.size.width, daySpinnerHeight)];
			
			[_daySpinner setRadius:radius];
            [_daySpinner setVerticalShift:-25.0f];
            [_daySpinner setArcMultiplier:4.7f];
		}
		
		else if (index == CircleTypeMonth) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat monthSpinnerHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				monthSpinnerHeight += bottomRadiusPadding;
			}
			
			[_monthSpinner setFrame:CGRectMake(-circleView.frame.origin.x, 0, self.bounds.size.width, monthSpinnerHeight)];
			
			[_monthSpinner setRadius:radius];
            [_monthSpinner setVerticalShift:-25.0f];
            [_monthSpinner setArcMultiplier:4.5f];
		}
		
		else if (index == CircleTypeOldOn) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat oldCirleTextArcViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				oldCirleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_oldOnCircleTextView setFrame:CGRectMake(0, 0, circleView.bounds.size.width, oldCirleTextArcViewHeight)];
			[_oldOnCircleTextView setRadius:radius];
			[_oldOnCircleTextView setArcSize:20];
			[_oldOnCircleTextView setShiftV:-(radius/2 + OLD_ON_CIRCLE_TEXT_VIEW_LOWER_PADDING)];
		}
		
		else if (index == CircleTypeUnits) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat incrementSpinnerHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				incrementSpinnerHeight += bottomRadiusPadding;
			}
			
			[_incrementSpinner setFrame:CGRectMake(-circleView.frame.origin.x, 0, self.bounds.size.width, incrementSpinnerHeight)];
			
			[_incrementSpinner setRadius:radius];
            [_incrementSpinner setVerticalShift:-15.0f];
            [_incrementSpinner setArcMultiplier:3.1f];
            [_incrementSpinner setExtraSpacing:20.0f];
		}
        
        else if (index == CircleTypeTotalTime) {
            CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat totalTimeSpinnerHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				totalTimeSpinnerHeight += bottomRadiusPadding;
			}
			
			[_totalTimeSpinner setFrame:CGRectMake(-circleView.frame.origin.x, 0, self.bounds.size.width, totalTimeSpinnerHeight)];
			
			[_totalTimeSpinner setRadius:radius];
            [_totalTimeSpinner setVerticalShift:-15.0f];
            [_totalTimeSpinner setArcMultiplier:2.0f];
        }
		
		else if (index == CircleTypeYoullBe) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat circleTextArcViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				circleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_youllBeCircleTextView setFrame:CGRectMake(0, 0, circleView.bounds.size.width, circleTextArcViewHeight)];
			[_youllBeCircleTextView setRadius:radius];
			[_youllBeCircleTextView setArcSize:20];
			[_youllBeCircleTextView setShiftV:-(radius/2 + YOULL_BE_CIRCLE_TEXT_VIEW_LOWER_PADDING)];
		}
		
		previousRadius = radius;
		radius += radiusDelta;
		
		index++;
	}
	
	// home image view
	CGRect homeImageViewFrame = self.homeImageView.frame;
	homeImageViewFrame.origin.x = (kScreenWidth - homeImageViewFrame.size.width)/2;
	homeImageViewFrame.origin.y = kScreenHeight - (HOME_IMAGE_VIEW_VERTICAL_MARGIN + homeImageViewFrame.size.height);
	[self.homeImageView setFrame:homeImageViewFrame];
}

@end
