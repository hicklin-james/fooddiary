//
//  CustomFoodBeforeSelectionViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-23.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "CustomFoodBeforeSelectionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MealController.h"
#import "MyFood.h"
#import "MyServing.h"
#import "MyMeal.h"
#import "AddFoodViewController.h"

@interface CustomFoodBeforeSelectionViewController ()

@end

@implementation CustomFoodBeforeSelectionViewController

@synthesize detailedFood;
@synthesize mealName;
@synthesize servingIndex;
@synthesize servingSize;

//CGFloat servingSize = 1;
//NSInteger servingIndex = 0;
ActionSheetCustomPicker *unitPicker;
ActionSheetCustomPicker *servingSizePicker;
MealController *controller;

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
  servingIndex = 0;
  servingSize = 1;
  
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if (section == 0)
    return 3;
  else
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  // Return the number of sections.
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *nutrIdentifier = @"nutritionalInfo";
  static NSString *standardIdentifier = @"cellIdentifier";
  UITableViewCell *cell;
  // Dequeue or create a cell of the appropriate type.
  if (indexPath.section == 1 && indexPath.row != 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:nutrIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nutrIdentifier];
      cell.accessoryType = UITableViewCellAccessoryNone;
    }
  }
  else {
    cell = [tableView dequeueReusableCellWithIdentifier:standardIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:standardIdentifier];
      cell.accessoryType = UITableViewCellAccessoryNone;
    }
  }
  
  //NSString *nutrientFormat = @"g";
  //NSString *calorieFormat = @"cals";
  
  // Configure the cell.
  if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
      cell.textLabel.text = [detailedFood name];
      cell.textLabel.textColor = [UIColor whiteColor];
      UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
      cell.backgroundColor = color;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      return cell;
    }
    else {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      // calories
      UILabel *calsAmountLabel = (UILabel *)[cell.contentView viewWithTag:1];
      CGFloat calsFloatValue = [[detailedFood calories] floatValue] * servingSize;
      NSString *calsInfoString = [NSString stringWithFormat:@"%.01f cals", calsFloatValue];
      calsAmountLabel.font = [UIFont systemFontOfSize:10];
      [calsAmountLabel setText:calsInfoString];
      // carbs
      UILabel *carbsAmountLabel = (UILabel *)[cell.contentView viewWithTag:2];
      carbsAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood carbohydrates] != nil) {
        CGFloat carbsFloatValue = [[detailedFood carbohydrates] floatValue] * servingSize;
        NSString *carbsInfoString = [NSString stringWithFormat:@"%.01f g", carbsFloatValue];
        [carbsAmountLabel setText:carbsInfoString];
      }
      else {
        [carbsAmountLabel setText:@"N/A"];
      }
      // protein
      UILabel *proteinAmountLabel = (UILabel *)[cell.contentView viewWithTag:3];
      proteinAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood protein] != nil) {
        CGFloat proteinFloatValue = [[detailedFood protein] floatValue] * servingSize;
        NSString *proteinInfoString = [NSString stringWithFormat:@"%.01f g", proteinFloatValue];
        [proteinAmountLabel setText:proteinInfoString];
      }
      else {
        [proteinAmountLabel setText:@"N/A"];
      }
      // fat
      UILabel *fatAmountLabel = (UILabel *)[cell.contentView viewWithTag:4];
      fatAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood fat] != nil) {
        CGFloat fatFloatValue = [[detailedFood fat] floatValue] * servingSize;
        NSString *fatInfoString = [NSString stringWithFormat:@"%.01f g", fatFloatValue];
        [fatAmountLabel setText:fatInfoString];
      }
      else {
        [fatAmountLabel setText:@"N/A"];
      }
      // saturated fat
      UILabel *satFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:5];
      satFatAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood saturatedFat] != nil) {
        CGFloat satFatFloatValue = [[detailedFood saturatedFat] floatValue] * servingSize;
        NSString *satFatInfoString = [NSString stringWithFormat:@"%.01f g", satFatFloatValue];
        [satFatAmountLabel setText:satFatInfoString];
      }
      else {
        [satFatAmountLabel setText:@"N/A"];
      }
      // polyunsaturated fat
      UILabel *polyUnsatFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:6];
      polyUnsatFatAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood polyunsaturatedFat] != nil) {
        CGFloat polyUnsatFatFloatValue = [[detailedFood polyunsaturatedFat] floatValue] * servingSize;
        NSString *polyUnsatFatInfoString = [NSString stringWithFormat:@"%.01f g", polyUnsatFatFloatValue];
        [polyUnsatFatAmountLabel setText:polyUnsatFatInfoString];
      }
      else {
        [polyUnsatFatAmountLabel setText:@"N/A"];
      }
      // monounsaturated fat
      UILabel *monoUnsatFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:7];
      monoUnsatFatAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood monounsaturatedFat] != nil) {
        CGFloat monoUnsatFatFloatValue = [[detailedFood monounsaturatedFat] floatValue] * servingSize;
        NSString *monoUnsatFatInfoString = [NSString stringWithFormat:@"%.01f g", monoUnsatFatFloatValue];
        [monoUnsatFatAmountLabel setText:monoUnsatFatInfoString];
      }
      else {
        [monoUnsatFatAmountLabel setText:@"N/A"];
      }
      // transfat
      UILabel *transFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:8];
      transFatAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood transFat] != nil) {
        CGFloat transFatFloatValue = [[detailedFood transFat] floatValue] * servingSize;
        NSString *transFatInfoString = [NSString stringWithFormat:@"%.01f g", transFatFloatValue];
        [transFatAmountLabel setText:transFatInfoString];
      }
      else {
        [transFatAmountLabel setText:@"N/A"];
      }
      // cholesterol
      UILabel *cholesterolAmountLabel = (UILabel *)[cell.contentView viewWithTag:9];
      cholesterolAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood cholesterol] != nil) {
        CGFloat cholesterolFloatValue = [[detailedFood cholesterol] floatValue] * servingSize;
        NSString *cholesterolInfoString = [NSString stringWithFormat:@"%.01f mg", cholesterolFloatValue];
        [cholesterolAmountLabel setText:cholesterolInfoString];
      }
      else {
        [cholesterolAmountLabel setText:@"N/A"];
      }
      // sodium
      UILabel *sodiumAmountLabel = (UILabel *)[cell.contentView viewWithTag:10];
      sodiumAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood sodium] != nil) {
        CGFloat sodiumFloatValue = [[detailedFood sodium] floatValue] * servingSize;
        NSString *sodiumInfoString = [NSString stringWithFormat:@"%.01f mg", sodiumFloatValue];
        [sodiumAmountLabel setText:sodiumInfoString];
      }
      else {
        [sodiumAmountLabel setText:@"N/A"];
      }
      // potassium
      UILabel *potassiumAmountLabel = (UILabel *)[cell.contentView viewWithTag:11];
      potassiumAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood potassium] != nil) {
        CGFloat potassiumFloatValue = [[detailedFood potassium] floatValue] * servingSize;
        NSString *potassiumInfoString = [NSString stringWithFormat:@"%.01f mg", potassiumFloatValue];
        [potassiumAmountLabel setText:potassiumInfoString];
      }
      else {
        [potassiumAmountLabel setText:@"N/A"];
      }
      // fiber
      UILabel *fiberAmountLabel = (UILabel *)[cell.contentView viewWithTag:12];
      fiberAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood fiber] != nil) {
        CGFloat fiberFloatValue = [[detailedFood fiber] floatValue] * servingSize;
        NSString *fiberInfoString = [NSString stringWithFormat:@"%.01f g", fiberFloatValue];
        [fiberAmountLabel setText:fiberInfoString];
      }
      else {
        [fiberAmountLabel setText:@"N/A"];
      }
      // sugar
      UILabel *sugarAmountLabel = (UILabel *)[cell.contentView viewWithTag:13];
      sugarAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood sugar] != nil) {
        CGFloat sugarFloatValue = [[detailedFood sugar] floatValue] * servingSize;
        NSString *sugarInfoString = [NSString stringWithFormat:@"%.01f g", sugarFloatValue];
        [sugarAmountLabel setText:sugarInfoString];
      }
      else {
        [sugarAmountLabel setText:@"N/A"];
      }
      // vitamin C
      UILabel *vitaminCAmountLabel = (UILabel *)[cell.contentView viewWithTag:14];
      vitaminCAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood vitaminC] != nil) {
        CGFloat vitaminCFloatValue = [[detailedFood vitaminC] floatValue] * servingSize;
        NSString *vitaminCInfoString = [NSString stringWithFormat:@"%.01f%%", vitaminCFloatValue];
        [vitaminCAmountLabel setText:vitaminCInfoString];
      }
      else {
        [vitaminCAmountLabel setText:@"N/A"];
      }
      // vitamin A
      UILabel *vitaminAAmountLabel = (UILabel *)[cell.contentView viewWithTag:15];
      vitaminAAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood vitaminA] != nil) {
        CGFloat vitaminAFloatValue = [[detailedFood vitaminA] floatValue] * servingSize;
        NSString *vitaminAInfoString = [NSString stringWithFormat:@"%.01f%%", vitaminAFloatValue];
        [vitaminAAmountLabel setText:vitaminAInfoString];
      }
      else {
        [vitaminAAmountLabel setText:@"N/A"];
      }
      // calcium
      UILabel *calciumAmountLabel = (UILabel *)[cell.contentView viewWithTag:16];
      calciumAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood calcium] != nil) {
        CGFloat calciumFloatValue = [[detailedFood calcium] floatValue] * servingSize;
        NSString *calciumInfoString = [NSString stringWithFormat:@"%.01f%%", calciumFloatValue];
        [calciumAmountLabel setText:calciumInfoString];
      }
      else {
        [calciumAmountLabel setText:@"N/A"];
      }
      // iron
      UILabel *ironAmountLabel = (UILabel *)[cell.contentView viewWithTag:17];
      ironAmountLabel.font = [UIFont systemFontOfSize:10];
      if ([detailedFood iron] != nil) {
        CGFloat ironFloatValue = [[detailedFood iron] floatValue] * servingSize;
        NSString *ironInfoString = [NSString stringWithFormat:@"%.01f%%", ironFloatValue];
        [ironAmountLabel setText:ironInfoString];
      }
      else {
        [ironAmountLabel setText:@"N/A"];
      }
      
      UILabel *servingDescription = (UILabel*)[cell.contentView viewWithTag:25];
      NSString *servingSizeString = [NSString stringWithFormat:@"%.00f", servingSize];
      NSString *currentServingString =  [detailedFood servingDescription];
      NSString *servingDescriptionString = [servingSizeString stringByAppendingFormat:@" x %@", currentServingString];
      servingDescription.font = [UIFont systemFontOfSize:10];
      servingDescription.text = servingDescriptionString;
      
      
     // cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"golden-parchment-paper-texture.png"]];
      cell.backgroundView.layer.cornerRadius = 5;
      cell.backgroundView.layer.masksToBounds = YES;
    }
  }
  
  else {
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
      cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
      cell.textLabel.text = @"Serving unit and size";
      cell.textLabel.textColor = [UIColor whiteColor];
      UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
      cell.backgroundColor = color;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      //return cell;
    }
    else if (indexPath.row == 1) {
      cell.textLabel.text = @"Serving Size";
      cell.detailTextLabel.text = [detailedFood servingDescription];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
    }
    else {
      cell.textLabel.text = @"Number of servings";
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%.00f", servingSize];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
  }
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    return 30;
  }
  if (indexPath.section == 0)
    return 44;
  else
    return 426;
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.section == 0) {
    
    if (indexPath.row == 1) {
      
      unitPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Serving Unit" delegate:self showCancelButton:NO origin:tableView];
      unitPicker.pickerView.tag = 1;
      [unitPicker showActionSheetPicker];
      
      UIPickerView *temp = (UIPickerView*)unitPicker.pickerView;
      [temp selectRow:servingIndex inComponent:0 animated:NO];
      
    }
    if (indexPath.row == 2) {
      servingSizePicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Serving Size" delegate:self showCancelButton:NO origin:tableView];
      servingSizePicker.pickerView.tag = 2;
      [servingSizePicker showActionSheetPicker];
      
      UIPickerView *temp = (UIPickerView*)servingSizePicker.pickerView;
      [temp selectRow:servingSize-1 inComponent:0 animated:NO];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
  
}

//------------------Picker Delegate Methods---------------------//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  
  if (pickerView == unitPicker.pickerView) {
    return 1;
  }
  else {
    return 98;
  }
  
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  if (pickerView == unitPicker.pickerView) {
    //NSArray *myArray = [[detailedFood toMyServing] allObjects];
    // MyServing *serving = [allServings objectAtIndex:row];
    return [detailedFood servingDescription];
  }
  else {
    NSString *numberAsString = [NSString stringWithFormat:@"%d", row+1];
    return numberAsString;
  }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if (pickerView == unitPicker.pickerView) {
    //currentServing = [allServings objectAtIndex:row];
    servingIndex = row;
    // reload table
    [self.tableView reloadData];
    
  }
  if (pickerView == servingSizePicker.pickerView) {
    
    servingSize = row+1;
    // reload table
    [self.tableView reloadData];
  }
}


