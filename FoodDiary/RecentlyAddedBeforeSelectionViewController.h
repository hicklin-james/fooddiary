//
//  RecentlyAddedBeforeSelectionViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-21.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFood.h"
#import "MyServing.h"
#import "MyMeal.h"
#import "ActionSheetCustomPicker.h"


@interface RecentlyAddedBeforeSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ActionSheetCustomPickerDelegate> {
  
  MyFood *foodToBeAdded;
  NSString *mealName;
  
}

@property (nonatomic, strong) MyFood *foodToBeAdded;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSString *mealName;

- (IBAction)saveFood:(id)sender;



@end
