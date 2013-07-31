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
  //AddFoodViewController *controller = [segue destinationViewController];
  nav.title = self.selectedMeal;
  
}

//---------------------Delegate Methods----------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  // Return the number of sections.
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
  // Return the number of rows in the section.
  if (section == 0)
    return 5;
  else
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyReuseIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
  }
  if (indexPath.row == 0 && indexPath.section == 0) {
    cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
    cell.textLabel.text = @"Choose your meal";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }
  if (indexPath.section == 0) {
    if (indexPath.row == 1) {
      cell.textLabel.text = @"Breakfast";
    }
    if (indexPath.row == 2) {
      cell.textLabel.text = @"Lunch";
    }
    if (indexPath.row == 3) {
      cell.textLabel.text = @"Dinner";
    }
    if (indexPath.row == 4) {
      cell.textLabel.text = @"Snacks";
    }
  }
  else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Add an exercise";
    }
  }
  else {
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Add Water";
    }
  }
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row >= 1 && indexPath.section == 0) {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedMeal = selectedCell.textLabel.text;
    [self performSegueWithIdentifier:@"selectFoodSegue" sender:self];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0 && indexPath.section == 0)
    return 30;
  else
    return 46;
}

@end
