//
//  NewFoodNameViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-22.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "NewFoodNameViewController.h"
#import "NewFoodCell.h"
#import "MealController.h"
#import "CustomFood.h"
#import "NewFoodAttributesViewController.h"

@interface NewFoodNameViewController ()

@end

@implementation NewFoodNameViewController

NewFoodCell *nameCell;
NewFoodCell *servingSizeCell;
NewFoodCell *brandNameCell;

CustomFood *tempFood;

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

-(void)viewDidAppear:(BOOL)animated {
  
  [super viewDidAppear:animated];
  [nameCell.textField becomeFirstResponder];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 2;
  
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if (section == 0)
    return 3;
  else
    return 2;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
  if (indexPath.row == 0) {
    if (indexPath.section == 0) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"sectionOneHeader"];
    }
    else {
      cell = [tableView dequeueReusableCellWithIdentifier:@"sectionTwoHeader"];
    }
  }
  else if (indexPath.row == 1) {
    if (indexPath.section == 0) {
      nameCell = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];
      return nameCell;
    }
    else {
      brandNameCell = [tableView dequeueReusableCellWithIdentifier:@"brandNameCell"];
      return brandNameCell;
    }
    
  }
  else if (indexPath.row == 2) {
    servingSizeCell = [tableView dequeueReusableCellWithIdentifier:@"servingSizeCell"];
    return servingSizeCell;
  }
  
  return cell;
  
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == 0)
    return 30;
  else
    return 49;
  
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqual:@"nextViewSegue"]) {
    
    NewFoodAttributesViewController *vc = (NewFoodAttributesViewController*)segue.destinationViewController;
    vc.customFood = tempFood;
    
  }
  
}

- (IBAction)nextView:(id)sender {
  
  // Check to make sure that required cells have text in them
  if ([nameCell.textField.text isEqual:@""] || [servingSizeCell.textField.text isEqual:@""]) {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"The required fields must be filled out" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
    
  }
  
  else {
    
    MealController *controller = [MealController sharedInstance];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomFood" inManagedObjectContext:[controller managedObjectContext]];
    CustomFood *food = (CustomFood*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    //CustomFood *food = (CustomFood*)[NSEntityDescription insertNewObjectForEntityForName:@"CustomFood" inManagedObjectContext:[controller managedObjectContext]];
    [food setName:nameCell.textField.text];
    [food setServingDescription:servingSizeCell.textField.text];
    [food setBrandName:brandNameCell.textField.text];
    tempFood = food;
    [self performSegueWithIdentifier:@"nextViewSegue" sender:self];
  }
  
}

- (IBAction)cancelNewFood:(id)sender {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}
@end
