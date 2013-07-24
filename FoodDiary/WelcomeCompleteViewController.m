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


@interface WelcomeCompleteViewController ()

@end

@implementation WelcomeCompleteViewController

@synthesize congratsLabel;

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
  
  congratsLabel.text = [NSString stringWithFormat:@"Congratulations! Your profile is setup! To maintain your current weight, you would be consuming %.00f calories every day!", calsToMaintainWeight];
  
  // Save important info
  // After setup, no goal has been set, so assume goal is to maintain weight.
  [profile setFloat:calsToMaintainWeight forKey:@"calsToConsumeToReachGoal"];
  [profile setFloat:calsToMaintainWeight forKey:@"calsToMaintainWeight"];
  
  MealController *controller = [MealController sharedInstance];
  controller.calorieCountTodayFloat = 0;
  controller.totalCalsNeeded = calsToMaintainWeight;
  
  [profile synchronize];
  
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
