//
//  AWYouAreView.m
//  AwhileApp
//
//  Created by Zak Avila on 4/10/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWYouAreView.h"
#import "AWArcTextSpinnerCell.h"
#import "AWIconSpinnerCell.h"

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
	CircleTypeMenu = 0,
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
		
		if (i == CircleTypeMenu) {
			[circleView setClipsToBounds:YES];
			
			_homeButton = [[UIButton alloc] initWithFrame:CGRectZero];
			[_homeButton addTarget:self action:@selector(homeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
			
			[circleView addSubview:_homeButton];
			
			backgroundColor = [UIColor colorWithRed:13.0/255.0 green:85.0/255.0 blue:39.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeOld) {
			[circleView setClipsToBounds:YES];
			
			_oldCircleTextArcView = [[CoreTextArcView alloc] init];
			[_oldCircleTextArcView setText:@"Old"];
			[_oldCircleTextArcView setFont:[self circleFont]];
			[_oldCircleTextArcView setColor:[UIColor whiteColor]];
			[_oldCircleTextArcView setBackgroundColor:[UIColor clearColor]];
			
			[circleView addSubview:_oldCircleTextArcView];
			
			backgroundColor = [UIColor colorWithRed:49.0/255.0 green:157.0/255.0 blue:40.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeUnits) {
			[circleView addSubview:self.incrementSpinnerView];
			
			backgroundColor = [UIColor colorWithRed:134.0/255.0 green:184.0/255.0 blue:25.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeTotalTime) {
			[circleView setClipsToBounds:YES];
			
			_valueText = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
			_valueText.backgroundColor = [UIColor clearColor];
			_valueText.text = [[self.dataModel youAreUnit:@"Seconds"] stringValue];
			_valueText.color = [UIColor whiteColor];
			[self.valueText setFont:[self circleFont]];
			
			[circleView addSubview:_valueText];
			
			backgroundColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:10.0/255.0 alpha:1.0];
		}
		
		else if (i == CircleTypeYouAre) {
			[circleView setClipsToBounds:YES];
			
			_youAreCircleTextArcView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
			[_youAreCircleTextArcView setText:@"You are:"];
			[_youAreCircleTextArcView setFont:[self circleFont]];
			[_youAreCircleTextArcView setColor:[UIColor colorWithRed:45.0/255.0 green:156.0/255.0 blue:35.0/255.0 alpha:1.0]];
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
	
	UIButton *homeButton = (UIButton *)sender;
	
	if ([self.delegate respondsToSelector:@selector(youAreView:homeButtonTouched:)]) {
		[self.delegate youAreView:self homeButtonTouched:homeButton];
	}
}

- (UIFont *)circleFont {
	UIFont *circleFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:48.0f];
	
	return circleFont;
}

- (UIFont*)unfocusedCircleFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:36.0f];
}

- (CGFloat)spinner:(ZASpinnerView *)spinner heightForRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString*)contentValue
{
//    CGRect dummyRect = CGRectIntegral([contentValue boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:48.0f]} context:nil]);
//    return dummyRect.size.width + 10.0f;
    return 100.0f+20.0f;
}

- (ZASpinnerCell *)spinner:(ZASpinnerView *)spinner cellForRowAtIndexPath:(NSIndexPath *)indexPath withContentValue:(NSString*)contentValue
{
    AWIconSpinnerCell *cell = (AWIconSpinnerCell*)[spinner dequeueReusableCellWithIdentifier:@"ZASpinnerTableViewCellIdentifier"];
//    cell.circularArcText.text = contentValue;
//    cell.circularArcText.radius = spinner.radius;
//    cell.circularArcText.arcSize = spinner.arcMultiplier*contentValue.length;
//    cell.circularArcText.shiftV = -0.534f*spinner.radius-0.8573f;
    cell.icon.backgroundColor = [UIColor blackColor];
    return cell;
}

- (void)spinner:(ZASpinnerView*)spinner didChangeTo:(NSString*)value {
	if ([self.delegate respondsToSelector:@selector(youAreView:spinner:didChangeTo:)]) {
		[self.delegate youAreView:self spinner:spinner didChangeTo:value];
	}
}

- (void)spinner:(ZASpinnerView*)spinner styleForCell:(ZASpinnerCell*)cell whileFocused:(BOOL)isFocused
{
    AWIconSpinnerCell *arcTextCell = (AWIconSpinnerCell*)cell;
    if (isFocused) {
//        arcTextCell.circularArcText.color = [UIColor whiteColor];
//        arcTextCell.circularArcText.font = [self circleFont];
        arcTextCell.icon.backgroundColor = [UIColor redColor];
        arcTextCell.icon.bounds = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    }
    else {
//        arcTextCell.circularArcText.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
//        arcTextCell.circularArcText.font = [self unfocusedCircleFont];
        arcTextCell.icon.backgroundColor = [UIColor blackColor];
        arcTextCell.icon.bounds = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    }
//    [arcTextCell.circularArcText setNeedsDisplay];
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
        [_incrementSpinnerView registerClass:[AWIconSpinnerCell class] forCellReuseIdentifier:@"ZASpinnerTableViewCellIdentifier"];
		[_incrementSpinnerView setContents:[self incrementSpinnerContents]];
        [_incrementSpinnerView setExtraSpacing:-5.0f];
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
		
		if (index == CircleTypeMenu) {
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
			
			[_incrementSpinnerView setFrame:CGRectMake(-circleView.frame.origin.x, 0.0, self.bounds.size.width, incrementSpinnerViewHeight)];
			[_incrementSpinnerView setRadius:previousRadius];
            [_incrementSpinnerView setVerticalShift:-55.0f];
            [_incrementSpinnerView setArcMultiplier:5.8f];
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
