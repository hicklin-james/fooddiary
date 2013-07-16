//
//  ProfileViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-28.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "ProfileViewController.h"
#import "UnitSelectionViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

BOOL unitType; // YES = metric, NO = english

// initiliaze these as 0
CGFloat feet = 0;
CGFloat inches = 0;
CGFloat cm = 0;
CGFloat kg = 0;
CGFloat lbs = 0;

NSString* firstName;
NSString* lastName;
NSInteger age;
NSInteger activityLevel;

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

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  //self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonSelected:)];
  
  
}

-(NSArray*)feetAndInchesFromCm:(CGFloat)cm {
  CGFloat totalInches = cm * 0.39370;
  NSArray *feetAndInches = [NSArray arrayWithObjects:[NSNumber numberWithFloat:fmod(totalInches, 12)], [NSNumber numberWithFloat:totalInches/12], nil];
  return feetAndInches;
}

-(void)viewWillAppear:(BOOL)animated {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  // get all private variables from NSUserDefaults
  unitType = [profile boolForKey:@"unitType"];
  feet = [profile floatForKey:@"feet"];
  inches = [profile floatForKey:@"inches"];
  cm = [profile floatForKey:@"cm"];
  age = [profile integerForKey:@"age"];
  firstName = [profile stringForKey:@"firstName"];
  lastName = [profile stringForKey:@"lastName"];
  kg = [profile floatForKey:@"kg"];
  lbs = [profile floatForKey:@"lbs"];
  activityLevel = [profile integerForKey:@"activityLevel"];
    
  [self.tableView reloadData];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
  // Return the number of rows in the section.
  if (self.editing == YES) {
    if (section == 0)
      return 7;
    //if (section == 1)
    //  return 1;
    //if (section == 2)
    //  return 3;
  }
  else {
    if (section == 0)
      return 7;
    //if (section == 1)
    //  return 1;
    //if (section == 2)
    //  return 2;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *standardIdentifier = @"cellId";
  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:standardIdentifier];
  cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.font = [UIFont systemFontOfSize:11];
  cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
  
  if (indexPath.section == 0) {
    
    
    if (indexPath.row == 0) {
      cell.textLabel.text = @"First Name";
      cell.detailTextLabel.text = firstName;
    }
    if (indexPath.row == 1) {
      cell.textLabel.text = @"Last Name";
      cell.detailTextLabel.text = lastName;
    }
    if (indexPath.row == 2) {
      cell.textLabel.text = @"Age";
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", age];
    }
    if (indexPath.row == 3) {
      cell.textLabel.text = @"Measurement Unit";
      if (unitType == NO) {
        cell.detailTextLabel.text = @"English";
      }
      else {
        cell.detailTextLabel.text = @"Metric";
      }
    }
    if (indexPath.row == 4) {
      cell.textLabel.text = @"Height";
      if (unitType == NO) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.00f\" %.00f'", feet, inches];
      }
      else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.00f cm", cm];
      }
    }
    if (indexPath.row == 5) {
      cell.textLabel.text = @"Current Weight";
      if (unitType == NO) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.00f lbs", lbs];
      }
      else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.00f kg", kg];
      }
    }
    
      if (indexPath.row == 6) {
          cell.textLabel.text = @"Activity Level";
          cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", activityLevel+1];
      }
    return cell;
    
  }
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
  return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   */
  if (indexPath.section == 0 && self.editing == YES && indexPath.row == 0) {
    [self performSegueWithIdentifier:@"firstNameSegue" sender:self];
  }
  if (indexPath.section == 0 && self.editing == YES && indexPath.row == 1) {
    [self performSegueWithIdentifier:@"lastNameSegue" sender:self];
  }
  if (indexPath.section == 0 && self.editing == YES && indexPath.row == 2) {
    [self performSegueWithIdentifier:@"ageSegue" sender:self];
  }
  if (indexPath.section == 0 && self.editing == YES && indexPath.row == 3) {
    [self performSegueWithIdentifier:@"unitTypeSegue" sender:self];
  }
  if (indexPath.section == 0 && self.editing == YES && indexPath.row == 4 && unitType == YES) {
    [self performSegueWithIdentifier:@"metricHeightSegue" sender:self];
  }
  if (indexPath.section == 0 && self.editing == YES && indexPath.row == 4 && unitType == NO) {
    [self performSegueWithIdentifier:@"englishHeightSegue" sender:self];
  }
  if (indexPath.section == 0 && self.editing == YES && indexPath.row == 5 && unitType == NO) {
    [self performSegueWithIdentifier:@"englishWeightSegue" sender:self];
  }
  if (indexPath.section == 0 && self.editing == YES && indexPath.row == 5 && unitType == YES) {
    [self performSegueWithIdentifier:@"metricWeightSegue" sender:self];
  }
    if (indexPath.section == 0 && self.editing == YES && indexPath.row == 6) {
        [self performSegueWithIdentifier:@"activityLevelSegue" sender:self];
    }
}


//------------------------- setEditing --------------------------//

// Called when edit button is pushed
- (void) editButtonSelected: (id) sender
{
  // If we are in editing mode...
  if (self.tableView.editing) {
      
    // Init a bar item using UIBarButtonSystemItemEdit
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonSelected:)];
    [self setEditing:NO animated:YES];
    
  } else { // else we are not in editing mode, so turn editing mode on
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonSelected:)];
    [self setEditing:YES animated:YES];
    
  }
}

// Called when we transition between editing mode on/off
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  
  [super setEditing:editing animated:animated];
  [self.tableView setEditing:editing animated:animated];
  
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
  return UITableViewCellEditingStyleNone;
}

@end
