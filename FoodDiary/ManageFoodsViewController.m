//
//  ManageFoodsViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-28.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "ManageFoodsViewController.h"
#import "CustomFood.h"
#import "UpdateCustomFoodViewController.h"

@interface ManageFoodsViewController ()

@end

@implementation ManageFoodsViewController

CustomFood *customFoodToPassForward;

@synthesize controller;
@synthesize customFoodsArray;

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
  controller = [MealController sharedInstance];
}

-(void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"CustomFood" inManagedObjectContext:[controller managedObjectContext]]];
  [request setSortDescriptors:sortDescriptors];
  NSError *error = nil;
  NSMutableArray *results = [NSMutableArray arrayWithArray:[[controller managedObjectContext] executeFetchRequest:request error:&error]];
  customFoodsArray = results;
  
  [self.tableView reloadData];
  [self.tableView setEditing:YES animated:YES];
  
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
  return [customFoodsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *standardIdentifier = @"cellId";
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:standardIdentifier];
  cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
  cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
  cell.detailTextLabel.textColor = [UIColor blackColor];

  CustomFood *food = [customFoodsArray objectAtIndex:indexPath.row];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.text = [food name];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%.00f cals", [[food calories] floatValue]];
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  customFoodToPassForward = [customFoodsArray objectAtIndex:indexPath.row];
  [self performSegueWithIdentifier:@"updateCustomFoodSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqual:@"updateCustomFoodSegue"]) {
    
    UpdateCustomFoodViewController *vc = (UpdateCustomFoodViewController*)segue.destinationViewController;
    vc.customFood = customFoodToPassForward;
    
  }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 45;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return YES;
  
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CustomFood *foodToDelete = [customFoodsArray objectAtIndex:indexPath.row];
  [customFoodsArray removeObjectAtIndex:indexPath.row];
  [[controller managedObjectContext] deleteObject:foodToDelete];
  NSError *error = nil;
  if (![[controller managedObjectContext] save:&error]) {
    [controller showDetailedErrorInfo:error];
  }
  
  [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

@end
