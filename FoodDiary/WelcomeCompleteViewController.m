//
//  WelcomeCompleteViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-11.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "WelcomeCompleteViewController.h"
#import "MealController.h"
#import "StoredWeight.h"
#import "CalorieCalculator.h"


@interface WelcomeCompleteViewController ()

@end

@implementation WelcomeCompleteViewController

@synthesize caloriesLabel;

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
    
    CalorieCalculator *calorieCalculator = [[CalorieCalculator alloc] init];
  
  CGFloat bmr = [calorieCalculator calculateBMR:metricWeight height:metricHeight age:age gender:gender];
  
  NSInteger activityLevel = [profile integerForKey:@"activityLevel"];
  
  // Harris Benedict Equation
  CGFloat calsToMaintainWeight = [calorieCalculator harrisBenedict:bmr activityLevel:activityLevel];
  
  caloriesLabel.text = [NSString stringWithFormat:@"%.00f calories", calsToMaintainWeight];
  
  // Save important info
  // After setup, no goal has been set, so assume goal is to maintain weight.
  [profile setFloat:calsToMaintainWeight forKey:@"calsToConsumeToReachGoal"];
  [profile setFloat:calsToMaintainWeight forKey:@"calsToMaintainWeight"];
  
  MealController *controller = [MealController sharedInstance];
  controller.calorieCountTodayFloat = 0;
  controller.totalCalsNeeded = calsToMaintainWeight;
  
  [profile synchronize];
  
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
  
  CGFloat weightInLbs = [profile floatForKey:@"lbs"];
  CGFloat weightInKg = [profile floatForKey:@"kg"];
  
  MealController *controller = [MealController sharedInstance];
  StoredWeight *weight = (StoredWeight*)[NSEntityDescription insertNewObjectForEntityForName:@"StoredWeight" inManagedObjectContext:[controller managedObjectContext]];
  [weight setDate:[NSDate date]];
  [weight setLbs:[NSNumber numberWithFloat:weightInLbs]];
  [weight setKg:[NSNumber numberWithFloat:weightInKg]];
  
  NSError *error = nil;
  if (![[controller managedObjectContext] save:&error]) {
    [controller showDetailedErrorInfo:error];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

@end
