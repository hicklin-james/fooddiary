//
//  NewFoodAttributesViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-23.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "NewFoodAttributesViewController.h"
#import "NewFoodCell.h"

@interface NewFoodAttributesViewController ()

@end

@implementation NewFoodAttributesViewController

@synthesize tableView;

NewFoodCell *caloriesCell;
NewFoodCell *carbohydratesCell;
NewFoodCell *proteinCell;
NewFoodCell *fatCell;
NewFoodCell *satFatCell;
NewFoodCell *polyunsatFatCell;
NewFoodCell *monounsatFatCell;
NewFoodCell *transFatCell;
NewFoodCell *cholesterolCell;
NewFoodCell *sodiumCell;
NewFoodCell *potassiumCell;
NewFoodCell *fiberCell;
NewFoodCell *sugarCell;
NewFoodCell *vitaminCCell;
NewFoodCell *vitaminACell;
NewFoodCell *calciumCell;
NewFoodCell *ironCell;

@synthesize customFood;

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
  caloriesCell = [tableView dequeueReusableCellWithIdentifier:@"caloriesCell"];
  carbohydratesCell = [tableView dequeueReusableCellWithIdentifier:@"carbohydratesCell"];
  proteinCell = [tableView dequeueReusableCellWithIdentifier:@"proteinCell"];
  fatCell = [tableView dequeueReusableCellWithIdentifier:@"fatCell"];
  satFatCell = [tableView dequeueReusableCellWithIdentifier:@"saturatedFatCell"];
  polyunsatFatCell = [tableView dequeueReusableCellWithIdentifier:@"polyunsaturatedFatCell"];
  monounsatFatCell = [tableView dequeueReusableCellWithIdentifier:@"monounsaturatedFatCell"];
  transFatCell = [tableView dequeueReusableCellWithIdentifier:@"transFatCell"];
  cholesterolCell = [tableView dequeueReusableCellWithIdentifier:@"cholesterolCell"];
  sodiumCell = [tableView dequeueReusableCellWithIdentifier:@"sodiumCell"];
  potassiumCell = [tableView dequeueReusableCellWithIdentifier:@"potassiumCell"];
  fiberCell = [tableView dequeueReusableCellWithIdentifier:@"fiberCell"];
  sugarCell = [tableView dequeueReusableCellWithIdentifier:@"sugarCell"];
  vitaminCCell = [tableView dequeueReusableCellWithIdentifier:@"vitaminCCell"];
  vitaminACell = [tableView dequeueReusableCellWithIdentifier:@"vitaminACell"];
  calciumCell = [tableView dequeueReusableCellWithIdentifier:@"calciumCell"];
  ironCell = [tableView dequeueReusableCellWithIdentifier:@"ironCell"];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [caloriesCell.textField becomeFirstResponder];
  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if (section == 0)
    return 2;
  else
    return 17;
  
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
    //  caloriesCell = [tableView dequeueReusableCellWithIdentifier:@"caloriesCell"];
      return caloriesCell;
    }
    else {
     // carbohydratesCell = [tableView dequeueReusableCellWithIdentifier:@"carbohydratesCell"];
      return carbohydratesCell;
    }
  }
  else  if (indexPath.row == 2) {
   // proteinCell = [tableView dequeueReusableCellWithIdentifier:@"proteinCell"];
    return proteinCell;
  }
  else if (indexPath.row == 3) {
   // fatCell = [tableView dequeueReusableCellWithIdentifier:@"fatCell"];
    return fatCell;
  }
  else if (indexPath.row == 4) {
    //satFatCell = [tableView dequeueReusableCellWithIdentifier:@"saturatedFatCell"];
    return satFatCell;
  }
  else if (indexPath.row == 5) {
    //polyunsatFatCell = [tableView dequeueReusableCellWithIdentifier:@"polyunsaturatedFatCell"];
    return polyunsatFatCell;
  }
  else if (indexPath.row == 6) {
   // monounsatFatCell = [tableView dequeueReusableCellWithIdentifier:@"monounsaturatedFatCell"];
    return monounsatFatCell;
  }
  else if (indexPath.row == 7) {
   // transFatCell = [tableView dequeueReusableCellWithIdentifier:@"transFatCell"];
    return transFatCell;
  }
  else if (indexPath.row == 8) {
   // cholesterolCell = [tableView dequeueReusableCellWithIdentifier:@"cholesterolCell"];
    return cholesterolCell;
  }
  else if (indexPath.row == 9) {
    //sodiumCell = [tableView dequeueReusableCellWithIdentifier:@"sodiumCell"];
    return sodiumCell;
  }
  else if (indexPath.row == 10) {
    //potassiumCell = [tableView dequeueReusableCellWithIdentifier:@"potassiumCell"];
    return potassiumCell;
  }
  else if (indexPath.row == 11) {
   // fiberCell = [tableView dequeueReusableCellWithIdentifier:@"fiberCell"];
    return fiberCell;
  }
  else if (indexPath.row == 12) {
    //sugarCell = [tableView dequeueReusableCellWithIdentifier:@"sugarCell"];
    return sugarCell;
  }
  else if (indexPath.row == 13) {
    //vitaminCCell = [tableView dequeueReusableCellWithIdentifier:@"vitaminCCell"];
    return vitaminCCell;
  }
  else if (indexPath.row == 14) {
   // vitaminACell = [tableView dequeueReusableCellWithIdentifier:@"vitaminACell"];
    return vitaminACell;
  }
  else if (indexPath.row == 15) {
   // calciumCell = [tableView dequeueReusableCellWithIdentifier:@"calciumCell"];
    return calciumCell;
  }
  // if (indexPath.row == 16
  else {
   // ironCell = [tableView dequeueReusableCellWithIdentifier:@"ironCell"];
    return ironCell;
  }
  
  return cell;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == 0)
    return 30;
  else
    return 40;
  
}

