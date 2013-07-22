//
//  FoodDiaryViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "FoodDiaryViewController.h"
#import "MealSelectionViewController.h"
#import "DetailedFoodViewController.h"
#import "MyFood.h"
#import "MyServing.h"
#import "DateManipulator.h"

@interface FoodDiaryViewController ()

@end

@implementation FoodDiaryViewController

@synthesize controller;
@synthesize foodToPassToDetailView;
@synthesize servingToPassToDetailView;

DateManipulator *dateManipulator;

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
  // Get shared instance of data controller
  controller = [MealController sharedInstance];
  
  dateManipulator = [[DateManipulator alloc] initWithDateFormatter];
  
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
  CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                              RADIANS(180.0));
  self.rightArrowButton.transform = rotateTransform;
  
}

- (void) viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  
  NSString *todayString = [dateManipulator getStringOfDateWithoutTime:[NSDate date]];
  NSString *thisDateToShow = [dateManipulator getStringOfDateWithoutTime:controller.dateToShow];
  UIColor *dateColor = [dateManipulator createDateColor:todayString dateToShowString:thisDateToShow];
  self.date.textColor = dateColor;
  self.date.text = thisDateToShow;
  
  [controller refreshFoodData];
  [self updateCalorieCount];
  
  [self.tableView reloadData];
  
}

// Called before segue into another view
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // set the FoodDiaryViewController as the delegate for the new view
  if ([segue.identifier isEqual: @"noProfileNameSegue"]) {
    
  }
  else if ([segue.identifier isEqual: @"detailedViewSegue"]) {
    // UINavigationController *nav = [segue destinationViewController];
    DetailedFoodViewController *dest = (DetailedFoodViewController*)[segue destinationViewController];
    dest.detailedFood = foodToPassToDetailView;
    dest.currentServing = servingToPassToDetailView;
    //dest.managedObjectContext = managedObjectContext;
  }
  else {
    //UINavigationController *nav = [segue destinationViewController];
    //MealSelectionViewController *dest = (MealSelectionViewController*)[nav topViewController];
    //dest.managedObjectContext = managedObjectContext;
    //dest.mealsToday = [controller mealsToday];
    //dest.dateOfFood = controller.dateToShow;
  }
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//------------------- HELPER METHODS -------------------//

// Helper method that updates the calorie count at the top of the view
// ONLY CALLED WHEN VIEW APPEARS OR DATE CHANGES
-(void)updateCalorieCount {
  
  self.date.text = [dateManipulator getStringOfDateWithoutTime:controller.dateToShow];
  
  self.goalCals.text = [NSString stringWithFormat:@"%.00f", controller.totalCalsNeeded];
  self.todaysCals.text = [NSString stringWithFormat:@"%.00f", controller.calorieCountTodayFloat];
  self.remainingCals.text = [NSString stringWithFormat:@"%.00f", controller.totalCalsNeeded-controller.calorieCountTodayFloat];
  
}

//------------------ DELEGATE METHODS ------------------//

// If the newMealViewController finished (either a new meal was added or the user
// cancelled it), dismiss the view controller. // ONLY WORKS WITH MODAL VIEWS
-(void)addFoodViewControllerDidFinish:(AddFoodViewController *)viewController{
  [self dismissViewControllerAnimated:YES completion:nil];
}


