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

@interface AddFoodViewController ()

@end

NSMutableArray *searchArray;
NSMutableArray *recentlyAddedArray;
NSMutableArray *customFoodsArray;

@implementation AddFoodViewController

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
  
  // Remove duplicate foods from array
  NSMutableSet *lookup = [[NSMutableSet alloc] init];
  for (int index = 0; index < [recentlyAddedArray count]; index++)
  {
    MyFood *curr = [recentlyAddedArray objectAtIndex:index];
    NSString *identifier = [NSString stringWithFormat:@"%@", [curr name]];
    
    // this is very fast constant time lookup in a hash table
    if ([lookup containsObject:identifier])
    {
      // NSLog(@"item already exists.  removing: %@ at index %d", identifier, index);
      [recentlyAddedArray removeObjectAtIndex:index];
    }
    else
    {
      //NSLog(@"distinct item.  keeping %@ at index %d", identifier, index);
      [lookup addObject:identifier];
    }
  }
  
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
  
  [self.tabBarTableView reloadData];
  
  
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
  
  else {
    
    RecentlyAddedBeforeSelectionViewController *destViewController = segue.destinationViewController;
    destViewController.title = [@"Add to " stringByAppendingFormat:[self title],nil];
    destViewController.foodToBeAdded = self.recentFoodToBeSentToNextView;
    destViewController.mealName = self.title;
    
  }
  
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  
  [self.tabBarTableView reloadData];
  
}


@end
