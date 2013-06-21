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

@interface FoodDiaryViewController ()

@end

@implementation FoodDiaryViewController

@synthesize managedObjectContext;
@synthesize mealsToday;

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
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = [NSDate date];
  NSDateComponents *compsStart = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
  [compsStart setHour:0];
  [compsStart setMinute:0];
  [compsStart setSecond:0];
  NSDate *todayStart = [calendar dateFromComponents:compsStart];
  
  NSDateComponents *compsEnd = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
  [compsEnd setHour:23];
  [compsEnd setMinute:59];
  [compsEnd setSecond:59];
  NSDate *todayEnd = [calendar dateFromComponents:compsEnd];
  
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", todayStart, todayEnd];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"MyMeal" inManagedObjectContext:managedObjectContext]];
  [request setPredicate:predicate];
  [request setSortDescriptors:sortDescriptors];
  
  NSError *error = nil;
  NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
  
  mealsToday = results;
  [self.tableView reloadData];

  NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
 // self.date.text = [formatter stringFromDate:dateWithoutTime];
  
}


// Called before segue into another view
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // set the FoodDiaryViewController as the delegate for the new view
  UINavigationController *nav = [segue destinationViewController];
  MealSelectionViewController *dest = (MealSelectionViewController*)[nav topViewController];
  dest.managedObjectContext = managedObjectContext;
  dest.mealsToday = mealsToday;
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
  //if (section == 0) {
  
  MyMeal *meal = [mealsToday objectAtIndex:section];
  NSInteger count = [[meal toMyFood] count];
  return count;
    //return [appDelegate.dataController countOfFoodsInMeal:@"Breakfast"];
 // }
  
  //if (section == 1) {
  //  return [appDelegate.dataController countOfFoodsInMeal:@"Lunch"];
  //}
  
 // if (section == 2) {
 //   return [appDelegate.dataController countOfFoodsInMeal:@"Dinner"];
 // }
  
 // if (section == 3) {
  //  return [appDelegate.dataController countOfFoodsInMeal:@"Snacks"];
  //}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyReuseIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
  }
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  
  MyMeal *meal = [mealsToday objectAtIndex:indexPath.section];
  NSArray *theseFoods = [[[meal toMyFood] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
  
  MyFood *thisFood = [theseFoods objectAtIndex:indexPath.row];
  
  //FSFood *thisFood = thisFoodCustom.food;
  //cell.textLabel.text = [thisFood name];
  //FSServing *selectedServing = [thisFood.servings objectAtIndex:[thisFoodCustom selectedServingIndex]];

  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(servingId == %d)", [[thisFood selectedServing] intValue]];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"MyServing" inManagedObjectContext:managedObjectContext]];
  [request setPredicate:predicate];
  
  NSError *error = nil;
  NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
  if ([results count] > 0) {
    MyServing *thisServing = [results objectAtIndex:0];
  
    NSString * cals = [NSString stringWithFormat:@" %.01f Calories, ", [[thisServing calories] floatValue] * [[thisFood servingSize] floatValue]];
    NSString * fat = [NSString stringWithFormat:@"%.01fg of Fat, ", [[thisServing fat] floatValue] * [[thisFood servingSize] floatValue]];
    NSString * protein = [NSString stringWithFormat:@"%.01fg of protein, ", [[thisServing protein] floatValue] * [[thisFood servingSize] floatValue]];
    NSString * carbs = [NSString stringWithFormat:@"%.01fg of carbs", [[thisServing carbohydrates] floatValue] * [[thisFood servingSize] floatValue]];
  
    NSString *builtString = [[[cals stringByAppendingFormat:fat] stringByAppendingFormat:protein] stringByAppendingFormat:carbs];
    cell.textLabel.text = [thisFood name];
    cell.detailTextLabel.text = builtString;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.numberOfLines = 2;
  }
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
  
//  FDAppDelegate *appDelegate = (FDAppDelegate*)[[UIApplication sharedApplication] delegate];
//  FoodDiaryMealDataController *controller = [appDelegate dataController];
//  NSString *title = [self tableView:tableView titleForHeaderInSection:indexPath.section];
//  [controller deleteFoodFromMeal:title index:indexPath.row];
//  [tableView reloadData];
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = [NSDate date];
  NSDateComponents *compsStart = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
  [compsStart setHour:0];
  [compsStart setMinute:0];
  [compsStart setSecond:0];
  NSDate *todayStart = [calendar dateFromComponents:compsStart];
  
  NSDateComponents *compsEnd = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
  [compsEnd setHour:23];
  [compsEnd setMinute:59];
  [compsEnd setSecond:59];
  NSDate *todayEnd = [calendar dateFromComponents:compsEnd];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (name == %@)", todayStart, todayEnd, [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"MyFood" inManagedObjectContext:managedObjectContext]];
  [request setPredicate:predicate];
  [request setSortDescriptors:sortDescriptors];
  
  NSError *error = nil;
  
  MyMeal *meal = [mealsToday objectAtIndex:indexPath.section];
  NSArray *foods = [[meal toMyFood] allObjects];
 // NSMutableArray *results = [NSMutableArray arrayWithArray:[foods sortedArrayUsingDescriptors:sortDescriptors]];
  
  NSMutableArray *results = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:request error:&error]];
  
  NSManagedObject *objectToDelete = [results objectAtIndex:indexPath.row];
  [managedObjectContext deleteObject:objectToDelete];
  
  
  
  // NEED TO UPDATE MEALSTODAY ARRAY BY REFETCHING RESULTS
  
  predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", todayStart, todayEnd];
  
  request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"MyMeal" inManagedObjectContext:managedObjectContext]];
  [request setPredicate:predicate];
  [request setSortDescriptors:sortDescriptors];
  

  NSArray *newresults = [managedObjectContext executeFetchRequest:request error:&error];
  
  mealsToday = newresults;
  
  
  
  //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
  //[self.tableView reloadData];

  if (![managedObjectContext save:&error]) {
    NSLog(@"Didn't delete properly");
  }
}


@end
