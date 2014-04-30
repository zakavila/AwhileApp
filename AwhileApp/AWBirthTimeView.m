//
//  AWBirthTimeView.m
//  AwhileApp
//
//  Created by Deren Kudeki on 4/29/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWBirthTimeView.h"
#import "AWArcTextSpinnerCell.h"

#define NUMBER_OF_CIRCLES 8

#define NEXT_CIRCLE_R 255
#define NEXT_CIRCLE_G 255
#define NEXT_CIRCLE_B 255
#define PART_CIRCLE_R 60
#define PART_CIRCLE_G 60
#define PART_CIRCLE_B 59
#define PART_LABEL_CIRCLE_R 87
#define PART_LABEL_CIRCLE_G 87
#define PART_LABEL_CIRCLE_B 86
#define MINUTES_CIRCLE_R 135
#define MINUTES_CIRCLE_G 135
#define MINUTES_CIRCLE_B 135
#define MINUTES_LABEL_CIRCLE_R 157
#define MINUTES_LABEL_CIRCLE_G 157
#define MINUTES_LABEL_CIRCLE_B 156
#define HOUR_CIRCLE_R 198
#define HOUR_CIRCLE_G 198
#define HOUR_CIRCLE_B 198
#define HOUR_LABEL_CIRCLE_R 218
#define HOUR_LABEL_CIRCLE_G 218
#define HOUR_LABEL_CIRCLE_B 218
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
    CircleTypePart = 1,
    CircleTypePartLabel = 2,
    CircleTypeMinutes = 3,
    CircleTypeMinutesLabel = 4,
    CircleTypeHour = 5,
    CircleTypeHourLabel = 6,
    CircleTypeHeader = 7
};

@interface AWBirthTimeView ()
@property (nonatomic, strong) NSMutableArray *circleViews;
@property (nonatomic, strong) UIImageView *awhileLogo;
@property (nonatomic, strong) UIImageView *woodRings;
@property (nonatomic, strong) UIImageView *nextButtonView;
@property (nonatomic, strong) ZASpinnerView *partSpinner;
@property (nonatomic, strong) CoreTextArcView *partTextView;
@property (nonatomic, strong) ZASpinnerView *minutesSpinner;
@property (nonatomic, strong) CoreTextArcView *minutesTextView;
@property (nonatomic, strong) ZASpinnerView *hourSpinner;
@property (nonatomic, strong) CoreTextArcView *hourTextView;
@property (nonatomic, strong) CoreTextArcView *yourBirthTimeTextView;
@end

