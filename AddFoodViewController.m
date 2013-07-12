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

@interface AddFoodViewController ()

@end

NSMutableArray *searchArray;

@implementation AddFoodViewController

@synthesize managedObjectContext;
@synthesize mealsToday;
@synthesize dateOfFood;

// flag for no results found - NO for results, YES for no results
BOOL resultsFlag = NO;

-(void)handleCancelButton:(id)sender {
    
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (resultsFlag == YES)
        return 1;
    else
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
    
    // Configure the cell.
    if (resultsFlag == YES) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        cell.detailTextLabel.text = @"No results found. Are you connected to the internet?";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
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
    resultsFlag = NO;
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
                                      resultsFlag = YES;
                                  } else {
                                      resultsFlag = NO;
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
        
        if (!resultsFlag) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            self.foodToBeSentToNextView = [searchArray objectAtIndex:indexPath.row];
            
            NSInteger selectedFoodId = [self.foodToBeSentToNextView identifier];
            
            [[FSClient sharedClient] getFood:selectedFoodId
                                  completion:^(FSFood *food) {
                                      [SVProgressHUD dismiss];
                                      self.foodToBeSentToNextView = food;
                                      
                                      [self performSegueWithIdentifier:@"showFoodDetail" sender:self];
                                      
                                      [tableView deselectRowAtIndexPath:indexPath animated:YES];
                                      
                                      
                                  }];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DetailFoodBeforeSelectionViewController *destViewController = segue.destinationViewController;
    
    destViewController.title = [@"Add to " stringByAppendingFormat:[self title],nil];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    destViewController.detailedFood = self.foodToBeSentToNextView;
    destViewController.mealName = self.title;
    destViewController.managedObjectContext = managedObjectContext;
    destViewController.mealsToday = mealsToday;
    destViewController.dateOfFood = dateOfFood;
    
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
    searchArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
