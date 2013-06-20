//
//  FoodController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-17.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "FDFood.h"

@implementation FDFood

-(id)initWithIndex:(NSInteger)index theFood:(FSFood *)theFood mealName:(NSString *)mealName servingSize:(CGFloat)servingSize {
  
  self = [super init];
  if (self) {
    _food = theFood;
    _selectedServingIndex = index;
    _mealName = mealName;
    _servingSize = servingSize;
    return self;
  }
  return nil;
}

@end
