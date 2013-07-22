//
//  StoredWeight.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-17.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StoredWeight : NSManagedObject

@property (nonatomic, retain) NSNumber * lbs;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * kg;

@end