- (IBAction)saveCustomFood:(id)sender {
  
  if ([caloriesCell.textField.text isEqual:@""])  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"You must enter a calorie value" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
  }
  else {
    
    [customFood setCalories:[NSNumber numberWithFloat:[caloriesCell.textField.text floatValue]]];
    
    // Check each text field to see if there is anything in it.
    if (![carbohydratesCell.textField.text isEqualToString:@""]) {
      [customFood setCarbohydrates:[NSNumber numberWithFloat:[carbohydratesCell.textField.text floatValue]]];
    }
    if (![proteinCell.textField.text isEqualToString:@""]) {
      [customFood setProtein:[NSNumber numberWithFloat:[proteinCell.textField.text floatValue]]];
    }
    if (![fatCell.textField.text isEqualToString:@""]) {
      [customFood setFat:[NSNumber numberWithFloat:[fatCell.textField.text floatValue]]];
    }
    if (![satFatCell.textField.text isEqualToString:@""]) {
      NSLog(satFatCell.textField.text);
      [customFood setSaturatedFat:[NSNumber numberWithFloat:[satFatCell.textField.text floatValue]]];
    }
    if (![polyunsatFatCell.textField.text isEqualToString:@""]) {
      [customFood setPolyunsaturatedFat:[NSNumber numberWithFloat:[polyunsatFatCell.textField.text floatValue]]];
    }
    if (![monounsatFatCell.textField.text isEqualToString:@""]) {
      [customFood setMonounsaturatedFat:[NSNumber numberWithFloat:[monounsatFatCell.textField.text floatValue]]];
    }
    if (![transFatCell.textField.text isEqualToString:@""]) {
      [customFood setTransFat:[NSNumber numberWithFloat:[transFatCell.textField.text floatValue]]];
    }
    if (![cholesterolCell.textField.text isEqualToString:@""]) {
      [customFood setCholesterol:[NSNumber numberWithFloat:[cholesterolCell.textField.text floatValue]]];
    }
    if (![sodiumCell.textField.text isEqualToString:@""]) {
      [customFood setSodium:[NSNumber numberWithFloat:[sodiumCell.textField.text floatValue]]];
    }
    if (![potassiumCell.textField.text isEqualToString:@""]) {
      [customFood setPotassium:[NSNumber numberWithFloat:[potassiumCell.textField.text floatValue]]];
    }
    if (![fiberCell.textField.text isEqualToString:@""]) {
      [customFood setFiber:[NSNumber numberWithFloat:[fiberCell.textField.text floatValue]]];
    }
    if (![sugarCell.textField.text isEqualToString:@""]) {
      [customFood setSugar:[NSNumber numberWithFloat:[sugarCell.textField.text floatValue]]];
    }
    if (![vitaminCCell.textField.text isEqualToString:@""]) {
      [customFood setVitaminC:[NSNumber numberWithFloat:[vitaminCCell.textField.text floatValue]]];
    }
    if (![vitaminACell.textField.text isEqualToString:@""]) {
      [customFood setVitaminA:[NSNumber numberWithFloat:[vitaminACell.textField.text floatValue]]];
    }
    if (![calciumCell.textField.text isEqualToString:@""]) {
      [customFood setCalcium:[NSNumber numberWithFloat:[calciumCell.textField.text floatValue]]];
    }
    if (![ironCell.textField.text isEqualToString:@""]) {
      [customFood setIron:[NSNumber numberWithFloat:[ironCell.textField.text floatValue]]];
    }
   
    MealController *controller = [MealController sharedInstance];
    
    NSError *error = nil;
    
    if (![[controller managedObjectContext] save:&error]) {
      [controller showDetailedErrorInfo:error];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
  }

  
}
@end
