//
//  CalorieCalculator.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-26.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalorieCalculator : NSObject

-(CGFloat)harrisBenedict:(CGFloat)bmr activityLevel:(NSInteger)activityLevel;
-(CGFloat)calculateBMR:(CGFloat)weight height:(CGFloat)height age:(NSInteger)age gender:(NSInteger)gender;
-(CGFloat)activityLevelCalculationNumber:(NSInteger)activityLevel;

@end
