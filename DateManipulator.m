//
//  DateManipulator.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-14.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "DateManipulator.h"

@implementation DateManipulator

-(NSString*) getStringOfDateWithoutTime:(NSDate*)date {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
  dateFormatter.dateFormat = @"EEEE, MM/dd/yy";
  
  NSString *dateString = [dateFormatter stringFromDate: date];
  
  return dateString;
  
}

-(NSDate*)findDateWithOffset:(NSInteger)offset date:(NSDate*)date {
  
  NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
  [componentsToSubtract setDay:offset];
  
  NSDate *dateWithOffset = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:date options:0];
  
  return dateWithOffset;
  
}


// Helper method to set the color of the date string (GREEN if today)
-(UIColor*)createDateColor:(NSString*)todayString dateToShowString:(NSString*)dateToShowString {
  
  if ([todayString isEqual:dateToShowString]) {
    return [UIColor greenColor];
  }
  else {
    return [UIColor blackColor];
  }
  
}

- (NSDate *) getDateForDateAndTime:(NSCalendar *)calendar date:(NSDate*)date hour:(NSInteger)hour minutes:(NSInteger)minutes seconds:(NSInteger)seconds {
  
  NSDateComponents *compsStart = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
  [compsStart setHour:hour];
  [compsStart setMinute:minutes];
  [compsStart setSecond:seconds];
  NSDate *calculatedDate = [calendar dateFromComponents:compsStart];
  return calculatedDate;
  
}

@end
