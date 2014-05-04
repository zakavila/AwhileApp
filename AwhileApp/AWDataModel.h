//
//  AWDataModel.h
//  AwhileApp
//
//  Created by Deren Kudeki on 4/16/14.
//  Copyright (c) 2014 AwhileApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWDataModel : NSObject

@property (nonatomic, strong) NSDate *birthTime;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *increment;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *you;

- (id)initWithDay:(NSString*)day Month:(NSString*)month Year:(NSString*)year;
- (id)initWithDate:(NSDate*)birthday;
- (void)check;
- (NSNumber*)youAreUnit:(NSString*)unit;

@end
