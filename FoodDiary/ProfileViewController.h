//
//  ProfileViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-28.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UITableViewController <UITextFieldDelegate> {
  
  NSString* firstName;
  NSString* lastName;
  NSInteger age;
  
}

@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, assign) NSInteger age;

@end
