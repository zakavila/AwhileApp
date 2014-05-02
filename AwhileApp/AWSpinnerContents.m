//
//  AWSpinnerValues.m
//  AwhileApp
//
//  Created by Zak Avila on 4/30/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWSpinnerContents.h"

@implementation AWSpinnerContents

+ (NSArray *)menuContents
{
    return @[@"Birthday", @"Time", @"Calculator", @"Alarm", @"Share"];
}

+ (NSArray *)youContents
{
    return @[@"You were", @"You are", @"You'll be"];
}

+ (NSArray *)incrementContents
{
    return @[@"Seconds", @"Minutes", @"Hours", @"Days", @"Weeks", @"Months", @"Years", @"Decades"];
}

+ (NSArray *)monthContents
{
    return @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
}

+ (NSArray *)dayContentsForMonthIndex:(NSInteger)monthIndex
{
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSUInteger currDay = 1; currDay < 32; currDay++)
        [returnArray addObject:[NSString stringWithFormat:@"%d", currDay]];
    return returnArray;
}

+ (NSArray *)partContents
{
    return @[@"IDK", @"am", @"pm"];
}

+ (NSArray *)amPmContents
{
    return @[@"am", @"pm"];
}

+ (NSArray *)dateContents
{
    return @[@"12/13/14"];
}

+ (NSArray *)minuteContents
{
    return @[@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59"];
}

+ (NSArray *)hourContents
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [returnArray addObject:@"12"];
    for (NSUInteger currHour = 1; currHour < 12; currHour++)
        [returnArray addObject:[NSString stringWithFormat:@"%lu", (unsigned long)currHour]];
    return returnArray;
}

@end
