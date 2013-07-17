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
  
 //NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  //if (![profile boolForKey:@"goalSet"])
  return 2;
  
//  if (section == 0)
 //   return 3;
 // else
 //   return 1;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold"size:12];
        cell.textLabel.text = @"Current Goal";
        cell.textLabel.textColor = [UIColor whiteColor];
        UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
        cell.backgroundColor = color;
        return cell;
    }
  
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
      DateManipulator *dateManipulator = [[DateManipulator alloc] init];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    if (indexPath.row == 0)
        return 30;
  if (![profile boolForKey:@"goalSet"]) {
    return 167;
  }
  else {
    return 182;
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
@end
