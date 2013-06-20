//
//  FoodDiaryDay.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-17.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "FoodDiaryDayController.h"

@interface FoodDiaryDayController ()

- (void) initializeDefaultData;

@end

@implementation FoodDiaryDayController


-(void)setBreakfast:(NSMutableArray *)breakfast {
  if (_breakfast != breakfast)
    _breakfast = [breakfast mutableCopy];
}

-(void)setLunch:(NSMutableArray *)lunch {
  if (_lunch != lunch)
    _lunch = [lunch mutableCopy];
}

-(void)setDinner:(NSMutableArray *)dinner {
  if (_dinner != dinner)
    _dinner = [dinner mutableCopy];
}

-(void)setSnacks:(NSMutableArray *)snacks {
  if (_snacks != snacks)
    _snacks = [snacks mutableCopy];
}

- (void)initializeDefaultData {
  
  NSMutableArray *breakfast = [[NSMutableArray alloc] init];
  NSMutableArray *lunch = [[NSMutableArray alloc] init];
  NSMutableArray *dinner = [[NSMutableArray alloc] init];
  NSMutableArray *snacks = [[NSMutableArray alloc] init];
  
  self.breakfast = breakfast;
  self.lunch = lunch;
  self.dinner = dinner;
  self.snacks = snacks;
  
  NSDate *today = [NSDate date];
  self.date = today;
}

- (id)init {
 
  if (self = [super init]) {
    [self initializeDefaultData];
    return self;
  }
  return nil;
}
  
- (NSUInteger)countOfFoodsInMeal:(NSString *)theMeal {
  
  if ([theMeal isEqual: @"Breakfast"]) {
    return [self.breakfast count];
  }
  else if ([theMeal isEqual: @"Lunch"]) {
    return [self.lunch count];
  }
  else if ([theMeal isEqual: @"Dinner"]) {
    return [self.dinner count];
  }
  else if ([theMeal isEqual: @"Snacks"]) {
    return [self.snacks count];
  }
  else
    return 0;
  
}

- (FDFood*)getFoodFromMeal:(NSString *)theMeal index:(NSUInteger)theIndex {
  
  if ([theMeal isEqual: @"Breakfast"]) {
    return [self.breakfast objectAtIndex:theIndex];
  }
  else if ([theMeal isEqual: @"Lunch"]) {
    return [self.lunch objectAtIndex:theIndex];
  }
  else if ([theMeal isEqual: @"Dinner"]) {
    return [self.dinner objectAtIndex:theIndex];
  }
  else if ([theMeal isEqual: @"Snacks"]) {
    return [self.snacks objectAtIndex:theIndex];
  }
  else
    return nil;
}

- (void)deleteFoodFromMeal:(NSString *)theMeal index:(NSUInteger)theIndex {
  
  if ([theMeal isEqual: @"Breakfast"]) {
    [self.breakfast removeObjectAtIndex:theIndex];
  }
  else if ([theMeal isEqual: @"Lunch"]) {
    [self.lunch removeObjectAtIndex:theIndex];
  }
  else if ([theMeal isEqual: @"Dinner"]) {
    [self.dinner removeObjectAtIndex:theIndex];
  }
  else if ([theMeal isEqual: @"Snacks"]) {
    [self.snacks removeObjectAtIndex:theIndex];
  }
  
}

-(void)addFoodToMeal:(NSString *)theMeal food:(FDFood *)theFood {
  
  if ([theMeal isEqual: @"Breakfast"]) {
    [self.breakfast addObject:theFood];
  }
  else if ([theMeal isEqual: @"Lunch"]) {
    [self.lunch addObject:theFood];
  }
  else if ([theMeal isEqual: @"Dinner"]) {
    [self.dinner addObject:theFood];
  }
  else if ([theMeal isEqual: @"Snacks"]) {
    [self.snacks addObject:theFood];
  }
  
}

@end
