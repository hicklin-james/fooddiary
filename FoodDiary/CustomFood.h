//
//  CustomFood.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-23.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CustomFood : NSManagedObject

@property (nonatomic, retain) NSString * brandName;
@property (nonatomic, retain) NSNumber * calcium;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSNumber * carbohydrates;
@property (nonatomic, retain) NSNumber * cholesterol;
@property (nonatomic, retain) NSNumber * fat;
@property (nonatomic, retain) NSNumber * fiber;
@property (nonatomic, retain) NSNumber * iron;
@property (nonatomic, retain) NSNumber * monounsaturatedFat;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * polyunsaturatedFat;
@property (nonatomic, retain) NSNumber * potassium;
@property (nonatomic, retain) NSNumber * protein;
@property (nonatomic, retain) NSNumber * saturatedFat;
@property (nonatomic, retain) NSString * servingDescription;
@property (nonatomic, retain) NSNumber * sodium;
@property (nonatomic, retain) NSNumber * sugar;
@property (nonatomic, retain) NSNumber * transFat;
@property (nonatomic, retain) NSNumber * vitaminA;
@property (nonatomic, retain) NSNumber * vitaminC;

@end
