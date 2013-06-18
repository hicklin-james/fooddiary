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
  
  FSServing *serving = [self.detailedFood.servings objectAtIndex:0];
  self.selectedServing = serving;
  FDFood * currentFood = [[FDFood alloc] initWithIndex:0 theFood:self.detailedFood mealName:self.mealName];
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
  
  return [self.detailedFood.servings count];
  
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  FSServing *serving = [self.detailedFood.servings objectAtIndex:row];
  return serving.servingDescription;
  
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  FSServing *tappedServing = [self.detailedFood.servings objectAtIndex:row];
  self.selectedServing = tappedServing;
  self.customFood.selectedServingIndex = row;
  [self.nutInfoTable reloadData];
  
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
      NSString *amount = [NSString stringWithFormat:@"%@", [self.selectedServing calories]];
      NSString *completeNutrientInfo = [[label stringByAppendingString:amount] stringByAppendingString:calorieFormat];
      cell.textLabel.text = completeNutrientInfo;
    }
    if (indexPath.row == 1) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *label = @"Fat: ";
      NSString *amount = [NSString stringWithFormat:@"%@", [self.selectedServing fat]];
      NSString *completeNutrientInfo = [[label stringByAppendingString:amount] stringByAppendingString:nutrientFormat];
      cell.textLabel.text = completeNutrientInfo;
    }
    if (indexPath.row == 2) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *label = @"Carbohydrates: ";
      NSString *amount = [NSString stringWithFormat:@"%@", [self.selectedServing carbohydrate]];
      NSString *completeNutrientInfo = [[label stringByAppendingString:amount] stringByAppendingString:nutrientFormat];
      cell.textLabel.text = completeNutrientInfo;
    }
    if (indexPath.row == 3) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *label = @"Protein: ";
      NSString *amount = [NSString stringWithFormat:@"%@", [self.selectedServing protein]];
      NSString *completeNutrientInfo = [[label stringByAppendingString:amount]  stringByAppendingString:nutrientFormat];
      cell.textLabel.text = completeNutrientInfo;
    }
  }
  else {
    
    if (indexPath.row == 0) {
      self.customTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
      self.customTextField.adjustsFontSizeToFitWidth = YES;
      self.customTextField.textColor = [UIColor blackColor];
      self.customTextField.backgroundColor = [UIColor whiteColor];
      self.customTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
      self.customTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
      self.customTextField.textAlignment = NSTextAlignmentLeft;
      self.customTextField.tag = 0;
      [self.customTextField setDelegate:self];
      
      
      //customTextField.text = [self.selectedServing servingDescription];
      [self.customTextField setEnabled:YES];
      
      self.customTextField.inputView = self.unitPicker;

      
      cell.textLabel.text = @"Serving Size";
      cell.detailTextLabel.text = [self.selectedServing servingDescription];
      
      
    }
    if (indexPath.row == 1 ) {
      cell.textLabel.text = @"Number of servings";
    }
    
  }
  
  return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.section == 1) {
    
    if (indexPath.row == 0) {
       
    }
    
    {
      
      UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:nil
                                    cancelButtonTitle:@"Cancel Button"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:nil];

      CGRect pickerFrame = CGRectMake(0,40,0,0);
      UIPickerView *testPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
      testPicker.showsSelectionIndicator = YES;
      testPicker.dataSource = self;
      testPicker.delegate = self;
      
      UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
      closeButton.momentary = YES;
      closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
      closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
      closeButton.tintColor = [UIColor blueColor];
      [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
      [actionSheet addSubview:closeButton];
      
      actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
      [actionSheet addSubview:testPicker];
      
      [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
      [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    }
    
  }
  
}

-(void) dismissActionSheet:(id)sender {
  UIActionSheet *actionSheet =  (UIActionSheet *)[(UIView *)sender superview];
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
