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
#import "DetailFoodBeforeSelectionViewController.h"
#import "FDAppDelegate.h"
#import "MyMeal.h"
#import "MyFood.h"
#import "MyServing.h"

@interface FoodDiaryViewController ()

@end

@implementation FoodDiaryViewController

@synthesize managedObjectContext;
@synthesize mealsToday;
@synthesize breakfastFoods;
@synthesize lunchFoods;
@synthesize dinnerFoods;
@synthesize snacksFoods;
@synthesize dateToShow;

CGFloat calorieCountTodayFloat;
CGFloat totalCalsNeeded;

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
    NSDate *today = [NSDate date];
  NSString *todayString = [self getStringOfDateWithoutTime:today];
    NSString *thisDateToShow = [self getStringOfDateWithoutTime:dateToShow];
  if ([todayString isEqual:thisDateToShow]) {
    self.date.textColor = [UIColor greenColor];
  }
  else {
    self.date.textColor = [UIColor blackColor];
  }
  self.date.text = thisDateToShow;
  
  #define RADIANS(degrees) ((degrees * M_PI) / 180.0)
  
  CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                              RADIANS(180.0));
  self.rightArrowButton.transform = rotateTransform;
  
}

- (void) viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  totalCalsNeeded = [profile floatForKey:@"calsToConsumeToReachGoal"];
  calorieCountTodayFloat = 0;
  self.calorieCountToday.text = [NSString stringWithFormat:@"%.00f / %.00f calories today", calorieCountTodayFloat, totalCalsNeeded];
  
  [self refreshFoodData];
  [self.tableView reloadData];
  
  
 // NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
 // self.date.text = [formatter stringFromDate:dateWithoutTime];
  
  //[self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  // If there is no profile, present modal view to create a profile!
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  if ([profile boolForKey:@"profileSet"] == NO) {
  
    [self performSegueWithIdentifier:@"noProfileNameSegue" sender:self];
  
  }
  
}


// Called before segue into another view
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // set the FoodDiaryViewController as the delegate for the new view
  if ([segue.identifier isEqual: @"noProfileNameSegue"]) {
    
  }
  else {
    UINavigationController *nav = [segue destinationViewController];
    MealSelectionViewController *dest = (MealSelectionViewController*)[nav topViewController];
    dest.managedObjectContext = managedObjectContext;
    dest.mealsToday = mealsToday;
    dest.dateOfFood = dateToShow;
  }
  //[dest setDelegate:self];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------- HELPER METHODS -------------------//

- (void)refreshFoodData {
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = dateToShow;
  
  NSDate *todayStart = [self getDateForDateAndTime:calendar date:date hour:0 minutes:0 seconds:0];
  NSDate *todayEnd = [self getDateForDateAndTime:calendar date:date hour:23 minutes:59 seconds:59];
  
  NSMutableArray *results = [self fetchOrderedMealsForDate:todayStart end:todayEnd];
  calorieCountTodayFloat = 0;
  
  if ([results count] == 0) {
    NSLog(@"No meals found today, we must create some");
    [self createMealsForDay:date];
  }  
  else {
    mealsToday = results;
  }
  
  for (int i = 0; i < [mealsToday count]; i++) {
    MyMeal *meal = [mealsToday objectAtIndex:i];
    //NSLog([meal name], nil);
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    NSArray *tempFoods = [[meal toMyFood] allObjects];
    NSMutableArray *foods = [NSMutableArray arrayWithArray:[tempFoods sortedArrayUsingDescriptors:sortDescriptors]];
    
    [self updateCalorieCount:foods];
    [self updateGlobalArraysWithFoods:foods integer:i];
    
  }
}

-(void)updateGlobalArraysWithFoods:(NSMutableArray*)foods integer:(NSInteger)i {
  
  if ([[[mealsToday objectAtIndex:i] name] isEqual: @"Breakfast"]) {
    breakfastFoods = foods;
  }
  if ([[[mealsToday objectAtIndex:i] name] isEqual: @"Lunch"]) {
    lunchFoods = foods;
  }
  if ([[[mealsToday objectAtIndex:i] name] isEqual: @"Dinner"]) {
    dinnerFoods = foods;
  }
  if ([[[mealsToday objectAtIndex:i] name] isEqual: @"Snacks"]) {
    snacksFoods = foods;
  }
  
}

