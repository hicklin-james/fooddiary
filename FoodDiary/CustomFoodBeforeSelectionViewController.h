//
//  CustomFoodBeforeSelectionViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-23.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetCustomPicker.h"
#import "CustomFood.h"

@interface CustomFoodBeforeSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ActionSheetCustomPickerDelegate> {
  
  CustomFood *detailedFood;
  NSString *mealName;
  NSInteger servingIndex;
  CGFloat servingSize;
  
}

@property (nonatomic, assign) NSInteger servingIndex;
@property (nonatomic, assign) CGFloat servingSize;
@property (strong, nonatomic) CustomFood *detailedFood;
@property (strong, nonatomic)NSString *mealName;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)saveFood:(id)sender;

@end
