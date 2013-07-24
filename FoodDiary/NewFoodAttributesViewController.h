//
//  NewFoodAttributesViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-23.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomFood.h"
#import "MealController.h"

@interface NewFoodAttributesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
  
  CustomFood *customFood;
  
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CustomFood *customFood;
- (IBAction)saveCustomFood:(id)sender;

@end
