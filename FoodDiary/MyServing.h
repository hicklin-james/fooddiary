//
//  MyServing.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyFood;

@interface MyServing : NSManagedObject

@property (nonatomic, retain) NSNumber * calcium;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSNumber * carbohydrates;
@property (nonatomic, retain) NSNumber * cholesterol;
@property (nonatomic, retain) NSNumber * fat;
@property (nonatomic, retain) NSNumber * fiber;
@property (nonatomic, retain) NSNumber * iron;
@property (nonatomic, retain) NSString * measurementDescription;
@property (nonatomic, retain) NSNumber * metricServingAmount;
@property (nonatomic, retain) NSString * metricServingUnit;
@property (nonatomic, retain) NSNumber * monounsaturatedFat;
@property (nonatomic, retain) NSNumber * numberOfUnits;
@property (nonatomic, retain) NSNumber * polyunsaturatedFat;
@property (nonatomic, retain) NSNumber * potassium;
@property (nonatomic, retain) NSNumber * protein;
@property (nonatomic, retain) NSNumber * saturatedFat;
@property (nonatomic, retain) NSString * servingDescription;
@property (nonatomic, retain) NSNumber * servingId;
@property (nonatomic, retain) NSString * servingUrl;
@property (nonatomic, retain) NSNumber * sodium;
@property (nonatomic, retain) NSNumber * sugar;
@property (nonatomic, retain) NSNumber * transFat;
@property (nonatomic, retain) NSNumber * vitaminA;
@property (nonatomic, retain) NSNumber * vitaminC;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) MyFood *toMyFood;

@end
