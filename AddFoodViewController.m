//
//  AddFoodViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-15.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "AddFoodViewController.h"
#import "FSClient.h"
#import "FSFood.h"
#import "FSServing.h"
#import "DetailFoodBeforeSelectionViewController.h"
#import "SVProgressHUD.h"
#import "MealController.h"
#import "DateManipulator.h"
#import "RecentlyAddedBeforeSelectionViewController.h"
#import "CustomFoodBeforeSelectionViewController.h"
#import "CurrentFoodsViewController.h"

@interface AddFoodViewController ()

@end

NSMutableArray *searchArray;
NSMutableArray *recentlyAddedArray;
NSMutableArray *customFoodsArray;

@implementation AddFoodViewController

@synthesize temporaryServings;
@synthesize temporaryFoods;
@synthesize foodsInMealButton;
@synthesize recentlyAdded;
@synthesize savedMeals;

// flag for no results found - NO for results, YES for no results
BOOL resultsFlag = NO;

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
  searchArray = [[NSMutableArray alloc] init];
  CGRect viewFrame=self.tabBar.frame;
  viewFrame.size.height=35;
  self.tabBar.frame=viewFrame;
  [recentlyAdded setTitlePositionAdjustment:UIOffsetMake(0,-10)];
  [savedMeals setTitlePositionAdjustment:UIOffsetMake(0,-10)];
  
  self.tabBar.selectedItem = recentlyAdded;
  
  DateManipulator *dateManipulator = [[DateManipulator alloc] initWithDateFormatter];
  NSDate *recentFoodsDate = [dateManipulator findDateWithOffset:-2 date:[NSDate date]];
  
  MealController *controller = [MealController sharedInstance];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@)", recentFoodsDate];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"MyFood" inManagedObjectContext:[controller managedObjectContext]]];
  [request setPredicate:predicate];
  [request setSortDescriptors:sortDescriptors];
  
  NSError *error = nil;
  NSMutableArray *results = [NSMutableArray arrayWithArray:[[controller managedObjectContext] executeFetchRequest:request error:&error]];
  
  recentlyAddedArray = results;
  
  temporaryFoods = [[NSMutableArray alloc] init];
  temporaryServings = [[NSMutableArray alloc] init];
  
  // Remove duplicate foods from array
  NSMutableSet *lookup = [[NSMutableSet alloc] init];
  NSMutableArray *arrayCopy = [[NSMutableArray alloc] init];
  
  for (int index = 0; index < [recentlyAddedArray count]; index++)
  {
    MyFood *curr = [recentlyAddedArray objectAtIndex:index];
    NSString *identifier = [NSString stringWithFormat:@"%@", [curr name]];
    
    // this is very fast constant time lookup in a hash table
    if ([lookup containsObject:identifier])
    {
       NSLog(@"item already exists.  removing: %@ at index %d", identifier, index);
      //[recentlyAddedArray removeObjectAtIndex:index];
    }
    else
    {
      NSLog(@"distinct item.  keeping %@ at index %d", identifier, index);
      [lookup addObject:identifier];
      [arrayCopy addObject:curr];
    }
  }
  
    recentlyAddedArray = arrayCopy;

}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  MealController *controller = [MealController sharedInstance];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"CustomFood" inManagedObjectContext:[controller managedObjectContext]]];
  [request setSortDescriptors:sortDescriptors];
  NSError *error = nil;
  NSMutableArray *results = [NSMutableArray arrayWithArray:[[controller managedObjectContext] executeFetchRequest:request error:&error]];
  customFoodsArray = results;
  
  //[self.searchDisplayController setActive:NO];
  
  [self setupFoodsInMealButton];
  
  [self.tabBarTableView reloadData];
  
}

