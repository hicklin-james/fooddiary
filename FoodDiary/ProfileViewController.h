//
//  ProfileViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-24.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate> {
  
  NSString *firstName;
  NSString *lastName;
  NSInteger age;
  
}

@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (nonatomic, assign) NSInteger age;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;


- (IBAction)saveProfileInfo:(id)sender;
- (IBAction)startEditing:(id)sender;

@end
