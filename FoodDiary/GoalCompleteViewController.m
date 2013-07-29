//
//  GoalCompleteViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-29.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "GoalCompleteViewController.h"
#import "MealController.h"
#import "CalorieCalculator.h"

@interface GoalCompleteViewController ()

@end

@implementation GoalCompleteViewController

@synthesize goalWeightLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  if ([profile boolForKey:@"unitType"]) {
    goalWeightLabel.text = [NSString stringWithFormat:@"%.00f kg", [profile floatForKey:@"goalWeightKg"]];
  }
  else {
    goalWeightLabel.text = [NSString stringWithFormat:@"%.00f lbs", [profile floatForKey:@"goalWeightLbs"]];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)closeGoalCompleteView:(id)sender {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}
- (IBAction)calibrateProfile:(id)sender {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  CGFloat metricWeight = [profile floatForKey:@"kg"];
  CGFloat metricHeight = [profile floatForKey:@"cm"];
  NSInteger age = [profile integerForKey:@"age"];
  // MALE == 0, FEMALE == 1
  NSInteger gender = [profile integerForKey:@"gender"];
  
  CalorieCalculator *calorieCalculator = [[CalorieCalculator alloc] init];
  
  CGFloat bmr = [calorieCalculator calculateBMR:metricWeight height:metricHeight age:age gender:gender];
  
  NSInteger activityLevel = [profile integerForKey:@"activityLevel"];
  
  // Harris Benedict Equation
  CGFloat calsToMaintainWeight = [calorieCalculator harrisBenedict:bmr activityLevel:activityLevel];
  
  // caloriesLabel.text = [NSString stringWithFormat:@"%.00f calories", calsToMaintainWeight];
  
  // Save important info
  // After setup, no goal has been set, so assume goal is to maintain weight.
  [profile setFloat:calsToMaintainWeight forKey:@"calsToConsumeToReachGoal"];
  [profile setFloat:calsToMaintainWeight forKey:@"calsToMaintainWeight"];
  MealController *controller = [MealController sharedInstance];
  controller.totalCalsNeeded = calsToMaintainWeight;
  
  [profile synchronize];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Calibration Complete" message:[NSString stringWithFormat:@"Your profile has been calibrated! Your new daily calorie requirement to maintain your current weight is %.00f calories", calsToMaintainWeight] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
  
  [alert show];
  
}
- (IBAction)recordWeight:(id)sender {
  
  [self performSegueWithIdentifier:@"recordWeightSegue" sender:self];
  
}
@end
