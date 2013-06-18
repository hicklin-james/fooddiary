//
//  FoodDiaryViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "FoodDiaryViewController.h"
#import "FSClient.h"
#import "MealSelectionViewController.h"
#import "FoodDiaryDayController.h"
#import "FDFood.h"
#import "DetailFoodBeforeSelectionViewController.h"
#import "FDAppDelegate.h"

@interface FoodDiaryViewController ()

@end

@implementation FoodDiaryViewController

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

- (void) viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [self.tableView reloadData];
  
  FDAppDelegate *appDelegate = (FDAppDelegate*)[[UIApplication sharedApplication] delegate];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSString *formattedDate = [dateFormatter stringFromDate:[appDelegate.dataController date]];
  self.date.text = formattedDate;
  
}


// Called before segue into another view
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // set the FoodDiaryViewController as the delegate for the new view
  UINavigationController *nav = [segue destinationViewController];
  MealSelectionViewController *dest = (MealSelectionViewController*)[nav topViewController];
  //[dest setDelegate:self];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//------------------ DELEGATE METHODS ------------------//

// If the newMealViewController finished (either a new meal was added or the user
// cancelled it), dismiss the view controller. // ONLY WORKS WITH MODAL VIEWS
-(void)addFoodViewControllerDidFinish:(AddFoodViewController *)viewController{
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  // Return the number of sections.
  return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
  if (section == 0) {
    return @"Breakfast";
  }
  
  if (section == 1) {
    return @"Lunch";
  }
  
  if (section == 2) {
    return @"Dinner";
  }
  
  if (section == 3) {
    return @"Snacks";
  }
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

  FDAppDelegate *appDelegate = (FDAppDelegate*)[[UIApplication sharedApplication] delegate];
  // Return the number of rows in the section.
  if (section == 0) {
    return [appDelegate.dataController countOfFoodsInMeal:@"Breakfast"];
  }
  
  if (section == 1) {
    return [appDelegate.dataController countOfFoodsInMeal:@"Lunch"];
  }
  
  if (section == 2) {
    return [appDelegate.dataController countOfFoodsInMeal:@"Dinner"];
  }
  
  if (section == 3) {
    return [appDelegate.dataController countOfFoodsInMeal:@"Snacks"];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyReuseIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
  }
  
   FDAppDelegate *appDelegate = (FDAppDelegate*)[[UIApplication sharedApplication] delegate];
  
  NSString *title = [self tableView:tableView titleForHeaderInSection:indexPath.section];
  FDFood *thisFoodCustom = [appDelegate.dataController getFoodFromMeal:title index:indexPath.row];
  FSFood *thisFood = thisFoodCustom.food;
  cell.textLabel.text = [thisFood name];
  FSServing *selectedServing = [thisFood.servings objectAtIndex:[thisFoodCustom selectedServingIndex]];
  
  NSString * cals = [NSString stringWithFormat:@"%@ Calories, ", selectedServing.calories];
  NSString * fat = [NSString stringWithFormat:@"%@g of Fat, ", selectedServing.fat];
  NSString * protein = [NSString stringWithFormat:@"%@g of protein, ", selectedServing.protein];
  NSString * carbs = [NSString stringWithFormat:@"%@g of carbs", selectedServing.carbohydrate];
  
  NSString *builtString = [[[cals stringByAppendingFormat:fat] stringByAppendingFormat:protein] stringByAppendingFormat:carbs];
  
  cell.detailTextLabel.text = builtString;
  cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
  cell.detailTextLabel.numberOfLines = 2;
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 71;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}


@end
