//
//  RecordWeightViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-17.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "RecordWeightViewController.h"
#import "EnglishWeightCell.h"
#import "MetricWeightCell.h"
#import "MealController.h"
#import "DateManipulator.h"
#import "StoredWeight.h"

@interface RecordWeightViewController ()

@end

@implementation RecordWeightViewController

EnglishWeightCell *englishWeightCell;
MetricWeightCell *metricWeightCell;
NSUserDefaults *profile;
MealController *controller;

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
  controller = [MealController sharedInstance];
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  
  if ([profile boolForKey:@"unitType"]) {
    [metricWeightCell.weightTextField becomeFirstResponder];
  }
  else {
    [englishWeightCell.weightTextField becomeFirstResponder];
  }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------------------TableView Methods----------------------//

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 1;
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return 2;
  
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
  if (indexPath.row == 0) {
    cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
    if ([profile boolForKey:@"unitType"])
      cell.textLabel.text = @"Weight (kg)";
    else
      cell.textLabel.text = @"Weight (lbs)";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
  }
  
  else {
    if ([profile boolForKey:@"unitType"]) {
        metricWeightCell = [tableView dequeueReusableCellWithIdentifier:@"metricWeightCell"];
        metricWeightCell.weightLabel.text = @"Current Weight";
        return metricWeightCell;
      }
      else {
          englishWeightCell = [tableView dequeueReusableCellWithIdentifier:@"englishWeightCell"];
          englishWeightCell.weightLabel.text = @"Current Weight";
          return englishWeightCell;
        }
  }
  
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 46;
}



- (IBAction)cancelRecordWeight:(id)sender {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (IBAction)saveRecordWeight:(id)sender {
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = [NSDate date];//[controller dateToShow];
  
  DateManipulator *dateManipulator = [[DateManipulator alloc] initWithDateFormatter];
  NSDate *start = [dateManipulator getDateForDateAndTime:calendar date:date hour:0 minutes:0 seconds:0];
  NSDate *end = [dateManipulator getDateForDateAndTime:calendar date:date hour:23 minutes:59 seconds:59];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", start, end];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"StoredWeight" inManagedObjectContext:[controller managedObjectContext]]];
  [request setPredicate:predicate];
  
  NSError *error = nil;
  NSArray *results = [[controller managedObjectContext] executeFetchRequest:request error:&error];
  StoredWeight *weight;
  CGFloat weightInKg;
  CGFloat weightInLbs;
  if ([profile boolForKey:@"unitType"]) {
    // convert weights to lbs
    weightInKg = [metricWeightCell.weightTextField.text floatValue];
    weightInLbs = weightInKg*2.2046;
  }
  else {
    // convert weights to kg
    weightInLbs = [englishWeightCell.weightTextField.text floatValue];
    weightInKg = weightInLbs/2.2046;
  }
  
  if ([results count] == 0) {
    weight = (StoredWeight*)[NSEntityDescription insertNewObjectForEntityForName:@"StoredWeight" inManagedObjectContext:[controller managedObjectContext]];
    [weight setDate:date];
  }
  else {
    weight = [results objectAtIndex:0];
  }
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  [profile setFloat:weightInLbs forKey:@"lbs"];
  [profile setFloat:weightInKg forKey:@"kg"];
  
  [weight setLbs:[NSNumber numberWithFloat:weightInLbs]];
  [weight setKg:[NSNumber numberWithFloat:weightInKg]];
  
  if (![[controller managedObjectContext] save:&error]) {
    [controller showDetailedErrorInfo:error];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];	
  
}
@end