-(void)createMealsForDay:(NSDate*)date {
  
  NSError *error = nil;
  NSArray *mealNames = [NSArray arrayWithObjects:@"Breakfast", @"Lunch", @"Dinner", @"Snacks", nil];
  for (int i = 0; i < [mealNames count]; i++) {
    MyMeal *meal = (MyMeal*)[NSEntityDescription insertNewObjectForEntityForName:@"MyMeal" inManagedObjectContext:managedObjectContext];
    [meal setName:[mealNames objectAtIndex:i]];
    [meal setDate:date];
    // Need to save every time, otherwise order gets screwed up
    [managedObjectContext save:&error];
    [mealsToday addObject:meal];
  }
  
}

// Helper method that updates the calorie count at the top of the view
// ONLY CALLED WHEN VIEW APPEARS OR DATE CHANGES
-(void)updateCalorieCount:(NSMutableArray*)foods {
  
  for (int i = 0; i < [foods count]; i++) {
    MyFood *currentFood = [foods objectAtIndex:i];
    MyServing *currentServing = [self fetchServingFromFood:currentFood];
    
    self.date.text = [self getStringOfDateWithoutTime:dateToShow];
    calorieCountTodayFloat += [[currentServing calories]floatValue] * [[currentFood servingSize]floatValue];
  }
  self.calorieCountToday.text = [NSString stringWithFormat:@"%.00f / %.00f calories today", calorieCountTodayFloat, totalCalsNeeded];
  
}

// Helper method to fetch meals for the input data. Puts them in the correct order
// using NSSortDescriptors.
-(NSMutableArray*)fetchOrderedMealsForDate:(NSDate*)todayStart end:(NSDate*)todayEnd {
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", todayStart, todayEnd];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"MyMeal" inManagedObjectContext:managedObjectContext]];
  [request setPredicate:predicate];
  [request setSortDescriptors:sortDescriptors];
  
  NSError *error = nil;
  NSMutableArray *results = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:request error:&error]];
  
  return results;
  
}

