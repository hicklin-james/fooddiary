//
//  FoodController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-17.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSFood.h"

@interface FDFood : NSObject

@property (nonatomic, copy) FSFood * food;
@property (nonatomic, assign) NSUInteger selectedServingIndex;
@property (nonatomic, copy) NSString * mealName;

-(id)initWithIndex:(NSUInteger)index theFood:(FSFood*)theFood mealName:(NSString*)mealName;

@end