-(void)setupFoodsInMealButton {
  
  if ([temporaryFoods count] == 0) {
    //foodsInMealButton.titleLabel.text = @"No items added to meal";
     [foodsInMealButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [foodsInMealButton setTitle:@"No items added to meal" forState:UIControlStateNormal];
    [foodsInMealButton setTitle:@"No items added to meal" forState:UIControlStateHighlighted];
  }
  else if ([temporaryFoods count] == 1){
    foodsInMealButton.titleLabel.numberOfLines = 0;
    [foodsInMealButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [foodsInMealButton setTitle:[NSString stringWithFormat:@"%d food in meal, tap here to see food", [temporaryFoods count]] forState:UIControlStateNormal];
    [foodsInMealButton setTitle:[NSString stringWithFormat:@"%d food in meal, tap here to see food", [temporaryFoods count]] forState:UIControlStateHighlighted];
  }
  else {
    foodsInMealButton.titleLabel.numberOfLines = 0;
    [foodsInMealButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [foodsInMealButton setTitle:[NSString stringWithFormat:@"%d foods in meal, tap here to see foods", [temporaryFoods count]] forState:UIControlStateNormal];
    [foodsInMealButton setTitle:[NSString stringWithFormat:@"%d foods in meal, tap here to see foods", [temporaryFoods count]] forState:UIControlStateHighlighted];
  }
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)handleCancelButton:(id)sender {
  
}

- (IBAction)newFood:(id)sender {
  
  [self performSegueWithIdentifier:@"newFoodSegue" sender:self];
  
}

- (IBAction)transitionToCurrentFoods:(id)sender {
  
  if ([temporaryFoods count] > 0) {
    
    [self performSegueWithIdentifier:@"currentMealFoodsSegue" sender:self];
    
  }
  
}

- (IBAction)saveFoodsFromThisView:(id)sender {
  [self saveFoods];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if (aTableView == self.tabBarTableView) {
    if (self.tabBar.selectedItem == recentlyAdded)
      return [recentlyAddedArray count]+1;
    else
      return [customFoodsArray count]+1;
    
  }
  else //if (self.tabBar.selectedItem == recentlyAdded)
    return [searchArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  // Return the number of sections.
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"CellIdentifier";
  
  // Dequeue or create a cell of the appropriate type.
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  if (tableView == self.tabBarTableView) {
    
    if (self.tabBar.selectedItem == recentlyAdded) {
      if (indexPath.row == [recentlyAddedArray count]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"createFoodCell"];
        return cell;
      }
      else {
        MyFood *food = [recentlyAddedArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [food name];
        //NSString *test = [food foodDescription];
        cell.detailTextLabel.text = [food foodDescription];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        cell.detailTextLabel.numberOfLines = 2;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      }
    }
    else {
      if (indexPath.row == [customFoodsArray count]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"createFoodCell"];
        return cell;
      }
      else {
        CustomFood *food = [customFoodsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [food name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Per %@ - Calories: %.00fkcal", [food servingDescription], [[food calories] floatValue]];
      }
    }
  }
  else {//if (tableView == self.searchDisplayController.searchResultsTableView) {
    
    // Configure the cell.
    FSFood *thisCellFood = [searchArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [thisCellFood name];
    cell.detailTextLabel.text = [thisCellFood foodDescription];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.detailTextLabel.numberOfLines = 2;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
  }
  
  return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tableView == self.tabBarTableView)
    return 53;
  else
    return 71;
}

// Don't allow search during typing
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
  return NO;
}


// Called just before search table opens - RELOAD THE TABLE!!
-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
  // clear the array so that it doesn't show old results
  [searchArray removeAllObjects];
  //resultsFlag = NO;
  [self.searchDisplayController.searchResultsTableView reloadData];
}



// called when search button is clicked - restrict FatSecret API calls to here so that I don't hit my request limit.
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
  [searchArray removeAllObjects];
  [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
  [[FSClient sharedClient] searchFoods:[searchBar text]
                            pageNumber:0
                            maxResults:40
                            completion:^(NSArray *foods, NSInteger maxResults, NSInteger totalResults, NSInteger pageNumber) {
                              // Callback returned, use data now
                              [SVProgressHUD dismiss];
                              if (!foods || !foods.count) {
                                //resultsFlag = YES;
                              } else {
                                //resultsFlag = NO;
                                for (int i = 0; i < [foods count]; i++) {
                                  [searchArray addObject:[foods objectAtIndex:i]];
                                }
                              }
                              [self.searchDisplayController.searchResultsTableView reloadData];
                            }];
  
  //  [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    self.foodToBeSentToNextView = [searchArray objectAtIndex:indexPath.row];
    NSInteger selectedFoodId = [self.foodToBeSentToNextView identifier];
    self.foodDescription = [self.foodToBeSentToNextView foodDescription];
    
    [[FSClient sharedClient] getFood:selectedFoodId
                          completion:^(FSFood *food) {
                            [SVProgressHUD dismiss];
                            self.foodToBeSentToNextView = food;
                            
                            [self performSegueWithIdentifier:@"showFoodDetail" sender:self];
                            
                            [tableView deselectRowAtIndexPath:indexPath animated:YES];
                            
                            
                          }];
    
  }
  else if (self.tabBar.selectedItem == recentlyAdded){
    if (indexPath.row == [recentlyAddedArray count]) {
      
    }
    else {
      self.recentFoodToBeSentToNextView = [recentlyAddedArray objectAtIndex:indexPath.row];
      [self performSegueWithIdentifier:@"recentlyAddedFoodSegue" sender:self];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
  }
  else if (self.tabBar.selectedItem == savedMeals){
    self.customFoodToBeSentToNextView = [customFoodsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"customFoodDetailSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"showFoodDetail"]) {
    DetailFoodBeforeSelectionViewController *destViewController = segue.destinationViewController;
    
    destViewController.title = [@"Add to " stringByAppendingFormat:[self title],nil];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    destViewController.detailedFood = self.foodToBeSentToNextView;
    destViewController.mealName = self.title;
    destViewController.foodDescription = self.foodDescription;
  }
  
  else if ([segue.identifier isEqual:@"newFoodSegue"]) {
    
  }
  else if ([segue.identifier isEqual:@"customFoodDetailSegue"]) {
    CustomFoodBeforeSelectionViewController *destViewController = segue.destinationViewController;
    destViewController.title = [@"Add to " stringByAppendingFormat:[self title],nil];
    destViewController.detailedFood = self.customFoodToBeSentToNextView;
    destViewController.mealName = self.title;
  }
  
  else if ([segue.identifier isEqual:@"recentlyAddedFoodSegue"]) {
    
    RecentlyAddedBeforeSelectionViewController *destViewController = segue.destinationViewController;
    destViewController.title = [@"Add to " stringByAppendingFormat:[self title],nil];
    destViewController.foodToBeAdded = self.recentFoodToBeSentToNextView;
    destViewController.mealName = self.title;
    
  }
  
  else {
    
    CurrentFoodsViewController *destViewController = segue.destinationViewController;
    destViewController.mealTitle = self.title;
    destViewController.servings = temporaryServings;
    destViewController.foods = temporaryFoods;
  }
  
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  
  [self.tabBarTableView reloadData];
  
}

-(void)saveFoods {
  
  MealController *controller = [MealController sharedInstance];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = [controller dateToShow];
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
  
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (name == %@)", todayStart, todayEnd, self.title];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"MyMeal" inManagedObjectContext:[controller managedObjectContext]]];
  [request setPredicate:predicate];
  
  NSError *error = nil;
  NSArray *results = [[controller managedObjectContext] executeFetchRequest:request error:&error];
  
  NSArray *thisMeal = results;
  MyMeal *theMeal = [thisMeal objectAtIndex:0];

  for (int i = 0; i < [temporaryFoods count]; i++) {
    
    MyFood *food = [temporaryFoods objectAtIndex:i];
    [[controller managedObjectContext] insertObject:food];
    NSMutableArray *servings = [temporaryServings objectAtIndex:i];
    for (int s = 0; s < [servings count]; s++) {
      MyServing *serving = [servings objectAtIndex:s];
      [[controller managedObjectContext] insertObject:serving];
      [serving setToMyFood:food];
    }
    //[[controller managedObjectContext] insertObject:food];
    [food setToMyMeal:theMeal];
    NSDate *date = [controller dateToShow];
    [food setDateOfCreation:[NSDate date]];
     [food setDate:date];
    
   // [[controller managedObjectContext] insertObject:food];
    
    if (![[controller managedObjectContext] save:&error]) {
      [controller showDetailedErrorInfo:error];
    }
    
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

@end
