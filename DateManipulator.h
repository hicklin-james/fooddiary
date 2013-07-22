//
//  DateManipulator.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-14.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateManipulator : NSObject

-(id)initWithDateFormatter;
-(NSString*) getStringOfDateWithoutTime:(NSDate*)date;
-(NSDate*)findDateWithOffset:(NSInteger)offset date:(NSDate*)date;
-(UIColor*)createDateColor:(NSString*)todayString dateToShowString:(NSString*)dateToShowString;
- (NSDate *) getDateForDateAndTime:(NSCalendar *)calendar date:(NSDate*)date hour:(NSInteger)hour minutes:(NSInteger)minutes seconds:(NSInteger)seconds;
-(NSString*) getStringOfDateWithoutTimeOrDay:(NSDate*)date;


@end
