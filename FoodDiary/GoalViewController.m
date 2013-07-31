//
//  GoalViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-15.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "GoalViewController.h"
#import "NoGoalCell.h"
#import "CurrentGoalCell.h"
#import "DateManipulator.h"
#import "MealController.h"
#import "CalorieCalculator.h"

@interface GoalViewController ()

@end

@implementation GoalViewController

NoGoalCell *noGoalCell;
CurrentGoalCell *currentGoalCell;

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
}


-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.tableView reloadData];
  
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  if ([profile boolForKey:@"goalSet"]) {
    NSDate *finishDate = (NSDate*)[profile objectForKey:@"goalFinishDate"];  
    if ([finishDate timeIntervalSinceNow] < 0.0) {
      [self performSegueWithIdentifier:@"goalCompleteSegue" sender:self];
      [profile setBool:NO forKey:@"goalSet"];
    }
  }
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//-----------------------------TableView Methods-------------------------------//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  //NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  //if (![profile boolForKey:@"goalSet"])
  return 1;
  // return 2;
  
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  static NSString *CellIdentifier = @"Cell";
  
  // first row, description cell
  if (indexPath.row == 0) {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold"size:12];
    cell.textLabel.text = @"Current Goal";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }
  // second row, depends on whether the goal is set or not
  if (indexPath.row == 1) {
    if (![profile boolForKey:@"goalSet"]) {
      noGoalCell = [tableView dequeueReusableCellWithIdentifier:@"noGoalSet"];
      noGoalCell.nameLabel.text = [NSString stringWithFormat:@"Hi %@! You currently weigh:", [profile stringForKey:@"firstName"]];
      if ([profile boolForKey:@"unitType"]) {
        noGoalCell.weightLabel.text = [NSString stringWithFormat:@"%.00f kg", [profile floatForKey:@"kg"]];
      }
      else {
        noGoalCell.weightLabel.text = [NSString stringWithFormat:@"%.00f lbs", [profile floatForKey:@"lbs"]];
      }
      
      return noGoalCell;
    }
    else {
      currentGoalCell = [tableView dequeueReusableCellWithIdentifier:@"goalCell"];
      DateManipulator *dateManipulator = [[DateManipulator alloc] initWithDateFormatter];
      NSString *goalFinishString = [dateManipulator getStringOfDateWithoutTime:(NSDate*)[profile objectForKey:@"goalFinishDate"]];
      currentGoalCell.goalDateLabel.text = goalFinishString;
      if ([profile boolForKey:@"unitType"]) {
        currentGoalCell.currentWeightLabel.text = [NSString stringWithFormat:@"%.00f kg",[profile floatForKey:@"kg"]];
        currentGoalCell.goalWeightLabel.text = [NSString stringWithFormat:@"%.00f kg",[profile floatForKey:@"goalWeightKg"]];
      }
      else {
        currentGoalCell.currentWeightLabel.text = [NSString stringWithFormat:@"%.00f lbs",[profile floatForKey:@"lbs"]];
        currentGoalCell.goalWeightLabel.text = [NSString stringWithFormat:@"%.00f lbs",[profile floatForKey:@"goalWeightLbs"]];
      }
      
      return currentGoalCell;
    }
  }
  else {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"graphsCell"];
    return cell;
    
  }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == 2) {
    [self performSegueWithIdentifier:@"graphViewSegue" sender:self];
    NSLog(@"Hello after the segue");
  }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  if (indexPath.row == 0)
    return 30;
  if (indexPath.row == 1) {
    if (![profile boolForKey:@"goalSet"]) {
      return 167;
    }
    else {
      return 182;
    }
  }
  else {
    return 49;
  }
}

- (IBAction)setNewGoal:(id)sender {
  
  [self performSegueWithIdentifier:@"newGoalSegue" sender:self];
  
}

// Opens a modal view with one input for your weight.
// FIRST: Check core data if a storedWeight already exists for today.
// If it does, update it with the weight entered in the text field.
// OTHERWISE: create a new storedWeight with today's date (without time)
// store that weight in core data
- (IBAction)recordWeightToday:(id)sender {
  
  [self performSegueWithIdentifier:@"recordWeightSegue" sender:self];
}

- (IBAction)cancelGoal:(id)sender {
  
  UIAlertView *giveUpOnGoalAlert = [[UIAlertView alloc] initWithTitle:@"GIVE UP ON GOAL" message:@"Are you sure you want to give up on this goal?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
  [giveUpOnGoalAlert show];
  
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

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
  
  if (buttonIndex == 1) {
    
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    [profile setBool:NO forKey:@"goalSet"];
    [profile setFloat:[profile floatForKey:@"calsToMaintainWeight"] forKey:@"calsToConsumeToReachGoal"];
    
    MealController *controller = [MealController sharedInstance];
    controller.totalCalsNeeded = [profile floatForKey:@"calsToMaintainWeight"];
    
  }
  [self.tableView reloadData];
}

@end
