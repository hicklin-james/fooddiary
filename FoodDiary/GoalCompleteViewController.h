//
//  GoalCompleteViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-29.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalCompleteViewController : UIViewController

- (IBAction)closeGoalCompleteView:(id)sender;
- (IBAction)calibrateProfile:(id)sender;
- (IBAction)recordWeight:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *goalWeightLabel;

@end
