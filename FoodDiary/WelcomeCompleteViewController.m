//
//  WelcomeCompleteViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-11.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "WelcomeCompleteViewController.h"

@interface WelcomeCompleteViewController ()

@end

@implementation WelcomeCompleteViewController

@synthesize congratsLabel;
@synthesize goalTimeLabel;
@synthesize goalWeightLabel;
@synthesize calorieIntakeToReachGoalLabel;

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
  
  CGFloat metricWeight = [profile floatForKey:@"kg"];
  CGFloat metricHeight = [profile floatForKey:@"cm"];
  NSInteger age = [profile integerForKey:@"age"];
  // MALE == 0, FEMALE == 1
  NSInteger gender = [profile integerForKey:@"gender"];
  
  CGFloat bmr = [self calculateBMR:metricWeight height:metricHeight age:age gender:gender];
  
  NSInteger activityLevel = [profile integerForKey:@"activityLevel"];
  
  // Harris Benedict Equation
  CGFloat calsToMaintainWeight = [self harrisBenedict:bmr activityLevel:activityLevel];
  
  CGFloat currentWeight = [profile floatForKey:@"lbs"];
  CGFloat goalWeightLbs = [profile floatForKey:@"goalWeightLbs"];
  CGFloat goalWeightKg = [profile floatForKey:@"goalWeightKg"];
  NSInteger timeToLose = [profile integerForKey:@"timeForGoal"];
  BOOL unitType = [profile boolForKey:@"unitType"];
  
  CGFloat amountToChange = [self deficitCalculation:currentWeight goalWeight:goalWeightLbs timeToLose:timeToLose];
  
  CGFloat totalCalsToConsume;
  if (currentWeight > goalWeightLbs)
    totalCalsToConsume = calsToMaintainWeight - amountToChange;
  else if (currentWeight < goalWeightLbs)
    totalCalsToConsume = calsToMaintainWeight + amountToChange;
  else
    totalCalsToConsume = calsToMaintainWeight;
  
  congratsLabel.text = [NSString stringWithFormat:@"Congratulations! Your profile is setup! To maintain your current weight, you would be consuming %.00f calories every day!", calsToMaintainWeight];
  
  if (totalCalsToConsume < 1200 && gender == 1){
    totalCalsToConsume = (CGFloat)1200;
    timeToLose = ((CGFloat)3500 * (currentWeight - goalWeightLbs))/(calsToMaintainWeight-1200)/7;
  }
  if (totalCalsToConsume < 1800 && gender == 0) {
    totalCalsToConsume = (CGFloat)1800;
    timeToLose = ((CGFloat)3500 * (currentWeight - goalWeightLbs))/(calsToMaintainWeight-1800)/7;
  }
  goalTimeLabel.text = [NSString stringWithFormat:@"%d weeks", timeToLose];
  if (unitType == NO){
    goalWeightLabel.text = [NSString stringWithFormat:@"%.00f lbs", goalWeightLbs];
  }
  else {
    goalWeightLabel.text = [NSString stringWithFormat:@"%.00f kg", goalWeightKg];
  }
  calorieIntakeToReachGoalLabel.text = [NSString stringWithFormat:@"%.00f calories", totalCalsToConsume];
  
  // Save important info
  [profile setFloat:totalCalsToConsume forKey:@"calsToConsumeToReachGoal"];
  [profile setFloat:calsToMaintainWeight forKey:@"calsToMaintainWeight"];
  [profile setFloat:bmr forKey:@"bmr"];
  [profile setInteger:(NSInteger)timeToLose forKey:@"timeForGoal"];
  
  [profile synchronize];
  
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

// Harris Benedict Equation
-(CGFloat)harrisBenedict:(CGFloat)bmr activityLevel:(NSInteger)activityLevel {
  
  CGFloat floatForActivityLevel = [self activityLevelCalculationNumber:activityLevel];
  return floatForActivityLevel*bmr;
  
}

// calculate BMR
-(CGFloat)calculateBMR:(CGFloat)weight height:(CGFloat)height age:(NSInteger)age gender:(NSInteger)gender {
  
  CGFloat bmr;
  // if male
  if (gender == 0) {
    bmr = (CGFloat)66 + ((CGFloat)13.7*weight) + ((CGFloat)5*height) - ((CGFloat)6.8*age);
  }
  // if female
  else {
    bmr = (CGFloat)655 + ((CGFloat)9.6*weight) + ((CGFloat)1.8*height) - ((CGFloat)4.7*age);
  }
  
  return bmr;
}

-(CGFloat)activityLevelCalculationNumber:(NSInteger)activityLevel {
  
  // switch between activity levels to get correct float
  switch (activityLevel) {
    case 0: return (CGFloat)1.2; break;
    case 1: return (CGFloat)1.375; break;
    case 2: return (CGFloat)1.55; break;
    case 3: return (CGFloat)1.725; break;
    case 4: return (CGFloat)1.9; break;
    default: NSLog(@"something bad happened"); return 0;
  }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeSetup:(id)sender {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  [profile setBool:YES forKey:@"profileSet"];
  [profile synchronize];
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}
@end
