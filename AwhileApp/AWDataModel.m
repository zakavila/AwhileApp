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
    return self;
}

- (void)check
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSLog([[self youAreUnit:@"Years"] stringValue]);
    //NSLog([dateFormat stringFromDate:self.birthTime]);
}

- (NSNumber*)youAreUnit:(NSString*)unit
{
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
        return [NSNumber numberWithInt:abs(difference/(60*60*24*7*4))];
    }
    else if ([unit isEqualToString:@"Years"]) {
        return [NSNumber numberWithInt:abs(difference/(60*60*24*7*4*12))];
    }
    else {
        return [NSNumber numberWithInt:abs(difference/(60*60*24*7*4*12*10))];
    }
}

@end
