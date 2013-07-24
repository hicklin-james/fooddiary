//
//  SaveNewGoalViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-15.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveNewGoalViewController : UIViewController {
  
  CGFloat currentWeightLbs;
  CGFloat currentWeightKg;
  
}

@property (strong, nonatomic) IBOutlet UILabel *goalWeightLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCaloriesLabel;
@property (assign, nonatomic) CGFloat currentWeightLbs;
@property (assign, nonatomic) CGFloat currentWeightKg;

- (IBAction)saveGoal:(id)sender;

@end
