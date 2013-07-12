//
//  WelcomeCompleteViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-11.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeCompleteViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *congratsLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalWeightLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *calorieIntakeToReachGoalLabel;

- (IBAction)closeSetup:(id)sender;


@end
