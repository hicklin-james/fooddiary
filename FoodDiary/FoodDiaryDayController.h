//
//  FoodDiaryDay.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-17.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDFood.h"

@interface FoodDiaryDayController : NSObject

@property (nonatomic, copy) NSMutableArray *breakfast;
@property (nonatomic, copy) NSMutableArray *lunch;
@property (nonatomic, copy) NSMutableArray *dinner;
@property (nonatomic, copy) NSMutableArray *snacks;
@property (nonatomic, copy) NSDate *date;

- (NSUInteger)countOfFoodsInMeal:(NSString*)theMeal;
- (FDFood*)getFoodFromMeal:(NSString*)theMeal index:(NSUInteger)theIndex;
- (void)deleteFoodFromMeal:(NSString*)theMeal index:(NSUInteger)theIndex;
- (void)addFoodToMeal:(NSString*)theMeal food:(FDFood*)theFood;


@end