//--------------------Table View Delegate Methods------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  // Return the number of sections.
  //return [self checkNumberOfSections];
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
  if (section == 0) {
    return [[controller breakfastFoods] count]+1;
  }
  
  if (section == 1) {
    return [[controller lunchFoods] count]+1;
  }
  
  if (section == 2) {
    return [[controller dinnerFoods] count]+1;
  }
  
  if (section == 3) {
    return [[controller snacksFoods] count]+1;
  }
  
  NSLog(@"Something weird happened and the section wasn't there, so returning nil");
  return 0;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyReuseIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
  }
  if (indexPath.row == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    UILabel *headerLabel = (UILabel *)[cell.contentView viewWithTag:6];
    //cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
    headerLabel.text = [[[controller mealsToday] objectAtIndex:indexPath.section] name];
    
    UIButton *headerButton = (UIButton*)[cell.contentView viewWithTag:8];
    [headerButton addTarget:self action:@selector(saveMeal: indexPath:) forControlEvents:UIControlEventTouchUpInside];
    //cell.textLabel.textColor = [UIColor whiteColor];
    //UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    //cell.backgroundColor = color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  }
  else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    // These will be the food and serving for this cell.
    // breakfastFoods, lunchFoods, dinnerFoods, and snacksFoods are already in order.
    // So we can just use the section and row to get this food.
    NSArray *meals = [NSArray arrayWithObjects:[controller breakfastFoods], [controller lunchFoods], [controller dinnerFoods], [controller snacksFoods], nil];
    MyFood *thisFood = [[meals objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
    
    // Fetch the current serving from core data
    MyServing *thisServing = [controller fetchServingFromFood:thisFood];
    
    NSString * cals = [NSString stringWithFormat:@" %.01f cals", [[thisServing calories] floatValue] * [[thisFood servingSize] floatValue]];
    
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:2];
    UILabel *servingLabel = (UILabel*)[cell viewWithTag:3];
    UILabel *calsLabel = (UILabel*)[cell viewWithTag:4];
    
    nameLabel.adjustsFontSizeToFitWidth = YES;
    NSString *addedPart = [NSString stringWithFormat:@"%d x ", [[thisFood servingSize] integerValue]];
    servingLabel.text = [addedPart stringByAppendingFormat:[thisServing servingDescription],nil];
    calsLabel.text = cals;
    nameLabel.text = [thisFood name];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row > 0) {
    NSArray *meals = [NSArray arrayWithObjects:[controller breakfastFoods], [controller lunchFoods], [controller dinnerFoods], [controller snacksFoods], nil];
    foodToPassToDetailView = [[meals objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
    // Fetch the current serving from core data
    servingToPassToDetailView = [controller fetchServingFromFood:foodToPassToDetailView];
  
    [self performSegueWithIdentifier:@"detailedViewSegue" sender:self];
  }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0)
    return 30;
  else
    return 47;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
  if(section == 0)
    return 6;
  return 1.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
  return 5.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
  return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
  return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == 0)
    return NO;
  else
    return YES;
  
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // Create an array with each meal, and use the indexPath section to decide which meal
  // was selected.
  // Next, use the indexPath row to decide which food from that meal was selected to delete.
  // Finally, remove it from the array.
  
  NSArray *meals = [NSArray arrayWithObjects:[controller breakfastFoods], [controller lunchFoods], [controller dinnerFoods], [controller snacksFoods], nil];
  NSMutableArray *mealFoods = [meals objectAtIndex:indexPath.section];
  MyFood *foodToDelete = [mealFoods objectAtIndex:indexPath.row-1];
  [mealFoods removeObjectAtIndex:indexPath.row-1];
  
  // Update calorie count
  [self updateCalorieCountAfterDeletion:foodToDelete];
  
  // delete from core data and table
  [[controller managedObjectContext] deleteObject:foodToDelete];
  [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
  
  NSError *error = nil;
  if (![[controller managedObjectContext] save:&error]) {
    [self showDetailedErrorInfo:error];
  }
}

// Helper method to provide detailed error information from core data
- (void) showDetailedErrorInfo:(NSError*)error {
  NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
  NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
  if(detailedErrors != nil && [detailedErrors count] > 0) {
    for(NSError* detailedError in detailedErrors) {
      NSLog(@"  DetailedError: %@", [detailedError userInfo]);
    }
  }
  else {
    NSLog(@"  %@", [error userInfo]);
  }
}

// Helper method to update the calorie count before deleting a food.
-(void)updateCalorieCountAfterDeletion:(MyFood*)foodToDelete {
  
  MyServing *thisServing = [controller fetchServingFromFood:foodToDelete];
  controller.calorieCountTodayFloat -= [[thisServing calories] floatValue]*[[foodToDelete servingSize]floatValue];
  self.todaysCals.text = [NSString stringWithFormat:@"%.00f", controller.calorieCountTodayFloat];
  [self updateCalorieCount];
  
}

NSInteger selectedMealToSave;

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  
//  if (buttonIndex == 1) {
//    [self performSegueWithIdentifier:@"saveMealSegue" sender:self];
//  }
  
}

- (void)saveMeal:(id)sender indexPath:(NSIndexPath*)indexPath {
  
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Save Meal" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save", nil];
  
  [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
  [actionSheet showInView:self.tabBarController.view];
  
  //NSIndexPath *index = [self.tableView indexPathForCell:sender];
 // NSLog ([NSString stringWithFormat:@"%d",indexPath.section]);
  
}

//-----------------Methods used when changing dates-------------------//
- (IBAction)changeToPreviousDay:(id)sender {
  
  NSDate *yesterday = [dateManipulator findDateWithOffset:-1 date:controller.dateToShow];
  
  controller.dateToShow = yesterday;
  NSDate *today = [NSDate date];
  NSString *todayString = [dateManipulator getStringOfDateWithoutTime:today];
  NSString *thisDateToShow = [dateManipulator getStringOfDateWithoutTime:controller.dateToShow];
  UIColor *dateColor = [dateManipulator createDateColor:todayString dateToShowString:thisDateToShow];
  self.date.textColor = dateColor;
  self.date.text = thisDateToShow;
  
  [controller refreshFoodData];
  [self updateCalorieCount];
  //[self refreshFoodData];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,4)] withRowAnimation:UITableViewRowAnimationRight];
  //[self.tableView reloadData];
  
}

- (IBAction)changeToNextDay:(id)sender {
  
  NSDate *nextDay = [dateManipulator findDateWithOffset:1 date:controller.dateToShow];
  controller.dateToShow = nextDay;
  
  NSDate *today = [NSDate date];
  NSString *todayString = [dateManipulator getStringOfDateWithoutTime:today];
  NSString *thisDateToShow = [dateManipulator getStringOfDateWithoutTime:controller.dateToShow];
  UIColor *dateColor = [dateManipulator createDateColor:todayString dateToShowString:thisDateToShow];
  self.date.textColor = dateColor;
  self.date.text = thisDateToShow;
  
  [controller refreshFoodData];
  [self updateCalorieCount];
  //[self refreshFoodData];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,4)] withRowAnimation:UITableViewRowAnimationLeft];
  //[self.tableView reloadData];
}

@end