- (NSDate *) getDateForDateAndTime:(NSCalendar *)calendar date:(NSDate*)date hour:(NSInteger)hour minutes:(NSInteger)minutes seconds:(NSInteger)seconds {
  
  NSDateComponents *compsStart = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
  [compsStart setHour:hour];
  [compsStart setMinute:minutes];
  [compsStart setSecond:seconds];
  NSDate *calculatedDate = [calendar dateFromComponents:compsStart];
  return calculatedDate;
  
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
  return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
  return [[mealsToday objectAtIndex:section] name];
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

  //FDAppDelegate *appDelegate = (FDAppDelegate*)[[UIApplication sharedApplication] delegate];
  // Return the number of rows in the section.
  if (section == 0) {
    return [breakfastFoods count];
  }
  
  if (section == 1) {
    return [lunchFoods count];
  }
  
  if (section == 2) {
    return [dinnerFoods count];
  }
  
  if (section == 3) {
    return [snacksFoods count];
  }
  
  NSLog(@"Something weird happened and the section wasn't there, so returning nil");
  return 0;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyReuseIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
  }

  // These will be the food and serving for this cell.
  // breakfastFoods, lunchFoods, dinnerFoods, and snacksFoods are already in order.
  // So we can just use the section and row to get this food.
  NSArray *meals = [NSArray arrayWithObjects:breakfastFoods, lunchFoods, dinnerFoods, snacksFoods, nil];
  MyFood *thisFood = [[meals objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

  // Fetch the current serving from core data
  MyServing *thisServing = [self fetchServingFromFood:thisFood];
  
  NSString * cals = [NSString stringWithFormat:@" %.01f Calories, ", [[thisServing calories] floatValue] * [[thisFood servingSize] floatValue]];
  NSString * fat = [NSString stringWithFormat:@"%.01fg of Fat, ", [[thisServing fat] floatValue] * [[thisFood servingSize] floatValue]];
  NSString * protein = [NSString stringWithFormat:@"%.01fg of protein, ", [[thisServing protein] floatValue] * [[thisFood servingSize] floatValue]];
  NSString * carbs = [NSString stringWithFormat:@"%.01fg of carbs", [[thisServing carbohydrates] floatValue] * [[thisFood servingSize] floatValue]];
  
  NSString *builtString = [[[cals stringByAppendingFormat:fat, nil] stringByAppendingFormat:protein, nil] stringByAppendingFormat:carbs, nil];
  
  cell.textLabel.text = [thisFood name];
  cell.detailTextLabel.text = builtString;
  cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
  cell.detailTextLabel.numberOfLines = 2;
  
  return cell;
}

// Helper method to set up a predicate using the servingId, which is unique
// to a serving. Check core data for that serving, and return it
-(MyServing*)fetchServingFromFood:(MyFood*)food {
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(servingId == %d)", [[food selectedServing] intValue]];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"MyServing" inManagedObjectContext:managedObjectContext]];
  [request setPredicate:predicate];
  
  NSError *error = nil;
  NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];

  return [results objectAtIndex:0];
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 71;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return YES;
  
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // Create an array with each meal, and use the indexPath section to decide which meal
  // was selected.
  // Next, use the indexPath row to decide which food from that meal was selected to delete.
  // Finally, remove it from the array.
  
  NSArray *meals = [NSArray arrayWithObjects:breakfastFoods, lunchFoods, dinnerFoods, snacksFoods, nil];
  NSMutableArray *mealFoods = [meals objectAtIndex:indexPath.section];
  MyFood *foodToDelete = [mealFoods objectAtIndex:indexPath.row];
  [mealFoods removeObjectAtIndex:indexPath.row];

  // Update calorie count
  [self updateCalorieCountAfterDeletion:foodToDelete];
  
  // delete from core data and table
  [managedObjectContext deleteObject:foodToDelete];
  [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
  
  NSError *error = nil;
  if (![managedObjectContext save:&error]) {
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
  
  MyServing *thisServing = [self fetchServingFromFood:foodToDelete];
  calorieCountTodayFloat -= [[thisServing calories] floatValue];
  self.calorieCountToday.text = [NSString stringWithFormat:@"%.00f / %.00f calories today", calorieCountTodayFloat, totalCalsNeeded];
  
}

- (IBAction)changeToPreviousDay:(id)sender {
  
  NSDate *yesterday = [self findDateWithOffset:-1];
  
  dateToShow = yesterday;
  NSDate *today = [NSDate date];
  NSString *todayString = [self getStringOfDateWithoutTime:today];
  NSString *thisDateToShow = [self getStringOfDateWithoutTime:dateToShow];
  [self createDateColor:todayString dateToShowString:thisDateToShow];
  self.date.text = thisDateToShow;
  
  [self refreshFoodData];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,4)] withRowAnimation:UITableViewRowAnimationRight];
  
  
}

// Helper method to set the color of the date string (GREEN if today)
-(void)createDateColor:(NSString*)todayString dateToShowString:(NSString*)dateToShowString {
  
  if ([todayString isEqual:dateToShowString]) {
    self.date.textColor = [UIColor greenColor];
  }
  else {
    self.date.textColor = [UIColor blackColor];
  }
  
}

-(NSDate*)findDateWithOffset:(NSInteger)offset {
  
  NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
  [componentsToSubtract setDay:offset];
  
  NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:dateToShow options:0];
  
  return yesterday;
  
}

- (IBAction)changeToNextDay:(id)sender {
  
  NSDate *nextDay = [self findDateWithOffset:1];
  dateToShow = nextDay;
  
  NSDate *today = [NSDate date];
  NSString *todayString = [self getStringOfDateWithoutTime:today];
  NSString *thisDateToShow = [self getStringOfDateWithoutTime:dateToShow];
  [self createDateColor:todayString dateToShowString:thisDateToShow];
  self.date.text = thisDateToShow;
  
  [self refreshFoodData];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,4)] withRowAnimation:UITableViewRowAnimationLeft];
}

-(NSString*) getStringOfDateWithoutTime:(NSDate*)date {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
  dateFormatter.dateFormat = @"EEEE, MM/dd/yy";
  
  NSString *dateString = [dateFormatter stringFromDate: date];
  
  
  return dateString;
  
}

@end
