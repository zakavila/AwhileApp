//
//  AWYouAreView.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWYouAreView.h"

#define NUMBER_OF_CIRCLES 5

// home button
#define HOME_BUTTON_HORIZONTAL_MARGIN 30.0f

// home image view
#define HOME_IMAGE_VIEW_VERTICAL_MARGIN 14.0f

// you are circle text arc view
#define YOU_ARE_CIRCLE_TEXT_ARC_VIEW_LOWER_PADDING 14.0f

// value text view
#define VALUE_TEXT_VIEW_LOWER_PADDING 8.0f

// old circle text arc view
#define OLD_CIRCLE_TEXT_ARC_VIEW_LOWER_PADDING 30.0f

// increment spinner view font size
#define INCREMENT_SPINNER_VIEW_FONT_SIZE 44.0f

// screen dimensions
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, CircleType) {
	CircleTypeHome = 0,
	CircleTypeOld = 1,
	CircleTypeUnits = 2,
	CircleTypeTotalTime = 3,
	CircleTypeYouAre = 4
};

@interface AWYouAreView ()

@property (nonatomic, strong) UIImageView *homeImageView;
@property (nonatomic, strong) CoreTextArcView *youAreCircleTextArcView;
@property (nonatomic, strong) CoreTextArcView *oldCircleTextArcView;

@end

@implementation AWYouAreView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		// circles
		[self setUpCircles];
		
		// home image view
		[self addSubview:self.homeImageView];
	}
	
	return self;
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
			[circleView setClipsToBounds:YES];
			
			_homeButton = [[UIButton alloc] initWithFrame:CGRectZero];
			[_homeButton addTarget:self action:@selector(homeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
			
			[circleView addSubview:_homeButton];
			
			backgroundColor = [UIColor colorWithRed:128.0/255.0 green:21.0/255.0 blue:34.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeOld) {
			[circleView setClipsToBounds:YES];
			
			_oldCircleTextArcView = [[CoreTextArcView alloc] init];
			[_oldCircleTextArcView setText:@"Old"];
			[_oldCircleTextArcView setFont:[self circleFont]];
			[_oldCircleTextArcView setColor:[UIColor whiteColor]];
			[_oldCircleTextArcView setBackgroundColor:[UIColor clearColor]];
			
			[circleView addSubview:_oldCircleTextArcView];
			
			backgroundColor = [UIColor colorWithRed:189.0/255.0 green:32.0/255.0 blue:37.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeUnits) {
			[circleView addSubview:self.incrementSpinnerView];
			
			backgroundColor = [UIColor colorWithRed:226.0/255.0 green:31.0/255.0 blue:39.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeTotalTime) {
			[circleView setClipsToBounds:YES];
			
			_valueText = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
			_valueText.backgroundColor = [UIColor clearColor];
			_valueText.text = [[self.dataModel youAreUnit:@"Seconds"] stringValue];
			_valueText.color = [UIColor whiteColor];
			[self.valueText setFont:[self circleFont]];
			
			[circleView addSubview:_valueText];
			
			backgroundColor = [UIColor colorWithRed:239.0/255.0 green:59.0/255.0 blue:35.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeYouAre) {
			[circleView setClipsToBounds:YES];
			
			_youAreCircleTextArcView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
			[_youAreCircleTextArcView setText:@"You are:"];
			[_youAreCircleTextArcView setFont:[self circleFont]];
			[_youAreCircleTextArcView setColor:[UIColor blackColor]];
			[_youAreCircleTextArcView setBackgroundColor:[UIColor clearColor]];
			
			[circleView addSubview:_youAreCircleTextArcView];
			
			backgroundColor = [UIColor whiteColor];
		}
		
		[circleView setBackgroundColor:backgroundColor];
		
		[circleViews addObject:circleView];
	}
	
	[circleViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UIView *circleView = (UIView *)obj;
		
		[self addSubview:circleView];
	}];
	
	_circleViews = [circleViews copy];
}

- (void)homeButtonTouched:(id)sender {
	NSLog(@"home button touched");
}

- (UIFont *)circleFont {
	UIFont *circleFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:48.0f];
	
	return circleFont;
}

- (void)spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value {
	if ([self.delegate respondsToSelector:@selector(youAreView:spinner:didChangeTo:)]) {
		[self.delegate youAreView:self spinner:spinner didChangeTo:value];
	}
}

- (NSArray*)incrementSpinnerContents {
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

#pragma mark - Increment spinner contents

- (ZASpinnerView *)incrementSpinnerView {
	if (!_incrementSpinnerView) {
		_incrementSpinnerView = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
		_incrementSpinnerView.spinnerDelegate = self;
		[_incrementSpinnerView setContents:[self incrementSpinnerContents]];
		[_incrementSpinnerView setFocusedFontSize:INCREMENT_SPINNER_VIEW_FONT_SIZE];
		[_incrementSpinnerView setUnfocusedFontSize:INCREMENT_SPINNER_VIEW_FONT_SIZE];
		[_incrementSpinnerView setFocusedFontColor:[UIColor whiteColor]];
		[_incrementSpinnerView setUnfocusedFontColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
	}
	
	return _incrementSpinnerView;
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
	CGFloat availableHeight = kScreenHeight - (initialRadius + self.awhileBar.bounds.size.height + self.awhileBarPaddingView.bounds.size.height);
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
		
		else if (index == CircleTypeOld) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat oldCirleTextArcViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				oldCirleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_oldCircleTextArcView setFrame:CGRectMake(0, 0, circleView.bounds.size.width, oldCirleTextArcViewHeight)];
			[_oldCircleTextArcView setRadius:radius];
			[_oldCircleTextArcView setArcSize:20];
			[_oldCircleTextArcView setShiftV:-(radius/2 + OLD_CIRCLE_TEXT_ARC_VIEW_LOWER_PADDING)];
		}
		
		else if (index == CircleTypeUnits) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat incrementSpinnerViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				incrementSpinnerViewHeight += bottomRadiusPadding;
			}
			
			[_incrementSpinnerView setFrame:CGRectMake(320.0f/2, 0.0, self.frame.size.width, incrementSpinnerViewHeight)];
			
			[_incrementSpinnerView setRadius:previousRadius];
			[_incrementSpinnerView setVerticalShift:2*radius - 60];
		}
		
		else if (index == CircleTypeTotalTime) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat circleTextArcViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				circleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_valueText setFrame:CGRectMake(0, 0, circleView.bounds.size.width, circleTextArcViewHeight)];
			
			[_valueText setRadius:radius];
			
			[_valueText setArcSize:4*_valueText.text.length];
			[_valueText setShiftV:-(radius/2 + VALUE_TEXT_VIEW_LOWER_PADDING)];
		}
		
		else if (index == CircleTypeYouAre) {
			CGFloat bottomRadiusPadding = previousRadius - floorf((previousRadius*sinf(acosf((kScreenWidth/2)/previousRadius))));
			CGFloat circleTextArcViewHeight = radiusDelta;
			
			if (!isnan(bottomRadiusPadding)) {
				circleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_youAreCircleTextArcView setFrame:CGRectMake(0, 0, circleView.bounds.size.width, circleTextArcViewHeight)];
			
			[_youAreCircleTextArcView setRadius:radius];
			[_youAreCircleTextArcView setArcSize:20];
			[_youAreCircleTextArcView setShiftV:-(radius/2 + YOU_ARE_CIRCLE_TEXT_ARC_VIEW_LOWER_PADDING)];
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
