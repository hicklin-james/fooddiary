//
//  NewGoalViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-15.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnglishWeightCell.h"
#import "TimeToReachGoalCell.h"
#import "MetricWeightCell.h"

@interface NewGoalViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

- (IBAction)cancelNewGoal:(id)sender;
- (IBAction)goToNextView:(id)sender;


@end
