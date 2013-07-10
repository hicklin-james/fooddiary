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
    self.date.text = [self getStringOfDateWithoutTime:dateToShow];
  
  #define RADIANS(degrees) ((degrees * M_PI) / 180.0)
  
  CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                              RADIANS(180.0));
  
  self.rightArrowButton.transform = rotateTransform;
  
  
}

- (void) viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
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
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", todayStart, todayEnd];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"MyMeal" inManagedObjectContext:managedObjectContext]];
  [request setPredicate:predicate];
  [request setSortDescriptors:sortDescriptors];
  
  NSError *error = nil;
  NSMutableArray *results = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:request error:&error]];
  
  if ([results count] == 0) {
    
    NSLog(@"No meals found today, we must create some");
    
    MyMeal *breakfast = (MyMeal*)[NSEntityDescription insertNewObjectForEntityForName:@"MyMeal" inManagedObjectContext:managedObjectContext];
    [breakfast setName:@"Breakfast"];
    [breakfast setDate:date];
    
    if (![managedObjectContext save:&error]) {
      NSLog(@"There was an error saving the data");
    }
    
    MyMeal *lunch = (MyMeal*)[NSEntityDescription insertNewObjectForEntityForName:@"MyMeal" inManagedObjectContext:managedObjectContext];
    [lunch setName:@"Lunch"];
    [lunch setDate:date];
    
    if (![managedObjectContext save:&error]) {
      NSLog(@"There was an error saving the data");
    }
    
    MyMeal *dinner = (MyMeal*)[NSEntityDescription insertNewObjectForEntityForName:@"MyMeal" inManagedObjectContext:managedObjectContext];
    [dinner setName:@"Dinner"];
    [dinner setDate:date];
    
    if (![managedObjectContext save:&error]) {
      NSLog(@"There was an error saving the data");
    }
    
    MyMeal *snacks = (MyMeal*)[NSEntityDescription insertNewObjectForEntityForName:@"MyMeal" inManagedObjectContext:managedObjectContext];
    [snacks setName:@"Snacks"];
    [snacks setDate:date];
    
    //NSError *error = nil;
    if (![managedObjectContext save:&error]) {
      NSLog(@"There was an error saving the data");
    }
    
    [mealsToday addObject:breakfast];
    [mealsToday addObject:lunch];
    [mealsToday addObject:dinner];
    [mealsToday addObject:snacks];
    
  }  
  
  else {
    mealsToday = results;
  }
  
  
  for (int i = 0; i < [mealsToday count]; i++) {
    MyMeal *meal = [mealsToday objectAtIndex:i];
    NSLog([meal name], nil);
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    NSArray *tempFoods = [[meal toMyFood] allObjects];
    NSMutableArray *foods = [NSMutableArray arrayWithArray:[tempFoods sortedArrayUsingDescriptors:sortDescriptors]];
    
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

  
  MyFood *thisFood;
  MyServing *thisServing;
  
  if (indexPath.section == 0) {
    thisFood = [breakfastFoods objectAtIndex:indexPath.row];
  }
  
  if (indexPath.section == 1) {
    thisFood = [lunchFoods objectAtIndex:indexPath.row];
  }
  
  if (indexPath.section == 2) {
    thisFood = [dinnerFoods objectAtIndex:indexPath.row];
  }
  
  if (indexPath.section == 3) {
    thisFood = [snacksFoods objectAtIndex:indexPath.row];
  }
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(servingId == %d)", [[thisFood selectedServing] intValue]];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"MyServing" inManagedObjectContext:managedObjectContext]];
  [request setPredicate:predicate];
  
  NSError *error = nil;
  NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
  
  thisServing = [results objectAtIndex:0];
  
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
  

  
  NSManagedObject *foodToDelete;
  if (indexPath.section == 0) {
    foodToDelete = [breakfastFoods objectAtIndex:indexPath.row];
    [breakfastFoods removeObjectAtIndex:indexPath.row];
  }
  if (indexPath.section == 1) {
    foodToDelete = [lunchFoods objectAtIndex:indexPath.row];
    [lunchFoods removeObjectAtIndex:indexPath.row];
  }
  if (indexPath.section == 2) {
    foodToDelete = [dinnerFoods objectAtIndex:indexPath.row];
    [dinnerFoods removeObjectAtIndex:indexPath.row];
  }
  if (indexPath.section == 3) {
    foodToDelete = [snacksFoods objectAtIndex:indexPath.row];
    [snacksFoods removeObjectAtIndex:indexPath.row];
  }
  NSError *error = nil;
  //NSManagedObject *obj = [managedObjectContext existingObjectWithID:[foodToDelete objectID] error:&error];
  [managedObjectContext deleteObject:foodToDelete];
  [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
  
  if (![managedObjectContext save:&error]) {
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
}

- (IBAction)changeToPreviousDay:(id)sender {
  
  NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
  [componentsToSubtract setDay:-1];
  
  NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:dateToShow options:0];
  
  dateToShow = yesterday;
  self.date.text = [self getStringOfDateWithoutTime:dateToShow];
  
  
  [self refreshFoodData];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,4)] withRowAnimation:UITableViewRowAnimationRight];
  
  
}

- (IBAction)changeToNextDay:(id)sender {
  
  NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
  [componentsToAdd setDay:1];
  
  NSDate *nextDay = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToAdd toDate:dateToShow options:0];
  
  dateToShow = nextDay;
  self.date.text = [self getStringOfDateWithoutTime:dateToShow];

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
