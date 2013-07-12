//
//  DetailedFoodViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "DetailedFoodViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FSServing.h"

@interface DetailedFoodViewController ()

@end

@implementation DetailedFoodViewController

@synthesize managedObjectContext;
@synthesize currentServing;
@synthesize detailedFood;
@synthesize allServings;

ActionSheetCustomPicker *unitPicker;
ActionSheetCustomPicker *servingSizePicker;

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
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    NSArray *tempServings = [[detailedFood toMyServing] allObjects];
    NSMutableArray *servings = [NSMutableArray arrayWithArray:[tempServings sortedArrayUsingDescriptors:sortDescriptors]];
    allServings = servings;

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
        CGFloat calsFloatValue = [[currentServing calories] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *calsInfoString = [NSString stringWithFormat:@"%.01f cals", calsFloatValue];
        calsAmountLabel.font = [UIFont systemFontOfSize:10];
        [calsAmountLabel setText:calsInfoString];
        // carbs
        UILabel *carbsAmountLabel = (UILabel *)[cell.contentView viewWithTag:2];
        CGFloat carbsFloatValue = [[currentServing carbohydrates] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *carbsInfoString = [NSString stringWithFormat:@"%.01f g", carbsFloatValue];
        carbsAmountLabel.font = [UIFont systemFontOfSize:10];
        [carbsAmountLabel setText:carbsInfoString];
        // protein
        UILabel *proteinAmountLabel = (UILabel *)[cell.contentView viewWithTag:3];
        CGFloat proteinFloatValue = [[currentServing protein] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *proteinInfoString = [NSString stringWithFormat:@"%.01f g", proteinFloatValue];
        proteinAmountLabel.font = [UIFont systemFontOfSize:10];
        [proteinAmountLabel setText:proteinInfoString];
        // fat
        UILabel *fatAmountLabel = (UILabel *)[cell.contentView viewWithTag:4];
        CGFloat fatFloatValue = [[currentServing fat] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *fatInfoString = [NSString stringWithFormat:@"%.01f g", fatFloatValue];
        fatAmountLabel.font = [UIFont systemFontOfSize:10];
        [fatAmountLabel setText:fatInfoString];
        // saturated fat
        UILabel *satFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:5];
        CGFloat satFatFloatValue = [[currentServing saturatedFat] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *satFatInfoString = [NSString stringWithFormat:@"%.01f g", satFatFloatValue];
        satFatAmountLabel.font = [UIFont systemFontOfSize:10];
        [satFatAmountLabel setText:satFatInfoString];
        // polyunsaturated fat
        UILabel *polyUnsatFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:6];
        CGFloat polyUnsatFatFloatValue = [[currentServing polyunsaturatedFat] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *polyUnsatFatInfoString = [NSString stringWithFormat:@"%.01f g", polyUnsatFatFloatValue];
        polyUnsatFatAmountLabel.font = [UIFont systemFontOfSize:10];
        [polyUnsatFatAmountLabel setText:polyUnsatFatInfoString];
        // monounsaturated fat
        UILabel *monoUnsatFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:7];
        CGFloat monoUnsatFatFloatValue = [[currentServing monounsaturatedFat] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *monoUnsatFatInfoString = [NSString stringWithFormat:@"%.01f g", monoUnsatFatFloatValue];
        monoUnsatFatAmountLabel.font = [UIFont systemFontOfSize:10];
        [monoUnsatFatAmountLabel setText:monoUnsatFatInfoString];
        // transfat
        UILabel *transFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:8];
        CGFloat transFatFloatValue = [[currentServing transFat] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *transFatInfoString = [NSString stringWithFormat:@"%.01f g", transFatFloatValue];
        transFatAmountLabel.font = [UIFont systemFontOfSize:10];
        [transFatAmountLabel setText:transFatInfoString];
        // cholesterol
        UILabel *cholesterolAmountLabel = (UILabel *)[cell.contentView viewWithTag:9];
        CGFloat cholesterolFloatValue = [[currentServing cholesterol] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *cholesterolInfoString = [NSString stringWithFormat:@"%.01f mg", cholesterolFloatValue];
        cholesterolAmountLabel.font = [UIFont systemFontOfSize:10];
        [cholesterolAmountLabel setText:cholesterolInfoString];
        // sodium
        UILabel *sodiumAmountLabel = (UILabel *)[cell.contentView viewWithTag:10];
        CGFloat sodiumFloatValue = [[currentServing sodium] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *sodiumInfoString = [NSString stringWithFormat:@"%.01f mg", sodiumFloatValue];
        sodiumAmountLabel.font = [UIFont systemFontOfSize:10];
        [sodiumAmountLabel setText:sodiumInfoString];
        // potassium
        UILabel *potassiumAmountLabel = (UILabel *)[cell.contentView viewWithTag:11];
        CGFloat potassiumFloatValue = [[currentServing potassium] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *potassiumInfoString = [NSString stringWithFormat:@"%.01f mg", potassiumFloatValue];
        potassiumAmountLabel.font = [UIFont systemFontOfSize:10];
        [potassiumAmountLabel setText:potassiumInfoString];
        // fiber
        UILabel *fiberAmountLabel = (UILabel *)[cell.contentView viewWithTag:12];
        CGFloat fiberFloatValue = [[currentServing fiber] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *fiberInfoString = [NSString stringWithFormat:@"%.01f g", fiberFloatValue];
        fiberAmountLabel.font = [UIFont systemFontOfSize:10];
        [fiberAmountLabel setText:fiberInfoString];
        // sugar
        UILabel *sugarAmountLabel = (UILabel *)[cell.contentView viewWithTag:13];
        CGFloat sugarFloatValue = [[currentServing sugar] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *sugarInfoString = [NSString stringWithFormat:@"%.01f g", sugarFloatValue];
        sugarAmountLabel.font = [UIFont systemFontOfSize:10];
        [sugarAmountLabel setText:sugarInfoString];
        // vitamin C
        UILabel *vitaminCAmountLabel = (UILabel *)[cell.contentView viewWithTag:14];
        CGFloat vitaminCFloatValue = [[currentServing vitaminC] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *vitaminCInfoString = [NSString stringWithFormat:@"%.01f%%", vitaminCFloatValue];
        vitaminCAmountLabel.font = [UIFont systemFontOfSize:10];
        [vitaminCAmountLabel setText:vitaminCInfoString];
        // vitamin A
        UILabel *vitaminAAmountLabel = (UILabel *)[cell.contentView viewWithTag:15];
        CGFloat vitaminAFloatValue = [[currentServing vitaminA] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *vitaminAInfoString = [NSString stringWithFormat:@"%.01f%%", vitaminAFloatValue];
        vitaminAAmountLabel.font = [UIFont systemFontOfSize:10];
        [vitaminAAmountLabel setText:vitaminAInfoString];
        // calcium
        UILabel *calciumAmountLabel = (UILabel *)[cell.contentView viewWithTag:16];
        CGFloat calciumFloatValue = [[currentServing calcium] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *calciumInfoString = [NSString stringWithFormat:@"%.01f%%", calciumFloatValue];
        calciumAmountLabel.font = [UIFont systemFontOfSize:10];
        [calciumAmountLabel setText:calciumInfoString];
        // iron
        UILabel *ironAmountLabel = (UILabel *)[cell.contentView viewWithTag:17];
        CGFloat ironFloatValue = [[currentServing iron] floatValue] * [[detailedFood servingSize] integerValue];
        NSString *ironInfoString = [NSString stringWithFormat:@"%.01f%%", ironFloatValue];
        ironAmountLabel.font = [UIFont systemFontOfSize:10];
        [ironAmountLabel setText:ironInfoString];
        
        UILabel *servingDescription = (UILabel*)[cell.contentView viewWithTag:25];
        NSString *servingSizeString = [NSString stringWithFormat:@"%d", [[detailedFood servingSize] integerValue]];
        NSString *currentServingString = [[self currentServing] servingDescription];
        NSString *servingDescriptionString = [servingSizeString stringByAppendingFormat:@" X %@", currentServingString];
        servingDescription.font = [UIFont systemFontOfSize:10];
        servingDescription.text = servingDescriptionString;
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"parchmentTexture.jpg"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
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
            return cell;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Serving Size";
            cell.detailTextLabel.text = [self.currentServing servingDescription];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        else {
            cell.textLabel.text = @"Number of servings";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [[detailedFood servingSize] integerValue]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    }
    
    return cell;
}


/*
 -(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
 if (section == 0) {
 return @"Unit Selection";
 }
 else {
 return [self.detailedFood name];
 }
 
 }
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 30;
    }
    if (indexPath.section == 0)
        return 44;
    else
        return 305;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            unitPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Serving Unit" delegate:self showCancelButton:YES origin:tableView];
            unitPicker.pickerView.tag = 1;
            [unitPicker showActionSheetPicker];
            
            UIPickerView *temp = (UIPickerView*)unitPicker.pickerView;
            [temp selectRow:[[detailedFood servingIndex] integerValue] inComponent:0 animated:NO];
            
        }
        if (indexPath.row == 2) {
            servingSizePicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Serving Size" delegate:self showCancelButton:YES origin:tableView];
            servingSizePicker.pickerView.tag = 2;
            [servingSizePicker showActionSheetPicker];
            
            UIPickerView *temp = (UIPickerView*)servingSizePicker.pickerView;
            [temp selectRow:[[detailedFood servingSize] integerValue]-1 inComponent:0 animated:NO];
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
        return [[detailedFood toMyServing] count];
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
        detailedFood.selectedServing = [[allServings objectAtIndex:row] servingId];
        currentServing = [allServings objectAtIndex:row];
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            [self showDetailedErrorInfo:error];
        }
    }
    if (pickerView == servingSizePicker.pickerView) {
        detailedFood.servingSize = [NSNumber numberWithInteger:row+1];
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            [self showDetailedErrorInfo:error];
        }
    }
    
    [self.tableView reloadData];
      /*
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(identifier == %d", [[detailedFood identifier] integerValue]];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"MyFood" inManagedObjectContext:managedObjectContext]];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
        
        MyFood *temp = [results objectAtIndex:0];
        
        temp.selectedServing = [[allServings objectAtIndex:row] servingId];
  
        if (![managedObjectContext save:&error]) {
            [self showDetailedErrorInfo:error];
        }
*/
        
    
    
    
    
}

- (void) showDetailedErrorInfo:(NSError*)error {
    NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
    NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    if(detailedErrors != nil && [detailedErrors count] > 0) {
        for(NSError* detailedError in detailedErrors) {
            NSLog(@"  DetailedError: %@", [detailedError userInfo]);
        }
    }
    else {
        NSLog(@"  %@", [error userInfo]);
    }
}



@end