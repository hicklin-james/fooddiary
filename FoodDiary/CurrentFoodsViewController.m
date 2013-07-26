//
//  CurrentFoodsViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-25.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "CurrentFoodsViewController.h"
#import "MealController.h"
#import "AddFoodViewController.h"
#import "MyFood.h"
#import "MyServing.h"

@interface CurrentFoodsViewController ()

@end

@implementation CurrentFoodsViewController

@synthesize mealTitle;
@synthesize foods;
@synthesize servings;

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [foods count] + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  if (indexPath.row == 0) {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold"size:12];
    cell.textLabel.text = [NSString stringWithFormat:@"Add these to %@", mealTitle];
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }
  
  else {
  static NSString *identifier = @"foodCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  
  
  MyFood *thisFood = (MyFood*)[foods objectAtIndex:indexPath.row-1];
  NSMutableArray *foodServings = [servings objectAtIndex:indexPath.row-1];
  MyServing *thisServing;
  for (int i = 0; i < [foodServings count]; i++) {
    MyServing *serving = [foodServings objectAtIndex:i];
    if ([[serving servingId] isEqual:[thisFood selectedServing]])
      thisServing = serving;
  }
  
  NSString * cals = [NSString stringWithFormat:@" %.01f cals", [[thisServing calories] floatValue] * [[thisFood servingSize] floatValue]];
  
  UILabel *nameLabel = (UILabel*)[cell viewWithTag:2];
  UILabel *servingLabel = (UILabel*)[cell viewWithTag:3];
  UILabel *calsLabel = (UILabel*)[cell viewWithTag:4];
  
  nameLabel.adjustsFontSizeToFitWidth = YES;
  NSString *addedPart = [NSString stringWithFormat:@"%d x ", [[thisFood servingSize] integerValue]];
  servingLabel.text = [addedPart stringByAppendingFormat:[thisServing servingDescription],nil];
  calsLabel.text = cals;
  nameLabel.text = [thisFood name];
  
  return cell;
  }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == 0)
    return 30;
  else
    return 47;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == 0)
    return NO;
  else
    return YES;
  
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

  [foods removeObjectAtIndex:indexPath.row-1];
  [servings removeObjectAtIndex:indexPath.row-1];
  [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
  
}

- (IBAction)closeCurrentFoods:(id)sender {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (IBAction)saveCurrentFoods:(id)sender {
  
  UINavigationController *controller = (UINavigationController*)[self presentingViewController];
  AddFoodViewController *vc = (AddFoodViewController*)[[controller viewControllers] objectAtIndex:1];
  
  [self dismissViewControllerAnimated:YES completion:^{
    [vc saveFoods];
  }];

  
}
@end
