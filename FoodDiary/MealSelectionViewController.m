//
//  MealSelectionViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-17.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "MealSelectionViewController.h"
#import "AddFoodViewController.h"

@interface MealSelectionViewController ()

@end

@implementation MealSelectionViewController

@synthesize managedObjectContext;
@synthesize mealsToday;
@synthesize dateOfFood;

- (IBAction)closeWindow:(id)sender {
  
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  UINavigationController *nav = [segue destinationViewController];
  AddFoodViewController *controller = [segue destinationViewController];
  controller.mealsToday = mealsToday;
  controller.managedObjectContext = managedObjectContext;
  controller.dateOfFood = dateOfFood;
  nav.title = self.selectedMeal;
  
  
}

//---------------------Delegate Methods----------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
  // Return the number of rows in the section.
  return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyReuseIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
  }
  
  if (indexPath.row == 0) {
    cell.textLabel.text = @"Breakfast";
  }
  if (indexPath.row == 1) {
    cell.textLabel.text = @"Lunch";
  }
  if (indexPath.row == 2) {
    cell.textLabel.text = @"Dinner";
  }
  if (indexPath.row == 3) {
    cell.textLabel.text = @"Snacks";
  }
  
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
  return @"Choose your meal";
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
  self.selectedMeal = selectedCell.textLabel.text;
  [self performSegueWithIdentifier:@"selectFoodSegue" sender:self];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  
}

@end
