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

- (id)init {
    self = [super init];
	
    if (self) {
		[self setUpCircles];
		
		// home image view
		[self addSubview:self.homeImageView];
		
		self.backgroundColor = [UIColor whiteColor];
    }
	
    return self;
}

- (id)initWithFrame:(CGRect)frame andData:(AWDataModel*)data {
    self = [self init];
	
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
			_yearSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
			[_yearSpinner setSpinnerDelegate:self];
			
			UIFont *yearSpinnerUnfocusedFont = [UIFont fontWithName:[self fontName] size:18.0f];
			UIFont *yearSpinnerFocusedFont = [UIFont fontWithName:[self fontName] size:24.0f];
			
			[_yearSpinner setUnfocusedFont:yearSpinnerUnfocusedFont];
			[_yearSpinner setFocusedFont:yearSpinnerFocusedFont];
			
			[_yearSpinner setUnfocusedFontColor:[self unfocusedColor]];
			[_yearSpinner setFocusedFontColor:[self focusedColor]];
			
			[circleView addSubview:_yearSpinner];
			
			backgroundColor = [UIColor colorWithRed:207.0/255.0 green:0 blue:16.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeDay) {
			_daySpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
			
			UIFont *daySpinnerUnfocusedFont = [UIFont fontWithName:[self fontName] size:18.0f];
			UIFont *daySpinnerFocusedFont = [UIFont fontWithName:[self fontName] size:24.0f];
			
			[_daySpinner setUnfocusedFont:daySpinnerUnfocusedFont];
			[_daySpinner setFocusedFont:daySpinnerFocusedFont];
			
			[_daySpinner setUnfocusedFontColor:[self unfocusedColor]];
			[_daySpinner setFocusedFontColor:[self focusedColor]];
			
			[_daySpinner setContents:[self daySpinnerContents]];
			
			[circleView addSubview:_daySpinner];
			
			backgroundColor = [UIColor colorWithRed:251.0/255.0 green:24.0/255.0 blue:18.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeMonth) {
			_monthSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
			
			UIFont *monthSpinnerUnfocusedFont = [UIFont fontWithName:[self fontName] size:18.0f];
			UIFont *monthSpinnerFocusedFont = [UIFont fontWithName:[self fontName] size:24.0f];
			
			[_monthSpinner setUnfocusedFont:monthSpinnerUnfocusedFont];
			[_monthSpinner setFocusedFont:monthSpinnerFocusedFont];
			
			[_monthSpinner setUnfocusedFontColor:[self unfocusedColor]];
			[_monthSpinner setFocusedFontColor:[self focusedColor]];
			
			[_monthSpinner setContents:[self monthSpinnerContents]];
			
			[circleView addSubview:_monthSpinner];
			
			backgroundColor = [UIColor colorWithRed:225.0/255.0 green:70.0/255.0 blue:22.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeOldOn) {
			_oldOnCircleTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
			[_oldOnCircleTextView setText:@"Old on"];
			[_oldOnCircleTextView setFont:[self circleFont]];
			[_oldOnCircleTextView setColor:[UIColor whiteColor]];
			[_oldOnCircleTextView setBackgroundColor:[UIColor clearColor]];
			
			[circleView addSubview:_oldOnCircleTextView];
			
			backgroundColor = [UIColor colorWithRed:238.0/255.0 green:127.0/255.0 blue:9.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeUnits) {
			_incrementSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
			
			UIFont *incrementSpinnerUnfocusedFont = [UIFont fontWithName:[self fontName] size:18.0f];
			UIFont *incrementSpinnerFocusedFont = [UIFont fontWithName:[self fontName] size:24.0f];
			
			[_incrementSpinner setUnfocusedFont:incrementSpinnerUnfocusedFont];
			[_incrementSpinner setFocusedFont:incrementSpinnerFocusedFont];
			
			[_incrementSpinner setUnfocusedFontColor:[self unfocusedColor]];
			[_incrementSpinner setFocusedFontColor:[self focusedColor]];
			
			[circleView addSubview:_incrementSpinner];
			
			backgroundColor = [UIColor colorWithRed:245.0/255.0 green:163.0/255.0 blue:40.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeTotalTime) {
			_totalTimeSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
			
			UIFont *totalTimeSpinnerUnfocusedFont = [UIFont fontWithName:[self fontName] size:18.0f];
			UIFont *totalTimeSpinnerFocusedFont = [UIFont fontWithName:[self fontName] size:24.0f];
			
			[_totalTimeSpinner setUnfocusedFont:totalTimeSpinnerUnfocusedFont];
			[_totalTimeSpinner setFocusedFont:totalTimeSpinnerFocusedFont];
			
			[_totalTimeSpinner setUnfocusedFontColor:[self unfocusedColor]];
			[_totalTimeSpinner setFocusedFontColor:[self focusedColor]];
			
			[_totalTimeSpinner setIsInfinite:YES];
			
			[circleView addSubview:_totalTimeSpinner];
			
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

- (UIFont *)circleFont {
	UIFont *circleFont = [UIFont fontWithName:[self fontName] size:48.0f];
	
	return circleFont;
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
			CGFloat circleTextArcViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				circleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_yearSpinner setFrame:CGRectMake(0, 0, circleView.bounds.size.width, circleTextArcViewHeight)];
			
			[_yearSpinner setRadius:radius];
			[_yearSpinner setVerticalShift:2*radius - 60];
		}
		
		else if (index == CircleTypeDay) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat circleTextArcViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				circleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_daySpinner setFrame:CGRectMake(0, 0, circleView.bounds.size.width, circleTextArcViewHeight)];
			
			[_daySpinner setRadius:radius];
			[_daySpinner setVerticalShift:2*radius - 60];
		}
		
		else if (index == CircleTypeMonth) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat circleTextArcViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				circleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_monthSpinner setFrame:CGRectMake(0, 0, circleView.bounds.size.width, circleTextArcViewHeight)];
			
			[_monthSpinner setRadius:radius];
			[_monthSpinner setVerticalShift:2*radius - 60];
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
			CGFloat circleTextArcViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				circleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_incrementSpinner setFrame:CGRectMake(0, 0, circleView.bounds.size.width, circleTextArcViewHeight)];
			
			[_incrementSpinner setRadius:radius];
			[_incrementSpinner setVerticalShift:2*radius - 60];
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
