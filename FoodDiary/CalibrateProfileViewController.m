//
//  CalibrateProfileViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-26.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "CalibrateProfileViewController.h"
#import "MealController.h"
#import "CalorieCalculator.h"

@interface CalibrateProfileViewController ()

@end

@implementation CalibrateProfileViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//---------------------------TableView Methods-----------------------------//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
        cell.textLabel.text = @"Calibrate Profile";
        cell.textLabel.textColor = [UIColor whiteColor];
        UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
        cell.backgroundColor = color;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"calibrateProfileCell"];
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 30;
    else
        return 277;
}


- (IBAction)calibrateProfile:(id)sender {
    
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    
    if (![profile boolForKey:@"goalSet"]) {
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
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can't calibrate your profile while a goal is set! Complete or give up on your goal to calibrate!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
