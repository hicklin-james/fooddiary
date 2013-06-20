//
//  DetailFoodBeforeSelectionViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-15.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "DetailFoodBeforeSelectionViewController.h"
#import "FSClient.h"
#import "FDAppDelegate.h"

@interface DetailFoodBeforeSelectionViewController ()

@end

ActionSheetCustomPicker *unitPicker;
ActionSheetCustomPicker *servingSizePicker;

@implementation DetailFoodBeforeSelectionViewController
@synthesize detailedFood;


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
  self.servingSize = 1;
  FSServing *serving = [self.detailedFood.servings objectAtIndex:0];
  self.selectedServing = serving;
  FDFood * currentFood = [[FDFood alloc] initWithIndex:0 theFood:self.detailedFood mealName:self.mealName servingSize:self.servingSize];
  self.customFood = currentFood;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addFoodToMeal:(id)sender {
  
  FDAppDelegate *appDelegate = (FDAppDelegate*)[[UIApplication sharedApplication] delegate];
  [appDelegate.dataController addFoodToMeal:self.mealName food:self.customFood];
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  
}

//------------------Picker Delegate Methods---------------------//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  
  if (pickerView == unitPicker.pickerView) {
    return [self.detailedFood.servings count];
  }
  else {
    return 98;
  }
  
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  if (pickerView == unitPicker.pickerView) {
    FSServing *serving = [self.detailedFood.servings objectAtIndex:row];
    return serving.servingDescription;
  }
  else {
    NSString *numberAsString = [NSString stringWithFormat:@"%d", row+1];
    return numberAsString;
  }
  
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  if (pickerView == unitPicker.pickerView) {
    FSServing *tappedServing = [self.detailedFood.servings objectAtIndex:row];
    self.selectedServing = tappedServing;
    self.customFood.selectedServingIndex = row;
    [self.nutInfoTable reloadData];
  }
  else {
    self.customFood.servingSize = row+1;
    [self.nutInfoTable reloadData];
  }
  
}


//------------------Table Delegate Methods---------------------//

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if (section == 0)
    return 4;
  else
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  // Return the number of sections.
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"CellIdentifier";
  
  // Dequeue or create a cell of the appropriate type.
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  NSString *nutrientFormat = @"g";
  NSString *calorieFormat = @"cals";
  
  // Configure the cell.
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *label = @"Calories: ";
     
      CGFloat amountNumber = [self.selectedServing caloriesValue] * self.customFood.servingSize;
      NSString *amount = [NSString stringWithFormat:@"%.01f", amountNumber];
      
      NSString *completeNutrientInfo = [[label stringByAppendingString:amount] stringByAppendingString:calorieFormat];
      cell.textLabel.text = completeNutrientInfo;
    }
    if (indexPath.row == 1) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *label = @"Fat: ";
      
      CGFloat amountNumber = [self.selectedServing fatValue] * self.customFood.servingSize;
      NSString *amount = [NSString stringWithFormat:@"%.01f", amountNumber];
      
      NSString *completeNutrientInfo = [[label stringByAppendingString:amount] stringByAppendingString:nutrientFormat];
      cell.textLabel.text = completeNutrientInfo;
    }
    if (indexPath.row == 2) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *label = @"Carbohydrates: ";
      
      CGFloat amountNumber = [self.selectedServing carbohydrateValue] * self.customFood.servingSize;
      NSString *amount = [NSString stringWithFormat:@"%.01f", amountNumber];
      
      NSString *completeNutrientInfo = [[label stringByAppendingString:amount] stringByAppendingString:nutrientFormat];
      cell.textLabel.text = completeNutrientInfo;
    }
    if (indexPath.row == 3) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *label = @"Protein: ";
      
      CGFloat amountNumber = [self.selectedServing proteinValue] * self.customFood.servingSize;
      NSString *amount = [NSString stringWithFormat:@"%.01f", amountNumber];
      
      NSString *completeNutrientInfo = [[label stringByAppendingString:amount]  stringByAppendingString:nutrientFormat];
      cell.textLabel.text = completeNutrientInfo;
    }
  }
  else {
    
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Serving Size";
      cell.detailTextLabel.text = [self.selectedServing servingDescription];
      
      
    }
    if (indexPath.row == 1 ) {
      cell.textLabel.text = @"Number of servings";
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f", [self.customFood servingSize]];
    }
    
  }
  
  return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.section == 1) {
    
    if (indexPath.row == 0) {
      
      unitPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Serving Unit" delegate:self showCancelButton:YES origin:tableView];
      unitPicker.pickerView.tag = 1;
      [unitPicker showActionSheetPicker];
       
    }
    if (indexPath.row == 1) {
      servingSizePicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Serving Size" delegate:self showCancelButton:YES origin:tableView];
      servingSizePicker.pickerView.tag = 2;
      [servingSizePicker showActionSheetPicker];
    }
    
  }
  
}

-(void) dismissActionSheet:(id)sender {
  UIActionSheet *actionSheet =  (UIActionSheet *)[(UIView *)sender superview];
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
