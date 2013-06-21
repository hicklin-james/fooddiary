//
//  MealSelectionViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-17.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  
  NSManagedObjectContext *managedObjectContext;
  NSArray *mealsToday;
  
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *mealsToday;

@property (weak, nonatomic) NSString* selectedMeal;
@property (weak, nonatomic) IBOutlet UITableView *mealTable;
- (IBAction)closeWindow:(id)sender;

@end
