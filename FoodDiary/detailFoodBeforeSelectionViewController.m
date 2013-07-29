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
#import <QuartzCore/QuartzCore.h>
#import "MealController.h"
#import "AddFoodViewController.h"

@interface DetailFoodBeforeSelectionViewController ()

@end

ActionSheetCustomPicker *unitPicker;
ActionSheetCustomPicker *servingSizePicker;
MealController *controller;
//NSInteger numberOfLinesInHeader;
//NSManagedObjectContext *managedObjectContext;
//NSDate *dateOfFood;
//NSArray *mealsToday;

@implementation DetailFoodBeforeSelectionViewController
@synthesize detailedFood;
@synthesize foodDescription;
@synthesize nutritionInfoHeaderView;
@synthesize nutritionInfoHeaderTitle;


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
    
    controller = [MealController sharedInstance];
//    mealsToday = [controller mealsToday];
//    managedObjectContext = [controller managedObjectContext];
//    dateOfFood = [controller dateToShow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addFoodToMeal:(id)sender {
  
   NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyFood" inManagedObjectContext:[controller managedObjectContext]];
    MyFood *newFood = (MyFood*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    [newFood setBrandName:[self.detailedFood brandName]];
   // [newFood setFoodDescription:[self.detailedFood foodDescription]];
    [newFood setFoodDescription:foodDescription];
    [newFood setIdentifier:[NSNumber numberWithInteger:[self.detailedFood identifier]]];
    [newFood setName:[self.detailedFood name]];
    [newFood setType:[self.detailedFood type]];
    [newFood setUrl:[self.detailedFood url]];
    [newFood setServingSize:[NSNumber numberWithFloat:[self servingSize]]];
    [newFood setSelectedServing:[NSNumber numberWithInteger:[self.selectedServing servingIdValue]]];
    [newFood setServingIndex:[NSNumber numberWithInteger:self.servingIndex]];
    
//    NSDate *date = [controller dateToShow];
    
//    [newFood setDate:date];
    //[newFood setToMyMeal:theMeal];
    NSMutableArray *tempServings = [[NSMutableArray alloc] init];
  
    for (int i = 0; i < [[self.detailedFood servings] count]; i++) {
      
      NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyServing" inManagedObjectContext:[controller managedObjectContext]];
        MyServing *newServing = (MyServing*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
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
        [newServing setDate:[NSDate date]];
        //[newServing setToMyFood:newFood];
      [tempServings addObject:newServing];
        //if (![[controller managedObjectContext] save:&error]) {
        //    NSLog(@"There was an error saving the data");
        //}
        
    }
   AddFoodViewController *vc = [[self.navigationController viewControllers] objectAtIndex:1];
  [vc.temporaryFoods addObject:newFood];
  [vc.temporaryServings addObject:tempServings];
  [vc.searchDisplayController setActive:NO];
  [self.navigationController popViewControllerAnimated:YES];
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
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
        CGFloat calsFloatValue = [self.selectedServing caloriesValue] * self.servingSize;
        NSString *calsInfoString = [NSString stringWithFormat:@"%.01f cals", calsFloatValue];
        calsAmountLabel.font = [UIFont systemFontOfSize:10];
        [calsAmountLabel setText:calsInfoString];
        // carbs
        UILabel *carbsAmountLabel = (UILabel *)[cell.contentView viewWithTag:2];
        CGFloat carbsFloatValue = [self.selectedServing carbohydrateValue] * self.servingSize;
        NSString *carbsInfoString = [NSString stringWithFormat:@"%.01f g", carbsFloatValue];
        carbsAmountLabel.font = [UIFont systemFontOfSize:10];
        [carbsAmountLabel setText:carbsInfoString];
        // protein
        UILabel *proteinAmountLabel = (UILabel *)[cell.contentView viewWithTag:3];
        CGFloat proteinFloatValue = [self.selectedServing proteinValue] * self.servingSize;
        NSString *proteinInfoString = [NSString stringWithFormat:@"%.01f g", proteinFloatValue];
        proteinAmountLabel.font = [UIFont systemFontOfSize:10];
        [proteinAmountLabel setText:proteinInfoString];
        // fat
        UILabel *fatAmountLabel = (UILabel *)[cell.contentView viewWithTag:4];
        CGFloat fatFloatValue = [self.selectedServing fatValue] * self.servingSize;
        NSString *fatInfoString = [NSString stringWithFormat:@"%.01f g", fatFloatValue];
        fatAmountLabel.font = [UIFont systemFontOfSize:10];
        [fatAmountLabel setText:fatInfoString];
        // saturated fat
        UILabel *satFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:5];
        CGFloat satFatFloatValue = [self.selectedServing saturatedFatValue] * self.servingSize;
        NSString *satFatInfoString = [NSString stringWithFormat:@"%.01f g", satFatFloatValue];
        satFatAmountLabel.font = [UIFont systemFontOfSize:10];
        [satFatAmountLabel setText:satFatInfoString];
        // polyunsaturated fat
        UILabel *polyUnsatFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:6];
        CGFloat polyUnsatFatFloatValue = [self.selectedServing polyunsaturatedFatValue] * self.servingSize;
        NSString *polyUnsatFatInfoString = [NSString stringWithFormat:@"%.01f g", polyUnsatFatFloatValue];
        polyUnsatFatAmountLabel.font = [UIFont systemFontOfSize:10];
        [polyUnsatFatAmountLabel setText:polyUnsatFatInfoString];
        // monounsaturated fat
        UILabel *monoUnsatFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:7];
        CGFloat monoUnsatFatFloatValue = [self.selectedServing monounsaturatedFatValue] * self.servingSize;
        NSString *monoUnsatFatInfoString = [NSString stringWithFormat:@"%.01f g", monoUnsatFatFloatValue];
        monoUnsatFatAmountLabel.font = [UIFont systemFontOfSize:10];
        [monoUnsatFatAmountLabel setText:monoUnsatFatInfoString];
        // transfat
        UILabel *transFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:8];
        CGFloat transFatFloatValue = [self.selectedServing transFatValue] * self.servingSize;
        NSString *transFatInfoString = [NSString stringWithFormat:@"%.01f g", transFatFloatValue];
        transFatAmountLabel.font = [UIFont systemFontOfSize:10];
        [transFatAmountLabel setText:transFatInfoString];
        // cholesterol
        UILabel *cholesterolAmountLabel = (UILabel *)[cell.contentView viewWithTag:9];
        CGFloat cholesterolFloatValue = [self.selectedServing cholesterolValue] * self.servingSize;
        NSString *cholesterolInfoString = [NSString stringWithFormat:@"%.01f mg", cholesterolFloatValue];
        cholesterolAmountLabel.font = [UIFont systemFontOfSize:10];
        [cholesterolAmountLabel setText:cholesterolInfoString];
        // sodium
        UILabel *sodiumAmountLabel = (UILabel *)[cell.contentView viewWithTag:10];
        CGFloat sodiumFloatValue = [self.selectedServing sodiumValue] * self.servingSize;
        NSString *sodiumInfoString = [NSString stringWithFormat:@"%.01f mg", sodiumFloatValue];
        sodiumAmountLabel.font = [UIFont systemFontOfSize:10];
        [sodiumAmountLabel setText:sodiumInfoString];
        // potassium
        UILabel *potassiumAmountLabel = (UILabel *)[cell.contentView viewWithTag:11];
        CGFloat potassiumFloatValue = [self.selectedServing potassiumValue] * self.servingSize;
        NSString *potassiumInfoString = [NSString stringWithFormat:@"%.01f mg", potassiumFloatValue];
        potassiumAmountLabel.font = [UIFont systemFontOfSize:10];
        [potassiumAmountLabel setText:potassiumInfoString];
        // fiber
        UILabel *fiberAmountLabel = (UILabel *)[cell.contentView viewWithTag:12];
        CGFloat fiberFloatValue = [self.selectedServing fiberValue] * self.servingSize;
        NSString *fiberInfoString = [NSString stringWithFormat:@"%.01f g", fiberFloatValue];
        fiberAmountLabel.font = [UIFont systemFontOfSize:10];
        [fiberAmountLabel setText:fiberInfoString];
        // sugar
        UILabel *sugarAmountLabel = (UILabel *)[cell.contentView viewWithTag:13];
        CGFloat sugarFloatValue = [self.selectedServing sugarValue] * self.servingSize;
        NSString *sugarInfoString = [NSString stringWithFormat:@"%.01f g", sugarFloatValue];
        sugarAmountLabel.font = [UIFont systemFontOfSize:10];
        [sugarAmountLabel setText:sugarInfoString];
        // vitamin C
        UILabel *vitaminCAmountLabel = (UILabel *)[cell.contentView viewWithTag:14];
        CGFloat vitaminCFloatValue = [self.selectedServing vitaminCValue] * self.servingSize;
        NSString *vitaminCInfoString = [NSString stringWithFormat:@"%.01f%%", vitaminCFloatValue];
        vitaminCAmountLabel.font = [UIFont systemFontOfSize:10];
        [vitaminCAmountLabel setText:vitaminCInfoString];
        // vitamin A
        UILabel *vitaminAAmountLabel = (UILabel *)[cell.contentView viewWithTag:15];
        CGFloat vitaminAFloatValue = [self.selectedServing vitaminAValue] * self.servingSize;
        NSString *vitaminAInfoString = [NSString stringWithFormat:@"%.01f%%", vitaminAFloatValue];
        vitaminAAmountLabel.font = [UIFont systemFontOfSize:10];
        [vitaminAAmountLabel setText:vitaminAInfoString];
        // calcium
        UILabel *calciumAmountLabel = (UILabel *)[cell.contentView viewWithTag:16];
        CGFloat calciumFloatValue = [self.selectedServing calciumValue] * self.servingSize;
        NSString *calciumInfoString = [NSString stringWithFormat:@"%.01f%%", calciumFloatValue];
        calciumAmountLabel.font = [UIFont systemFontOfSize:10];
        [calciumAmountLabel setText:calciumInfoString];
        // iron
        UILabel *ironAmountLabel = (UILabel *)[cell.contentView viewWithTag:17];
        CGFloat ironFloatValue = [self.selectedServing ironValue] * self.servingSize;
        NSString *ironInfoString = [NSString stringWithFormat:@"%.01f%%", ironFloatValue];
        ironAmountLabel.font = [UIFont systemFontOfSize:10];
        [ironAmountLabel setText:ironInfoString];
        
        UILabel *servingDescription = (UILabel*)[cell.contentView viewWithTag:25];
        NSString *servingSizeString = [NSString stringWithFormat:@"%.00f", [self servingSize]];
        NSString *selectedServingString = [[self selectedServing] servingDescription];
        NSString *servingDescriptionString = [servingSizeString stringByAppendingFormat:@" x %@", selectedServingString];
        servingDescription.font = [UIFont systemFontOfSize:10];
        servingDescription.text = servingDescriptionString;
        
       // cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"golden-parchment-paper-texture.png"]];
        cell.backgroundView.layer.cornerRadius = 5;
        cell.backgroundView.layer.masksToBounds = YES;
      }
    }
    
    else {
      if (indexPath.row == 0) {
        
          cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
          cell.textLabel.text = @"Serving unit and size";
          cell.textLabel.textColor = [UIColor whiteColor];
          UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
          cell.backgroundColor = color;
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        }
      
        else if (indexPath.row == 1) {
          
            cell.textLabel.text = @"Serving Size";
            cell.detailTextLabel.text = [self.selectedServing servingDescription];
            
            
        }
        else {
          
            cell.textLabel.text = @"Number of servings";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f", [self servingSize]];
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
            [temp selectRow:self.servingIndex inComponent:0 animated:NO];
            
        }
        if (indexPath.row == 2) {
            servingSizePicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Serving Size" delegate:self showCancelButton:NO origin:tableView];
            servingSizePicker.pickerView.tag = 2;
            [servingSizePicker showActionSheetPicker];
            
            UIPickerView *temp = (UIPickerView*)servingSizePicker.pickerView;
            [temp selectRow:self.servingSize-1 inComponent:0 animated:NO];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    }
    
}

-(void) dismissActionSheet:(id)sender {
    UIActionSheet *actionSheet =  (UIActionSheet *)[(UIView *)sender superview];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
