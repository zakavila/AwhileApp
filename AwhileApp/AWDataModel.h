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

- (void)check;
- (NSNumber*)youAreUnit:(NSString*)unit;

@end
