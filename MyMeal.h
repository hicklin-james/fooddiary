//
//  MyMeal.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-20.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyFood;

@interface MyMeal : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *toMyFood;
@end

@interface MyMeal (CoreDataGeneratedAccessors)

- (void)addToMyFoodObject:(MyFood *)value;
- (void)removeToMyFoodObject:(MyFood *)value;
- (void)addToMyFood:(NSSet *)values;
- (void)removeToMyFood:(NSSet *)values;

@end
