//
//  CalorieCalculator.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-26.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "CalorieCalculator.h"

@implementation CalorieCalculator

// Harris Benedict Equation
-(CGFloat)harrisBenedict:(CGFloat)bmr activityLevel:(NSInteger)activityLevel {
    
    CGFloat floatForActivityLevel = [self activityLevelCalculationNumber:activityLevel];
    return floatForActivityLevel*bmr;
    
}

// calculate BMR
-(CGFloat)calculateBMR:(CGFloat)weight height:(CGFloat)height age:(NSInteger)age gender:(NSInteger)gender {
    
    CGFloat bmr;
    // if male
    if (gender == 0) {
        bmr = (CGFloat)66 + ((CGFloat)13.7*weight) + ((CGFloat)5*height) - ((CGFloat)6.8*age);
    }
    // if female
    else {
        bmr = (CGFloat)655 + ((CGFloat)9.6*weight) + ((CGFloat)1.8*height) - ((CGFloat)4.7*age);
    }
    
    return bmr;
}

-(CGFloat)activityLevelCalculationNumber:(NSInteger)activityLevel {
    
    // switch between activity levels to get correct float
    switch (activityLevel) {
        case 0: return (CGFloat)1.2; break;
        case 1: return (CGFloat)1.375; break;
        case 2: return (CGFloat)1.55; break;
        case 3: return (CGFloat)1.725; break;
        case 4: return (CGFloat)1.9; break;
        default: NSLog(@"something bad happened"); return 0;
    }
    
}

@end