- (IBAction)saveFood:(id)sender {
  
  MealController *controller = [MealController sharedInstance];
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyFood" inManagedObjectContext:[controller managedObjectContext]];
  MyFood *newFood = (MyFood*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
  
  CustomFood *foodToBeAdded = detailedFood;
  
  [newFood setBrandName:[foodToBeAdded brandName]];
  // [newFood setFoodDescription:[self.detailedFood foodDescription]];
  
  [newFood setName:[foodToBeAdded name]];
  [newFood setServingSize:[NSNumber numberWithFloat:servingSize]];
  [newFood setSelectedServing:[NSNumber numberWithInteger:0]];
  [newFood setServingIndex:[NSNumber numberWithInteger:servingIndex]];
  [newFood setFoodDescription: [NSString stringWithFormat:@"Per %@ - Calories: %.00fkcal", [foodToBeAdded servingDescription], [[foodToBeAdded calories] floatValue]]];
  
  
/*  NSCalendar *calendar = [NSCalendar currentCalendar];
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
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (name == %@)", todayStart, todayEnd, mealName];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"MyMeal" inManagedObjectContext:[controller managedObjectContext]]];
  [request setPredicate:predicate];
  
  NSError *error = nil;
  NSArray *results = [[controller managedObjectContext] executeFetchRequest:request error:&error];
  
  NSArray *thisMeal = results;
  MyMeal *theMeal = [thisMeal objectAtIndex:0];
  
  [newFood setDate:date];
  [newFood setToMyMeal:theMeal];
  */
//  NSDate *date = [controller dateToShow];
//  [newFood setDate:date];
  
  NSMutableArray *tempServings = [[NSMutableArray alloc] init];
  
  entity = [NSEntityDescription entityForName:@"MyServing" inManagedObjectContext:[controller managedObjectContext]];
  MyServing *newServing = (MyServing*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
  
  [newServing setServingDescription:[detailedFood servingDescription]];
  [newServing setServingId:[NSNumber numberWithInteger:0]];
  [newServing setCalories:[detailedFood calories]];
  

    [newServing setCarbohydrates:[detailedFood carbohydrates]];
    [newServing setProtein:[detailedFood protein]];
    [newServing setFat:[detailedFood fat]];
    [newServing setSaturatedFat:[detailedFood saturatedFat]];
    [newServing setPolyunsaturatedFat:[detailedFood polyunsaturatedFat]];
    [newServing setMonounsaturatedFat:[detailedFood monounsaturatedFat]];
    [newServing setTransFat:[detailedFood transFat]];
    [newServing setCholesterol:[detailedFood cholesterol]];
    [newServing setSodium:[detailedFood sodium]];
    [newServing setPotassium:[detailedFood potassium]];
    [newServing setFiber:[detailedFood fiber]];
    [newServing setSugar:[detailedFood sugar]];
    [newServing setVitaminC:[detailedFood vitaminC]];
    [newServing setVitaminA:[detailedFood vitaminA]];
    [newServing setCalcium:[detailedFood calcium]];
    [newServing setIron:[detailedFood iron]];
  
    [newServing setDate:[NSDate date]];
    [tempServings addObject:newServing];
  
//  if (![[controller managedObjectContext] save:&error]) {
//    NSLog(@"There was an error saving the data");
//  }
  AddFoodViewController *vc = [[self.navigationController viewControllers] objectAtIndex:1];
  [vc.temporaryFoods addObject:newFood];
  [vc.temporaryServings addObject:tempServings];
  [vc.searchDisplayController setActive:NO];
  [self.navigationController popViewControllerAnimated:YES];
//  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  
}
@end