@implementation AWBirthTimeView

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
        else if (i == CircleTypePart) {
            [circleView addSubview:self.partSpinner];
            backgroundColor = [UIColor colorWithRed:PART_CIRCLE_R/255.0f green:PART_CIRCLE_G/255.0f blue:PART_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypePartLabel) {
            [circleView addSubview:self.partTextView];
            backgroundColor = [UIColor colorWithRed:PART_LABEL_CIRCLE_R/255.0f green:PART_LABEL_CIRCLE_G/255.0f blue:PART_LABEL_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeMinutes) {
            [circleView addSubview:self.minutesSpinner];
            backgroundColor = [UIColor colorWithRed:MINUTES_CIRCLE_R/255.0f green:MINUTES_CIRCLE_G/255.0f blue:MINUTES_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeMinutesLabel) {
            [circleView addSubview:self.minutesTextView];
            backgroundColor = [UIColor colorWithRed:MINUTES_LABEL_CIRCLE_R/255.0f green:MINUTES_LABEL_CIRCLE_G/255.0f blue:MINUTES_LABEL_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeHour) {
            [circleView addSubview:self.hourSpinner];
            backgroundColor = [UIColor colorWithRed:HOUR_CIRCLE_R/255.0f green:HOUR_CIRCLE_G/255.0f blue:HOUR_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeHourLabel) {
            [circleView addSubview:self.hourTextView];
            backgroundColor = [UIColor colorWithRed:HOUR_LABEL_CIRCLE_R/255.0f green:HOUR_LABEL_CIRCLE_G/255.0f blue:HOUR_LABEL_CIRCLE_B/255.0f alpha:1.0f];
        }
        else if (i == CircleTypeHeader) {
            [circleView addSubview:self.yourBirthTimeTextView];
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
            self.nextButton.frame = CGRectMake((kScreenWidth/3) - (154/12), 30.0f, 100, 100);
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self normalBandWidth];
        }
        else if (circleIndex == CircleTypePart) {
            self.partSpinner.frame = CGRectMake(spinnerOriginX+30, 0.0f, kScreenWidth-60, fullRadius);
            self.partSpinner.radius = previousFullRadius;
            self.partSpinner.verticalShift = -65.0f;
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self weirdBandWidth];
        }
        else if (circleIndex == CircleTypePartLabel) {
            CGFloat bottomRadiusPadding = fullRadius - floorf((fullRadius*sinf(acosf((kScreenWidth/2)/fullRadius))));
			CGFloat oldCirleTextArcViewHeight = fullRadius;
			
			if (!isnan(bottomRadiusPadding)) {
				oldCirleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_partTextView setFrame:CGRectMake(0.0, 0.0f, circleView.bounds.size.width, oldCirleTextArcViewHeight)];
			[_partTextView setRadius:previousFullRadius];
			[_partTextView setArcSize:24];
			[_partTextView setShiftV:22.0f];
            
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self normalBandWidth];
        }
        else if (circleIndex == CircleTypeMinutes) {
            self.minutesSpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, spinnerHeight);
            self.minutesSpinner.radius = previousFullRadius;
            self.minutesSpinner.verticalShift = -35.0f;
            
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self weirdBandWidth];
        }
        else if (circleIndex == CircleTypeMinutesLabel) {
            CGFloat bottomRadiusPadding = fullRadius - floorf((fullRadius*sinf(acosf((kScreenWidth/2)/fullRadius))));
			CGFloat oldCirleTextArcViewHeight = fullRadius;
			
			if (!isnan(bottomRadiusPadding)) {
				oldCirleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_minutesTextView setFrame:CGRectMake(0.0, 0.0f, circleView.bounds.size.width, oldCirleTextArcViewHeight)];
			[_minutesTextView setRadius:previousFullRadius];
			[_minutesTextView setArcSize:14];
			[_minutesTextView setShiftV:11.0f];
            
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self normalBandWidth];
        }
        else if (circleIndex == CircleTypeHour) {
            self.hourSpinner.frame = CGRectMake(spinnerOriginX, 0.0f, kScreenWidth, spinnerHeight);
            self.hourSpinner.radius = previousFullRadius;
            self.hourSpinner.verticalShift = -15.0f;
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self weirdBandWidth];
        }
        else if (circleIndex == CircleTypeHourLabel) {
            CGFloat bottomRadiusPadding = fullRadius - floorf((fullRadius*sinf(acosf((kScreenWidth/2)/fullRadius))));
			CGFloat oldCirleTextArcViewHeight = fullRadius;
			
			if (!isnan(bottomRadiusPadding)) {
				oldCirleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_hourTextView setFrame:CGRectMake(0.0, 0.0f, circleView.bounds.size.width, oldCirleTextArcViewHeight)];
			[_hourTextView setRadius:previousFullRadius];
			[_hourTextView setArcSize:7];
			[_hourTextView setShiftV:5.0f];
            
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self normalBandWidth];
        }
        else if (circleIndex == CircleTypeHeader) {
            CGFloat bottomRadiusPadding = fullRadius - floorf((fullRadius*sinf(acosf((kScreenWidth/2)/fullRadius))));
			CGFloat oldCirleTextArcViewHeight = fullRadius;
			
			if (!isnan(bottomRadiusPadding)) {
				oldCirleTextArcViewHeight += bottomRadiusPadding;
			}
			
			[_yourBirthTimeTextView setFrame:CGRectMake(0.0, 0.0f, circleView.bounds.size.width, oldCirleTextArcViewHeight)];
			[_yourBirthTimeTextView setRadius:previousFullRadius];
			[_yourBirthTimeTextView setArcSize:34];
			[_yourBirthTimeTextView setShiftV:-5.0f];
            
            previousFullRadius = fullRadius;
            fullRadius = previousFullRadius + [self normalBandWidth];
        }
    }
}

