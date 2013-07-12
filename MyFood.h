//
//  MyFood.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyMeal, MyServing;

@interface MyFood : NSManagedObject

@property (nonatomic, retain) NSString * brandName;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * foodDescription;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * selectedServing;
@property (nonatomic, retain) NSNumber * servingSize;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * servingIndex;
@property (nonatomic, retain) MyMeal *toMyMeal;
@property (nonatomic, retain) NSSet *toMyServing;
@end

@interface MyFood (CoreDataGeneratedAccessors)

- (void)addToMyServingObject:(MyServing *)value;
- (void)removeToMyServingObject:(MyServing *)value;
- (void)addToMyServing:(NSSet *)values;
- (void)removeToMyServing:(NSSet *)values;

@end
