//
//  AWSpinnerValues.h
//  AwhileApp
//
//  Created by Zak Avila on 4/30/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWSpinnerContents : NSObject

+ (NSArray*)menuContents;
+ (NSArray*)youContents;
+ (NSArray*)incrementContents;
+ (NSArray*)monthContents;
+ (NSArray*)dayContentsForMonthIndex:(NSInteger)monthIndex;
+ (NSArray*)partContents;
+ (NSArray*)amPmContents;
+ (NSArray*)dateContents;
+ (NSArray*)minuteContents;
+ (NSArray*)hourContents;


@end
