//
//  AWDataModel.m
//  AwhileApp
//
//  Created by Deren Kudeki on 4/16/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import "AWDataModel.h"

@implementation AWDataModel

- (id)init
{
    self = [super init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    self.birthTime = [dateFormat dateFromString:@"12/27/2013"];
	
	[self setBirthTime:[dateFormat dateFromString:@"01/01/1900"]];
	
    return self;
}

- (id)initWithDay:(NSString*)day Month:(NSString*)month Year:(NSString*)year
{
    self = [super init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSMutableString* date = [[NSMutableString alloc] initWithCapacity:12];
    
    if ([month isEqualToString:@"1"] || [month isEqualToString:@"2"] || [month isEqualToString:@"3"] || [month isEqualToString:@"4"] || [month isEqualToString:@"5"] || [month isEqualToString:@"6"] || [month isEqualToString:@"7"] || [month isEqualToString:@"8"] || [month isEqualToString:@"9"]) {
        [date appendString:@"0"];
    }
    [date appendString:month];
    [date appendString:@"/"];
    
    if ([day isEqualToString:@"1"] || [day isEqualToString:@"2"] || [day isEqualToString:@"3"] || [day isEqualToString:@"4"] || [day isEqualToString:@"5"] || [day isEqualToString:@"6"] || [day isEqualToString:@"7"] || [day isEqualToString:@"8"] || [day isEqualToString:@"9"]) {
        [date appendString:@"0"];
    }
    [date appendString:day];
    [date appendString:@"/"];
    [date appendString:year];
    
    self.birthTime = [dateFormat dateFromString:date];
    
    return self;
}

- (id)initWithDate:(NSDate*)birthday
{
    self = [super init];
    if (self) {
        [self setBirthTime:birthday];
    }
    return self;
}

- (void)check
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
//    NSLog([[self youAreUnit:@"Years"] stringValue]);
    //NSLog([dateFormat stringFromDate:self.birthTime]);
}

- (NSNumber*)youAreUnit:(NSString*)unit {
    int difference = [self.birthTime timeIntervalSinceNow];
    if ([unit isEqualToString:@"Seconds"]) {
        return [NSNumber numberWithInt:abs(difference)];
    }
    else if ([unit isEqualToString:@"Minutes"]) {
        return [NSNumber numberWithInt:abs(difference/60)];
    }
    else if ([unit isEqualToString:@"Hours"]) {
        return [NSNumber numberWithInt:abs(difference/(60*60))];
    }
    else if ([unit isEqualToString:@"Days"]) {
        return [NSNumber numberWithInt:abs(difference/(60*60*24))];
    }
    else if ([unit isEqualToString:@"Weeks"]) {
        return [NSNumber numberWithInt:abs(difference/(60*60*24*7))];
    }
    else if ([unit isEqualToString:@"Months"]) {
        return [NSNumber numberWithInt:abs(difference/(60*60*24*31))];
    }
    else if ([unit isEqualToString:@"Years"]) {
        return [NSNumber numberWithInt:abs(difference/(60*60*24*365.25))];
    }
    else {
        return [NSNumber numberWithInt:abs(difference/(60*60*24*365.25*10))];
    }
}

- (NSNumber*)seconds:(NSTimeInterval)time withUnit:(NSString*)unit
{
    if ([unit isEqualToString:@"Seconds"]) {
        return [NSNumber numberWithInt:abs((int)time)];
    }
    else if ([unit isEqualToString:@"Minutes"]) {
        return [NSNumber numberWithInt:abs((int)time/60)];
    }
    else if ([unit isEqualToString:@"Hours"]) {
        return [NSNumber numberWithInt:abs((int)time/(60*60))];
    }
    else if ([unit isEqualToString:@"Days"]) {
        return [NSNumber numberWithInt:abs((int)time/(60*60*24))];
    }
    else if ([unit isEqualToString:@"Weeks"]) {
        return [NSNumber numberWithInt:abs((int)time/(60*60*24*7))];
    }
    else if ([unit isEqualToString:@"Months"]) {
        NSDateComponents* comps = [[NSDateComponents alloc] init];
        [comps setSecond:time];
        NSDate* tempDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self.birthTime options:0];
        
        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:tempDate];
        
        NSDateComponents* birthComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.birthTime];
        
        if ([components day] < [birthComponents day])
        {
            return [NSNumber numberWithInteger:(([components year]-[birthComponents year])*12 + ([components month] - [birthComponents month]))-1];
        }
        else
        {
            return [NSNumber numberWithInteger:(([components year]-[birthComponents year])*12 + ([components month] - [birthComponents month]))];
        }
    }
    else if ([unit isEqualToString:@"Years"]) {
        NSDateComponents* comps = [[NSDateComponents alloc] init];
        [comps setSecond:time];
        NSDate* tempDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self.birthTime options:0];
        
        NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:tempDate];
        
        NSDateComponents* birthComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.birthTime];
        
        if ([components month] < [birthComponents month])
        {
            return [NSNumber numberWithInteger:[components year]-[birthComponents year]-1];
        }
        else if ([components month] == [birthComponents month])
        {
            if ([components day] < [birthComponents day])
            {
                return [NSNumber numberWithInteger:[components year]-[birthComponents year]-1];
            }
            else
            {
                return [NSNumber numberWithInteger:[components year]-[birthComponents year]];
            }
        }
        else
        {
            return [NSNumber numberWithInteger:[components year]-[birthComponents year]];
        }
    }
    else {
        return [NSNumber numberWithInt:abs((int)time/(60*60*24*365.25*10))];
    }
}

@end
