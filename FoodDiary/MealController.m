//
//  MealController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-14.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "MealController.h"
#import "DateManipulator.h"

@implementation MealController

@synthesize managedObjectContext;
@synthesize mealsToday;
@synthesize breakfastFoods;
@synthesize lunchFoods;
@synthesize dinnerFoods;
@synthesize snacksFoods;
@synthesize dateToShow;
@synthesize totalCalsNeeded;
@synthesize calorieCountTodayFloat;
@synthesize initialDate;

DateManipulator *dateManipulator;

// implemented as singleton to give app wide access to data
+(MealController*)sharedInstance {
  
  static MealController *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MealController alloc] init];
    dateManipulator = [[DateManipulator alloc] initWithDateFormatter];
    //[sharedInstance startTimer];
    
  });
  return sharedInstance;
}

- (void) startTimer {
  [NSTimer scheduledTimerWithTimeInterval:60
                                   target:self
                                 selector:@selector(tick:)
                                 userInfo:nil
                                  repeats:YES];
}

- (void) tick:(NSTimer *) timer {
  // Figure this out at some point! TODO
  NSDate *currentDate = [NSDate date];
  if (![[dateManipulator getStringOfDateWithoutTime:currentDate] isEqual:[dateManipulator getStringOfDateWithoutTime:initalDate]]) {
    dateToShow = currentDate;
    initialDate = currentDate;
  }
  
}

-(NSMutableArray*)fetchOrderedMealsForDate:(NSDate*)todayStart end:(NSDate*)todayEnd {
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", todayStart, todayEnd];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"MyMeal" inManagedObjectContext:managedObjectContext]];
  [request setPredicate:predicate];
  [request setSortDescriptors:sortDescriptors];
  
  NSError *error = nil;
  NSMutableArray *results = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:request error:&error]];
  
  return results;
  
}

- (void)refreshFoodData {
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = dateToShow;
  
  NSDate *todayStart = [dateManipulator getDateForDateAndTime:calendar date:date hour:0 minutes:0 seconds:0];
  NSDate *todayEnd = [dateManipulator getDateForDateAndTime:calendar date:date hour:23 minutes:59 seconds:59];
  
  NSMutableArray *results = [self fetchOrderedMealsForDate:todayStart end:todayEnd];
  calorieCountTodayFloat = 0;
  [mealsToday removeAllObjects];
  if ([results count] == 0) {
    NSLog(@"No meals found today, we must create some");
    [self createMealsForDay:date];
  }
  else {
    mealsToday = results;
  }
  
  for (int i = 0; i < [ mealsToday count]; i++) {
    MyMeal *meal = [mealsToday objectAtIndex:i];
    //NSLog([meal name], nil);
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateOfCreation" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    NSArray *foodsArray = [[meal toMyFood] sortedArrayUsingDescriptors:sortDescriptors];
    NSMutableArray *foods = [NSMutableArray arrayWithArray:foodsArray];
    //NSMutableArray *foods = [NSMutableArray arrayWithArray:[tempFoods sortedArrayUsingDescriptors:sortDescriptors]];
    for (int s = 0; s < [foods count]; s++) {
      MyFood *food = [foods objectAtIndex:s];
      NSLog ([dateManipulator getStringOfDate:[food date]],nil);
    }
    
    [self updateCalorieCount:foods meal:meal];
    [self updateGlobalArraysWithFoods:foods integer:i];
    
  }
}

-(void)updateGlobalArraysWithFoods:(NSMutableArray*)foods integer:(NSInteger)i {
  
  if ([[[mealsToday objectAtIndex:i] name] isEqual: @"Breakfast"]) {
    breakfastFoods = foods;
  }
  if ([[[mealsToday objectAtIndex:i] name] isEqual: @"Lunch"]) {
    lunchFoods = foods;
  }
  if ([[[mealsToday objectAtIndex:i] name] isEqual: @"Dinner"]) {
    dinnerFoods = foods;
  }
  if ([[[mealsToday objectAtIndex:i] name] isEqual: @"Snacks"]) {
    snacksFoods = foods;
  }
  
}

-(void)createMealsForDay:(NSDate*)date {
  
  NSError *error = nil;
  NSArray *mealNames = [NSArray arrayWithObjects:@"Breakfast", @"Lunch", @"Dinner", @"Snacks", nil];
  for (int i = 0; i < 4; i++) {
    MyMeal *meal = (MyMeal*)[NSEntityDescription insertNewObjectForEntityForName:@"MyMeal" inManagedObjectContext:managedObjectContext];
    [meal setName:[mealNames objectAtIndex:i]];
    [meal setDate:date];
    // Need to save every time, otherwise order gets screwed up
    [managedObjectContext save:&error];
    [mealsToday addObject:meal];
  }
  
}

// Helper method to set up a predicate using the servingId, which is unique
// to a serving. Check core data for that serving, and return it
-(MyServing*)fetchServingFromFood:(MyFood*)food {
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(servingId == %d)", [[food selectedServing] intValue]];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"MyServing" inManagedObjectContext:managedObjectContext]];
  [request setPredicate:predicate];
  
  NSError *error = nil;
  NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
  
  return [results objectAtIndex:0];
  
}

// Helper method that updates the calorie count at the top of the view
// ONLY CALLED WHEN VIEW APPEARS OR DATE CHANGES
-(void)updateCalorieCount:(NSMutableArray*)foods meal:(MyMeal*)meal {
  
  CGFloat calsForMeal = 0.0;
  for (int i = 0; i < [foods count]; i++) {
    MyFood *currentFood = [foods objectAtIndex:i];
    MyServing *currentServing = [self fetchServingFromFood:currentFood];
    calorieCountTodayFloat += [[currentServing calories]floatValue] * [[currentFood servingSize]floatValue];
    calsForMeal += [[currentServing calories]floatValue] * [[currentFood servingSize]floatValue];
  }
  
  [meal setCalories:[NSNumber numberWithFloat:calsForMeal]];
  NSError *error = nil;
  if (![managedObjectContext save:&error]) {
    [self showDetailedErrorInfo:error];
  }

}

// Helper method to provide detailed error information from core data
- (void) showDetailedErrorInfo:(NSError*)error {
  NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
  NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
  if(detailedErrors != nil && [detailedErrors count] > 0) {
    for(NSError* detailedError in detailedErrors) {
      NSLog(@"  DetailedError: %@", [detailedError userInfo]);
    }
  }
  else {
    NSLog(@"  %@", [error userInfo]);
  }
}

@end