- (ZASpinnerView*)partSpinner
{
    if (!_partSpinner) {
        _partSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _partSpinner.spinnerDelegate = self;
        _partSpinner.contents = [self partSpinnerContents];
        _partSpinner.startIndex = 0;
        _partSpinner.spinnerName = @"partSpinner";
        [_partSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _partSpinner;
}

- (CoreTextArcView*)partTextView
{
    if (!_partTextView) {
        _partTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
        [_partTextView setText:@"Part of day:"];
        [_partTextView setFont:[UIFont fontWithName:FOCUSED_FONT_NAME size:LABEL_FONT_SIZE]];
        [_partTextView setColor:[UIColor whiteColor]];
        [_partTextView setBackgroundColor:[UIColor clearColor]];
    }
    return _partTextView;
}

- (ZASpinnerView*)minutesSpinner
{
    if (!_minutesSpinner) {
        _minutesSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _minutesSpinner.spinnerDelegate = self;
        _minutesSpinner.contents = [self minutesSpinnerContents];
        _minutesSpinner.startIndex = 0;
        _minutesSpinner.spinnerName = @"minutesSpinner";
        [_minutesSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _minutesSpinner;
}

- (CoreTextArcView*)minutesTextView
{
    if (!_minutesTextView) {
        _minutesTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
        [_minutesTextView setText:@"Minutes:"];
        [_minutesTextView setFont:[UIFont fontWithName:FOCUSED_FONT_NAME size:LABEL_FONT_SIZE]];
        [_minutesTextView setColor:[UIColor whiteColor]];
        [_minutesTextView setBackgroundColor:[UIColor clearColor]];
    }
    return _minutesTextView;
}

- (ZASpinnerView*)hourSpinner
{
    if (!_hourSpinner) {
        _hourSpinner = [[ZASpinnerView alloc] initWithFrame:CGRectZero];
        _hourSpinner.spinnerDelegate = self;
        _hourSpinner.contents = [self hourSpinnerContents];
        _hourSpinner.startIndex = 0;
        _hourSpinner.spinnerName = @"hourSpinner";
        [_hourSpinner registerClass:[AWArcTextSpinnerCell class] forCellReuseIdentifier:ARCTEXT_SPINNER_CELL_IDENTIFIER];
    }
    return _hourSpinner;
}

- (CoreTextArcView*)hourTextView
{
    if (!_hourTextView) {
        _hourTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
        [_hourTextView setText:@"Hour:"];
        [_hourTextView setFont:[UIFont fontWithName:FOCUSED_FONT_NAME size:LABEL_FONT_SIZE]];
        [_hourTextView setColor:[UIColor whiteColor]];
        [_hourTextView setBackgroundColor:[UIColor clearColor]];
    }
    return _hourTextView;
}

- (CoreTextArcView*)yourBirthTimeTextView
{
    if (!_yourBirthTimeTextView) {
        _yourBirthTimeTextView = [[CoreTextArcView alloc] initWithFrame:CGRectZero];
        [_yourBirthTimeTextView setText:@"Your birth time:"];
        [_yourBirthTimeTextView setFont:[UIFont fontWithName:UNFOCUSED_FONT_NAME size:48.0f]];
        [_yourBirthTimeTextView setColor:[UIColor blackColor]];
        [_yourBirthTimeTextView setBackgroundColor:[UIColor clearColor]];
    }
    return _yourBirthTimeTextView;
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
	
	if ([self.delegate respondsToSelector:@selector(birthTimeView:nextButtonTouched:)]) {
		[self.delegate birthTimeView:self nextButtonTouched:nextButton];
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
    [self.delegate birthTimeView:self spinner:spinner didChangeTo:value];
}

- (void)spinner:(ZASpinnerView*)spinner didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
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
    if (spinner == self.hourSpinner)
    {
        arcTextCell.circularArcText.arcSize = [self arcMultiplierForSpinner:spinner andFocused:isFocused]*dummyRect.size.width/2.3;
    }
    else if (spinner == self.minutesSpinner)
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

- (NSArray*)partSpinnerContents
{
    return @[@"IDK", @"am", @"pm"];
}

- (NSArray*)minutesSpinnerContents
{
    return @[@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59"];
}

- (NSArray*)hourSpinnerContents
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [returnArray addObject:@"12"];
    for (NSUInteger currHour = 1; currHour < 12; currHour++)
        [returnArray addObject:[NSString stringWithFormat:@"%lu", (unsigned long)currHour]];
    return returnArray;
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
    if (spinner == self.partSpinner)
        returnValue = (isFocused) ? 0.2f : 0.28f;
    else if (spinner == self.minutesSpinner)
        returnValue = (isFocused) ? 0.18f : 0.20f;
    else if (spinner == self.hourSpinner)
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
