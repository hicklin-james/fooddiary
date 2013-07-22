//
//  GoalViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-15.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)setNewGoal:(id)sender;
- (IBAction)recordWeightToday:(id)sender;
- (IBAction)cancelGoal:(id)sender;

@end
