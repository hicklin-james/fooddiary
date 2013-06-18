//
//  MealSelectionViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-17.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>;

@property (weak, nonatomic) NSString* selectedMeal;
@property (weak, nonatomic) IBOutlet UITableView *mealTable;
- (IBAction)closeWindow:(id)sender;

@end
