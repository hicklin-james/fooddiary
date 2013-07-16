//
//  SaveNewGoalViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-15.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "SaveNewGoalViewController.h"
#import "MealController.h"
#import "DateManipulator.h"

@interface SaveNewGoalViewController ()

@end

@implementation SaveNewGoalViewController

@synthesize goalWeightLabel;
@synthesize goalDateLabel;
@synthesize totalCaloriesLabel;

NSUserDefaults *profile;

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
  profile = [NSUserDefaults standardUserDefaults];
  CGFloat calsToMaintainWeight = [profile floatForKey:@"calsToMaintainWeight"];
  CGFloat currentWeight = [profile floatForKey:@"lbs"];
  CGFloat goalWeightLbs = [profile floatForKey:@"goalWeightLbs"];
  CGFloat goalWeightKg = [profile floatForKey:@"goalWeightKg"];
  NSInteger timeToLose = [profile integerForKey:@"timeForGoal"];
  BOOL unitType = [profile boolForKey:@"unitType"];
  // MALE == 0, FEMALE == 1
  NSInteger gender = [profile integerForKey:@"gender"];
  
  CGFloat amountToChange = [self deficitCalculation:currentWeight goalWeight:goalWeightLbs timeToLose:timeToLose];
  
  CGFloat totalCalsToConsume;
  if (currentWeight > goalWeightLbs)
    totalCalsToConsume = calsToMaintainWeight - amountToChange;
  else if (currentWeight < goalWeightLbs)
    totalCalsToConsume = calsToMaintainWeight + amountToChange;
  else
    totalCalsToConsume = calsToMaintainWeight;
  
  if (totalCalsToConsume < 1200 && gender == 1){
    totalCalsToConsume = (CGFloat)1200;
   timeToLose = ((CGFloat)3500 * (currentWeight - goalWeightLbs))/(calsToMaintainWeight-1200)/7;
   }
  if (totalCalsToConsume < 1800 && gender == 0) {
    totalCalsToConsume = (CGFloat)1800;
    timeToLose = ((CGFloat)3500 * (currentWeight - goalWeightLbs))/(calsToMaintainWeight-1800)/7;
  }
   goalDateLabel.text = [NSString stringWithFormat:@"%d weeks", timeToLose];
  if (unitType == NO){
   goalWeightLabel.text = [NSString stringWithFormat:@"%.00f lbs", goalWeightLbs];
  }
  else {
    goalWeightLabel.text = [NSString stringWithFormat:@"%.00f kg", goalWeightKg];
  }
  totalCaloriesLabel.text = [NSString stringWithFormat:@"%.00f calories", totalCalsToConsume];
  
  [profile setFloat:totalCalsToConsume forKey:@"calsToConsumeToReachGoal"];
  
  NSDate *goalStartDate = [NSDate date];
  [profile setObject:goalStartDate forKey:@"goalStartDate"];
  
  DateManipulator *dateManipulator = [[DateManipulator alloc] init];
  NSDate *goalFinishDate = [dateManipulator findDateWithOffset:timeToLose*7 date:goalStartDate];
  [profile setObject:goalFinishDate forKey:@"goalFinishDate"];
  
  [profile setInteger:(NSInteger)timeToLose forKey:@"timeForGoal"];
  
  MealController *controller = [MealController sharedInstance];
  controller.calorieCountTodayFloat = 0;
  controller.totalCalsNeeded = totalCalsToConsume;
  [profile synchronize];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveGoal:(id)sender {
  
  [profile setBool:YES forKey:@"goalSet"];
  [profile synchronize];
  [self dismissViewControllerAnimated:YES completion:nil];
}

// Daily calorie deficit calculation - time is in weeks - 3500 cals in one pound
-(CGFloat)deficitCalculation:(CGFloat)currentWeight goalWeight:(CGFloat)goalWeight timeToLose:(NSInteger)timeToLose {
  
  CGFloat lbsDifference;
  if (currentWeight > goalWeight)
    lbsDifference = currentWeight - goalWeight;
  else
    lbsDifference = goalWeight - currentWeight;
  
  CGFloat amountToChange = ((CGFloat)3500 * lbsDifference) / (timeToLose * (CGFloat)7);
  return amountToChange;
  
}

@end
