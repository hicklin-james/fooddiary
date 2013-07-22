//
//  MealController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-14.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyMeal.h"
#import "MyFood.h"
#import "MyServing.h"

@interface MealController : NSObject {
  NSManagedObjectContext *managedObjectContext;
  
  NSMutableArray *mealsToday;
  NSMutableArray *breakfastFoods;
  NSMutableArray *lunchFoods;
  NSMutableArray *dinnerFoods;
  NSMutableArray *snacksFoods;
  NSDate *dateToShow;
  CGFloat totalCalsNeeded;
  CGFloat calorieCountTodayFloat;
  
}

@property (nonatomic, assign) CGFloat calorieCountTodayFloat;
@property (nonatomic, assign) CGFloat totalCalsNeeded;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *mealsToday;
@property (nonatomic, retain) NSMutableArray *breakfastFoods;
@property (nonatomic, retain) NSMutableArray *lunchFoods;
@property (nonatomic, retain) NSMutableArray *dinnerFoods;
@property (nonatomic, retain) NSMutableArray *snacksFoods;
@property (nonatomic, strong) NSDate *dateToShow;

+(MealController*)sharedInstance;
-(NSMutableArray*)fetchOrderedMealsForDate:(NSDate*)todayStart end:(NSDate*)todayEnd;
- (void)refreshFoodData;
-(MyServing*)fetchServingFromFood:(MyFood*)food;
- (void) showDetailedErrorInfo:(NSError*)error;

@end
