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
@property (nonatomic, assign) NSInteger selectedServingIndex;
@property (nonatomic, assign) CGFloat servingSize;
@property (nonatomic, copy) NSString * mealName;

-(id)initWithIndex:(NSInteger)index theFood:(FSFood*)theFood mealName:(NSString*)mealName servingSize:(CGFloat)servingSize;

@end
