//
//  EnglishWeightViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-09.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "EnglishWeightViewController.h"
#import "EnglishWeightCell.h"
#import "StoredWeight.h"
#import "MealController.h"
#import "DateManipulator.h"

@interface EnglishWeightViewController ()

@end

@implementation EnglishWeightViewController

EnglishWeightCell *weightCell;

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWeight:)];
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  
  [weightCell.weightTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveWeight:(id)sender {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  CGFloat weightInLbs = [weightCell.weightTextField.text floatValue];
  CGFloat weightInKg = weightInLbs/2.2046;
  
  [profile setFloat:weightInLbs forKey:@"lbs"];
  [profile setFloat:weightInKg forKey:@"kg"];
  
  MealController *controller = [MealController sharedInstance];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = [controller dateToShow];
  
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
  if ([results count] == 0) {
    weight = (StoredWeight*)[NSEntityDescription insertNewObjectForEntityForName:@"StoredWeight" inManagedObjectContext:[controller managedObjectContext]];
    [weight setDate:[NSDate date]];
  }
  else {
    weight = [results objectAtIndex:0];
  }
  [weight setLbs:[NSNumber numberWithFloat:weightInLbs]];
  [weight setKg:[NSNumber numberWithFloat:weightInKg]];
  
  if (![[controller managedObjectContext] save:&error]) {
    [controller showDetailedErrorInfo:error];
  }

  
  [profile synchronize];
  
  [self.navigationController popViewControllerAnimated:YES];
  
}

#pragma mark - TableView Methods
//------------------------------TableView Methods---------------------------//

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
    cell.textLabel.text = @"Enter Your weight (lbs)";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    return cell;
  }
  else {
    
    weightCell = [tableView dequeueReusableCellWithIdentifier:@"weightCell"];
    
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    NSString *weight = [NSString stringWithFormat:@"%.00f", [profile floatForKey:@"lbs"]];
    weightCell.weightTextField.text = weight;
    
    return weightCell;
    
  }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 74;
}

@end