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
#import "MyMeal.h"

@interface DetailFoodBeforeSelectionViewController ()

@end

ActionSheetCustomPicker *unitPicker;
ActionSheetCustomPicker *servingSizePicker;

@implementation DetailFoodBeforeSelectionViewController
@synthesize managedObjectContext;
@synthesize mealsToday;
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
  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addFoodToMeal:(id)sender {

  MyFood *newFood = (MyFood*)[NSEntityDescription insertNewObjectForEntityForName:@"MyFood" inManagedObjectContext:managedObjectContext];
  [newFood setBrandName:[self.detailedFood brandName]];
  [newFood setFoodDescription:[self.detailedFood foodDescription]];
  [newFood setIdentifier:[NSNumber numberWithInteger:[self.detailedFood identifier]]];
  [newFood setName:[self.detailedFood name]];
  [newFood setType:[self.detailedFood type]];
  [newFood setUrl:[self.detailedFood url]];
  [newFood setServingSize:[NSNumber numberWithFloat:[self servingSize]]];
  [newFood setSelectedServing:[NSNumber numberWithInteger:[self.selectedServing servingIdValue]]];
  
  
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
  
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (name == %@)", todayStart, todayEnd, self.mealName];

  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"MyMeal" inManagedObjectContext:managedObjectContext]];
  [request setPredicate:predicate];
  
  NSError *error = nil;
  NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
  
  NSArray *thisMeal = results;
  MyMeal *theMeal = [thisMeal objectAtIndex:0];
  
  [newFood setDate:date];
  [newFood setToMyMeal:theMeal];
  
  
  for (int i = 0; i < [[self.detailedFood servings] count]; i++) {
    
    MyServing *newServing = (MyServing*)[NSEntityDescription insertNewObjectForEntityForName:@"MyServing" inManagedObjectContext:managedObjectContext];
    FSServing *thisServing = [[self.detailedFood servings] objectAtIndex:i];
    [newServing setServingDescription:[thisServing servingDescription]];
    [newServing setServingUrl:[thisServing servingUrl]];
    [newServing setMetricServingUnit:[thisServing metricServingUnit]];
    [newServing setMeasurementDescription:[thisServing measurementDescription]];
    [newServing setNumberOfUnits:[NSNumber numberWithFloat:[thisServing numberOfUnitsValue]]];
    [newServing setMetricServingAmount:[NSNumber numberWithFloat:[thisServing metricServingAmountValue]]];
    [newServing setServingId:[NSNumber numberWithFloat:[thisServing servingIdValue]]];
    [newServing setCalories:[NSNumber numberWithFloat:[thisServing caloriesValue]]];
    [newServing setCarbohydrates:[NSNumber numberWithFloat:[thisServing carbohydrateValue]]];
    [newServing setProtein:[NSNumber numberWithFloat:[thisServing proteinValue]]];
    [newServing setFat:[NSNumber numberWithFloat:[thisServing fatValue]]];
    [newServing setSaturatedFat:[NSNumber numberWithFloat:[thisServing saturatedFatValue]]];
    [newServing setPolyunsaturatedFat:[NSNumber numberWithFloat:[thisServing polyunsaturatedFatValue]]];
    [newServing setMonounsaturatedFat:[NSNumber numberWithFloat:[thisServing monounsaturatedFatValue]]];
    [newServing setTransFat:[NSNumber numberWithFloat:[thisServing transFatValue]]];
    [newServing setCholesterol:[NSNumber numberWithFloat:[thisServing cholesterolValue]]];
    [newServing setSodium:[NSNumber numberWithFloat:[thisServing sodiumValue]]];
    [newServing setPotassium:[NSNumber numberWithFloat:[thisServing potassiumValue]]];
    [newServing setFiber:[NSNumber numberWithFloat:[thisServing fiberValue]]];
    [newServing setSugar:[NSNumber numberWithFloat:[thisServing sugarValue]]];
    [newServing setVitaminC:[NSNumber numberWithFloat:[thisServing vitaminCValue]]];
    [newServing setVitaminA:[NSNumber numberWithFloat:[thisServing vitaminAValue]]];
    [newServing setCalcium:[NSNumber numberWithFloat:[thisServing calciumValue]]];
    [newServing setIron:[NSNumber numberWithFloat:[thisServing ironValue]]];
    [newServing setToMyFood:newFood];
    
  }
  
  

  if (![managedObjectContext save:&error]) {
    NSLog(@"There was an error saving the data");
  }
  
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
    self.servingIndex = row;
    [self.nutInfoTable reloadData];
  }
  else {
    self.servingSize = row+1;
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
     
      CGFloat amountNumber = [self.selectedServing caloriesValue] * self.servingSize;
      NSString *amount = [NSString stringWithFormat:@"%.01f", amountNumber];
      
      NSString *completeNutrientInfo = [[label stringByAppendingString:amount] stringByAppendingString:calorieFormat];
      cell.textLabel.text = completeNutrientInfo;
    }
    if (indexPath.row == 1) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *label = @"Fat: ";
      
      CGFloat amountNumber = [self.selectedServing fatValue] * self.servingSize;
      NSString *amount = [NSString stringWithFormat:@"%.01f", amountNumber];
      
      NSString *completeNutrientInfo = [[label stringByAppendingString:amount] stringByAppendingString:nutrientFormat];
      cell.textLabel.text = completeNutrientInfo;
    }
    if (indexPath.row == 2) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *label = @"Carbohydrates: ";
      
      CGFloat amountNumber = [self.selectedServing carbohydrateValue] * self.servingSize;
      NSString *amount = [NSString stringWithFormat:@"%.01f", amountNumber];
      
      NSString *completeNutrientInfo = [[label stringByAppendingString:amount] stringByAppendingString:nutrientFormat];
      cell.textLabel.text = completeNutrientInfo;
    }
    if (indexPath.row == 3) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSString *label = @"Protein: ";
      
      CGFloat amountNumber = [self.selectedServing proteinValue] * self.servingSize;
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
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f", [self servingSize]];
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
