//
//  RecentlyAddedBeforeSelectionViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-21.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "RecentlyAddedBeforeSelectionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MealController.h"

@interface RecentlyAddedBeforeSelectionViewController ()

@end

@implementation RecentlyAddedBeforeSelectionViewController

@synthesize foodToBeAdded;
@synthesize mealName;

CGFloat servingSize = 1;
NSInteger servingIndex = 0;
ActionSheetCustomPicker *unitPicker;
ActionSheetCustomPicker *servingSizePicker;
NSMutableArray *allServings;
MyServing *currentServing;
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
	// Do any additional setup after loading the view.
  controller = [MealController sharedInstance];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  
  NSArray *tempServings = [[foodToBeAdded toMyServing] allObjects];
  NSMutableArray *servings = [NSMutableArray arrayWithArray:[tempServings sortedArrayUsingDescriptors:sortDescriptors]];
  allServings = servings;
  currentServing = [servings objectAtIndex:0];
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
      cell.textLabel.text = [foodToBeAdded name];
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
      CGFloat calsFloatValue = [[currentServing calories] floatValue] * servingSize;
      NSString *calsInfoString = [NSString stringWithFormat:@"%.01f cals", calsFloatValue];
      calsAmountLabel.font = [UIFont systemFontOfSize:10];
      [calsAmountLabel setText:calsInfoString];
      // carbs
      UILabel *carbsAmountLabel = (UILabel *)[cell.contentView viewWithTag:2];
      CGFloat carbsFloatValue = [[currentServing carbohydrates] floatValue] * servingSize;
      NSString *carbsInfoString = [NSString stringWithFormat:@"%.01f g", carbsFloatValue];
      carbsAmountLabel.font = [UIFont systemFontOfSize:10];
      [carbsAmountLabel setText:carbsInfoString];
      // protein
      UILabel *proteinAmountLabel = (UILabel *)[cell.contentView viewWithTag:3];
      CGFloat proteinFloatValue = [[currentServing protein] floatValue] * servingSize;
      NSString *proteinInfoString = [NSString stringWithFormat:@"%.01f g", proteinFloatValue];
      proteinAmountLabel.font = [UIFont systemFontOfSize:10];
      [proteinAmountLabel setText:proteinInfoString];
      // fat
      UILabel *fatAmountLabel = (UILabel *)[cell.contentView viewWithTag:4];
      CGFloat fatFloatValue = [[currentServing fat] floatValue] * servingSize;
      NSString *fatInfoString = [NSString stringWithFormat:@"%.01f g", fatFloatValue];
      fatAmountLabel.font = [UIFont systemFontOfSize:10];
      [fatAmountLabel setText:fatInfoString];
      // saturated fat
      UILabel *satFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:5];
      CGFloat satFatFloatValue = [[currentServing saturatedFat] floatValue] * servingSize;
      NSString *satFatInfoString = [NSString stringWithFormat:@"%.01f g", satFatFloatValue];
      satFatAmountLabel.font = [UIFont systemFontOfSize:10];
      [satFatAmountLabel setText:satFatInfoString];
      // polyunsaturated fat
      UILabel *polyUnsatFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:6];
      CGFloat polyUnsatFatFloatValue = [[currentServing polyunsaturatedFat] floatValue] * servingSize;
      NSString *polyUnsatFatInfoString = [NSString stringWithFormat:@"%.01f g", polyUnsatFatFloatValue];
      polyUnsatFatAmountLabel.font = [UIFont systemFontOfSize:10];
      [polyUnsatFatAmountLabel setText:polyUnsatFatInfoString];
      // monounsaturated fat
      UILabel *monoUnsatFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:7];
      CGFloat monoUnsatFatFloatValue = [[currentServing monounsaturatedFat] floatValue] * servingSize;
      NSString *monoUnsatFatInfoString = [NSString stringWithFormat:@"%.01f g", monoUnsatFatFloatValue];
      monoUnsatFatAmountLabel.font = [UIFont systemFontOfSize:10];
      [monoUnsatFatAmountLabel setText:monoUnsatFatInfoString];
      // transfat
      UILabel *transFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:8];
      CGFloat transFatFloatValue = [[currentServing transFat] floatValue] * servingSize;
      NSString *transFatInfoString = [NSString stringWithFormat:@"%.01f g", transFatFloatValue];
      transFatAmountLabel.font = [UIFont systemFontOfSize:10];
      [transFatAmountLabel setText:transFatInfoString];
      // cholesterol
      UILabel *cholesterolAmountLabel = (UILabel *)[cell.contentView viewWithTag:9];
      CGFloat cholesterolFloatValue = [[currentServing cholesterol] floatValue] * servingSize;
      NSString *cholesterolInfoString = [NSString stringWithFormat:@"%.01f mg", cholesterolFloatValue];
      cholesterolAmountLabel.font = [UIFont systemFontOfSize:10];
      [cholesterolAmountLabel setText:cholesterolInfoString];
      // sodium
      UILabel *sodiumAmountLabel = (UILabel *)[cell.contentView viewWithTag:10];
      CGFloat sodiumFloatValue = [[currentServing sodium] floatValue] * servingSize;
      NSString *sodiumInfoString = [NSString stringWithFormat:@"%.01f mg", sodiumFloatValue];
      sodiumAmountLabel.font = [UIFont systemFontOfSize:10];
      [sodiumAmountLabel setText:sodiumInfoString];
      // potassium
      UILabel *potassiumAmountLabel = (UILabel *)[cell.contentView viewWithTag:11];
      CGFloat potassiumFloatValue = [[currentServing potassium] floatValue] * servingSize;
      NSString *potassiumInfoString = [NSString stringWithFormat:@"%.01f mg", potassiumFloatValue];
      potassiumAmountLabel.font = [UIFont systemFontOfSize:10];
      [potassiumAmountLabel setText:potassiumInfoString];
      // fiber
      UILabel *fiberAmountLabel = (UILabel *)[cell.contentView viewWithTag:12];
      CGFloat fiberFloatValue = [[currentServing fiber] floatValue] * servingSize;
      NSString *fiberInfoString = [NSString stringWithFormat:@"%.01f g", fiberFloatValue];
      fiberAmountLabel.font = [UIFont systemFontOfSize:10];
      [fiberAmountLabel setText:fiberInfoString];
      // sugar
      UILabel *sugarAmountLabel = (UILabel *)[cell.contentView viewWithTag:13];
      CGFloat sugarFloatValue = [[currentServing sugar] floatValue] * servingSize;
      NSString *sugarInfoString = [NSString stringWithFormat:@"%.01f g", sugarFloatValue];
      sugarAmountLabel.font = [UIFont systemFontOfSize:10];
      [sugarAmountLabel setText:sugarInfoString];
      // vitamin C
      UILabel *vitaminCAmountLabel = (UILabel *)[cell.contentView viewWithTag:14];
      CGFloat vitaminCFloatValue = [[currentServing vitaminC] floatValue] * servingSize;
      NSString *vitaminCInfoString = [NSString stringWithFormat:@"%.01f%%", vitaminCFloatValue];
      vitaminCAmountLabel.font = [UIFont systemFontOfSize:10];
      [vitaminCAmountLabel setText:vitaminCInfoString];
      // vitamin A
      UILabel *vitaminAAmountLabel = (UILabel *)[cell.contentView viewWithTag:15];
      CGFloat vitaminAFloatValue = [[currentServing vitaminA] floatValue] * servingSize;
      NSString *vitaminAInfoString = [NSString stringWithFormat:@"%.01f%%", vitaminAFloatValue];
      vitaminAAmountLabel.font = [UIFont systemFontOfSize:10];
      [vitaminAAmountLabel setText:vitaminAInfoString];
      // calcium
      UILabel *calciumAmountLabel = (UILabel *)[cell.contentView viewWithTag:16];
      CGFloat calciumFloatValue = [[currentServing calcium] floatValue] * servingSize;
      NSString *calciumInfoString = [NSString stringWithFormat:@"%.01f%%", calciumFloatValue];
      calciumAmountLabel.font = [UIFont systemFontOfSize:10];
      [calciumAmountLabel setText:calciumInfoString];
      // iron
      UILabel *ironAmountLabel = (UILabel *)[cell.contentView viewWithTag:17];
      CGFloat ironFloatValue = [[currentServing iron] floatValue] * servingSize;
      NSString *ironInfoString = [NSString stringWithFormat:@"%.01f%%", ironFloatValue];
      ironAmountLabel.font = [UIFont systemFontOfSize:10];
      [ironAmountLabel setText:ironInfoString];
      
      UILabel *servingDescription = (UILabel*)[cell.contentView viewWithTag:25];
      NSString *servingSizeString = [NSString stringWithFormat:@"%.00f", servingSize];
      NSString *currentServingString =  [currentServing servingDescription];
      NSString *servingDescriptionString = [servingSizeString stringByAppendingFormat:@" x %@", currentServingString];
      servingDescription.font = [UIFont systemFontOfSize:10];
      servingDescription.text = servingDescriptionString;
      
      
      cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"golden-parchment-paper-texture.png"]];
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
      cell.detailTextLabel.text = [currentServing servingDescription];
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
    return [[foodToBeAdded toMyServing] count];
  }
  else {
    return 98;
  }
  
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  if (pickerView == unitPicker.pickerView) {
    //NSArray *myArray = [[detailedFood toMyServing] allObjects];
    MyServing *serving = [allServings objectAtIndex:row];
    return [serving servingDescription];
  }
  else {
    NSString *numberAsString = [NSString stringWithFormat:@"%d", row+1];
    return numberAsString;
  }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if (pickerView == unitPicker.pickerView) {
    currentServing = [allServings objectAtIndex:row];
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
  
  MyFood *newFood = (MyFood*)[NSEntityDescription insertNewObjectForEntityForName:@"MyFood" inManagedObjectContext:[controller managedObjectContext]];
  [newFood setBrandName:[foodToBeAdded brandName]];
  // [newFood setFoodDescription:[self.detailedFood foodDescription]];
  [newFood setFoodDescription:[foodToBeAdded foodDescription]];
  [newFood setIdentifier:[foodToBeAdded  identifier]];
  [newFood setName:[foodToBeAdded name]];
  [newFood setType:[foodToBeAdded type]];
  [newFood setUrl:[foodToBeAdded url]];
  [newFood setServingSize:[NSNumber numberWithFloat:servingSize]];
  [newFood setSelectedServing:[currentServing servingId]];
  [newFood setServingIndex:[NSNumber numberWithInteger:servingIndex]];
  
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
  
  
  for (int i = 0; i < [allServings count]; i++) {
    
    MyServing *newServing = (MyServing*)[NSEntityDescription insertNewObjectForEntityForName:@"MyServing" inManagedObjectContext:[controller managedObjectContext]];
    MyServing *thisServing = [allServings objectAtIndex:i];
    [newServing setServingDescription:[thisServing servingDescription]];
    [newServing setServingUrl:[thisServing servingUrl]];
    [newServing setMetricServingUnit:[thisServing metricServingUnit]];
    [newServing setMeasurementDescription:[thisServing measurementDescription]];
    [newServing setNumberOfUnits:[thisServing numberOfUnits]];
    [newServing setMetricServingAmount:[thisServing metricServingAmount]];
    [newServing setServingId:[thisServing servingId]];
    [newServing setCalories:[thisServing calories]];
    [newServing setCarbohydrates:[thisServing carbohydrates]];
    [newServing setProtein:[thisServing protein]];
    [newServing setFat:[thisServing fat]];
    [newServing setSaturatedFat:[thisServing saturatedFat]];
    [newServing setPolyunsaturatedFat:[thisServing polyunsaturatedFat]];
    [newServing setMonounsaturatedFat:[thisServing monounsaturatedFat]];
    [newServing setTransFat:[thisServing transFat]];
    [newServing setCholesterol:[thisServing cholesterol]];
    [newServing setSodium:[thisServing sodium]];
    [newServing setPotassium:[thisServing potassium]];
    [newServing setFiber:[thisServing fiber]];
    [newServing setSugar:[thisServing sugar]];
    [newServing setVitaminC:[thisServing vitaminC]];
    [newServing setVitaminA:[thisServing vitaminA]];
    [newServing setCalcium:[thisServing calcium]];
    [newServing setIron:[thisServing iron]];
    [newServing setDate:[NSDate date]];
    [newServing setToMyFood:newFood];
    
    if (![[controller managedObjectContext] save:&error]) {
      NSLog(@"There was an error saving the data");
    }
    
  }
  
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

  
}

@end
