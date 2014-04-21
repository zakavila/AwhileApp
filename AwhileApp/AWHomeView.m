//
//  AWHomeView.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWHomeView.h"
#import "CoreTextArcView.h"

#define NUMBER_OF_CIRCLES 3

#define VERTICAL_MARGIN 30.0f

// home button
#define HOME_BUTTON_HORIZONTAL_MARGIN 30.0f

// home image view
#define HOME_IMAGE_VIEW_VERTICAL_MARGIN 14.0f

// calculator circle text arc view
#define CALCULATOR_CIRCLE_TEXT_ARC_VIEW_LOWER_PADDING 30.0f

// your age circle text arc view
#define YOUR_AGE_CIRCLE_TEXT_ARC_VIEW_LOWER_PADDING 50.0f

// screen dimensions
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, CircleType) {
	CircleTypeHome = 0,
	CircleTypeYourAge = 1,
	CircleTypeCalculator = 2
};

@interface AWHomeView ()

@property (nonatomic, strong) CoreTextArcView *yourAgeCircleTextArcView;
@property (nonatomic, strong) CoreTextArcView *calculatorCircleTextArcView;
@property (nonatomic, strong) UIImageView *homeImageView;

@end

@implementation AWHomeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		// status bar
		[self setUpStatusBar];
		
		// circles
		[self setUpCircles];
		
		// home image view
		[self addSubview:self.homeImageView];
    }
    
    return self;
}

#pragma mark - Set up status bar

- (void)setUpStatusBar {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Set up circles

- (void)setUpCircles {
	NSMutableArray *circleViews = [NSMutableArray array];
	
	for (NSUInteger i = 0; i < NUMBER_OF_CIRCLES; i++) {
		UIView *circleView = [[UIView alloc] initWithFrame:CGRectZero];
		
		UIColor *backgroundColor;
		
		if (i == CircleTypeHome) {
			backgroundColor = [UIColor colorWithRed:4.0/255.0 green:141.0/255.0 blue:69.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeCalculator) {
			_calculatorCircleTextArcView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
			[_calculatorCircleTextArcView setText:@"Your age"];
			[_calculatorCircleTextArcView setFont:[self circleFont]];
			[_calculatorCircleTextArcView setColor:[UIColor whiteColor]];
			[_calculatorCircleTextArcView setBackgroundColor:[UIColor clearColor]];
			
			_calculatorButton = [[UIButton alloc] initWithFrame:CGRectZero];
			[_calculatorButton addTarget:self action:@selector(yourAgeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
			
			[circleView addSubview:_calculatorCircleTextArcView];
			[circleView addSubview:_calculatorButton];
			
			backgroundColor = [UIColor colorWithRed:147.0/255.0 green:193.0/255.0 blue:61.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeYourAge) {
			_yourAgeCircleTextArcView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
			[_yourAgeCircleTextArcView setText:@"Calculator"];
			[_yourAgeCircleTextArcView setFont:[self circleFont]];
			[_yourAgeCircleTextArcView setColor:[UIColor whiteColor]];
			[_yourAgeCircleTextArcView setBackgroundColor:[UIColor clearColor]];
			
			_yourAgeButton = [[UIButton alloc] initWithFrame:CGRectZero];
			[_yourAgeButton addTarget:self action:@selector(calculatorButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
			
			[circleView addSubview:_yourAgeCircleTextArcView];
			[circleView addSubview:_yourAgeButton];
			
			backgroundColor = [UIColor colorWithRed:58.0/255.0 green:171.0/255.0 blue:73.0/255.0 alpha:1.0];
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

#pragma mark - Calculator button touched

- (void)calculatorButtonTouched:(id)sender {
	UIButton *calculatorButton = (UIButton *)sender;
	
	if ([self.delegate respondsToSelector:@selector(awHomeView:calculatorButtonTouched:)]) {
		[self.delegate awHomeView:self calculatorButtonTouched:calculatorButton];
	}
}

#pragma mark - Your age button touched 

- (void)yourAgeButtonTouched:(id)sender {
	UIButton *yourAgeButton = (UIButton *)sender;
	
	if ([self.delegate respondsToSelector:@selector(awHomeView:yourAgeButtonTouched:)]) {
		[self.delegate awHomeView:self yourAgeButtonTouched:yourAgeButton];
	}
}

- (UIFont *)circleFont {
	UIFont *circleFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:48.0f];
	
	return circleFont;
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
			// no-op
		}
		
		else if (index == CircleTypeCalculator) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat circleTextArcViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				circleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_calculatorButton setFrame:circleView.bounds];
			
			[_calculatorCircleTextArcView setFrame:CGRectMake(0, 0, circleView.bounds.size.width, circleTextArcViewHeight)];
			
			[_calculatorCircleTextArcView setRadius:radius];
			[_calculatorCircleTextArcView setArcSize:3*_calculatorCircleTextArcView.text.length];
			[_calculatorCircleTextArcView setShiftV:-(radius/2 + CALCULATOR_CIRCLE_TEXT_ARC_VIEW_LOWER_PADDING)];
		}
		
		else if (index == CircleTypeYourAge) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat circleTextArcViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				circleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_yourAgeButton setFrame:circleView.bounds];
			
			[_yourAgeCircleTextArcView setFrame:CGRectMake(0, 0, circleView.bounds.size.width, circleTextArcViewHeight)];
			
			[_yourAgeCircleTextArcView setRadius:radius];
			[_yourAgeCircleTextArcView setArcSize:4*_yourAgeCircleTextArcView.text.length];
			[_yourAgeCircleTextArcView setShiftV:-(radius/2 + YOUR_AGE_CIRCLE_TEXT_ARC_VIEW_LOWER_PADDING)];
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
