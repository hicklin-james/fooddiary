//
//  UpdateCustomFoodViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-29.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "UpdateCustomFoodViewController.h"
#import "NewFoodCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MealController.h"

@interface UpdateCustomFoodViewController ()

@end

@implementation UpdateCustomFoodViewController

UIButton *cancelButton;
@synthesize customFood;
@synthesize tableView;

NewFoodCell *nameCell;
NewFoodCell *servingSizeCell;
NewFoodCell *brandNameCell;
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
  
  [self setTitle:[customFood name]];
  
  nameCell = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];
  brandNameCell = [tableView dequeueReusableCellWithIdentifier:@"brandNameCell"];
  servingSizeCell = [tableView dequeueReusableCellWithIdentifier:@"servingSizeCell"];
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
  
  UIView *newView = [[UIView alloc]initWithFrame:CGRectMake(10, 70, 300, 45)];
  cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [cancelButton addTarget:self action:@selector(deleteFood:) forControlEvents:UIControlEventTouchUpInside];
  [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [cancelButton setBackgroundImage:[UIImage imageNamed:@"redButton.png"] forState:UIControlStateNormal];
  //[submit setTitleColor:[UIColor colorWithWhite:0.0 alpha:0.56] forState:UIControlStateDisabled];
  cancelButton.layer.cornerRadius = 10;
  [cancelButton setTitle:@"Delete This Food" forState:UIControlStateNormal];
  [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  [cancelButton setFrame:CGRectMake(10.0, 15.0, 280.0, 44.0)];
  [newView addSubview:cancelButton];
  
  [self.tableView setTableFooterView:newView];
  
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
    return 4;
  else
    return 18;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
  if (indexPath.row == 0) {
    if (indexPath.section == 0) {
      cell = [self.tableView dequeueReusableCellWithIdentifier:@"sectionOneHeader"];
    }
    else {
      cell = [self.tableView dequeueReusableCellWithIdentifier:@"sectionTwoHeader"];
    }
  }
  else if (indexPath.row == 1) {
    if (indexPath.section == 0) {
      nameCell.textField.text = [customFood name];
      return nameCell;
    }
    else {
      brandNameCell.textField.text = [customFood brandName];
      return brandNameCell;
    }
  }
  else if (indexPath.row == 2) {
    if (indexPath.section == 0) {
      caloriesCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood calories] floatValue]];
      return caloriesCell;
    }
    else {
      if ([customFood carbohydrates] != nil)
        carbohydratesCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood carbohydrates] floatValue]];
      return carbohydratesCell;
    }
  }
  else if (indexPath.row == 3) {
    if (indexPath.section== 0) {
      servingSizeCell.textField.text = [customFood servingDescription];
      return servingSizeCell;
    }
    else {
      if ([customFood protein] != nil)
        proteinCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood protein] floatValue]];
      return proteinCell;
    }
  }
  else if (indexPath.row == 4) {
    if ([customFood fat] != nil)
      fatCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood fat] floatValue]];
    return fatCell;
  }
  else if (indexPath.row == 5) {
    if ([customFood saturatedFat] != nil)
      satFatCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood saturatedFat] floatValue]];
    return satFatCell;
  }
  else if (indexPath.row == 6) {
    if ([customFood polyunsaturatedFat] != nil)
      polyunsatFatCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood polyunsaturatedFat] floatValue]];
    return polyunsatFatCell;
  }
  else if (indexPath.row == 7) {
    if ([customFood monounsaturatedFat] != nil)
      monounsatFatCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood monounsaturatedFat] floatValue]];
    return monounsatFatCell;
  }
  else if (indexPath.row == 8) {
    if ([customFood transFat] != nil)
      transFatCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood transFat] floatValue]];
    return transFatCell;
  }
  else if (indexPath.row == 9) {
    if ([customFood cholesterol] != nil)
      cholesterolCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood cholesterol] floatValue]];
    return cholesterolCell;
  }
  else if (indexPath.row == 10) {
    if ([customFood sodium] != nil)
      sodiumCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood sodium] floatValue]];
    return sodiumCell;
  }
  else if (indexPath.row == 11) {
    if ([customFood potassium] != nil)
      potassiumCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood potassium] floatValue]];
    return potassiumCell;
  }
  else if (indexPath.row == 12) {
    if ([customFood fiber] != nil)
      fiberCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood fiber] floatValue]];
    return fiberCell;
  }
  else if (indexPath.row == 13) {
    if ([customFood sugar] != nil)
      sugarCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood sugar] floatValue]];
    return sugarCell;
  }
  else if (indexPath.row == 14) {
    if ([customFood vitaminC] != nil)
      vitaminCCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood vitaminC] floatValue]];
    return vitaminCCell;
  }
  else if (indexPath.row == 15) {
    if ([customFood vitaminA] != nil)
      vitaminACell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood vitaminA] floatValue]];
    return vitaminACell;
  }
  else if (indexPath.row == 16) {
    if ([customFood calcium] != nil)
      calciumCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood calcium] floatValue]];
    return calciumCell;
  }
  // if (indexPath.row == 17
  else  if (indexPath.row == 17){
    if ([customFood iron] != nil)
      ironCell.textField.text = [NSString stringWithFormat:@"%.00f", [[customFood iron] floatValue]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
  return 10;
}

- (IBAction)saveCustomFood:(id)sender {
  
  if ([caloriesCell.textField.text isEqual:@""] || [nameCell.textField.text isEqual:@""] || [servingSizeCell.textField.text isEqual:@""])  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"You must enter something into all the required fields" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
  }
  else {
    
    [customFood setCalories:[NSNumber numberWithFloat:[caloriesCell.textField.text floatValue]]];
    [customFood setName:nameCell.textField.text];
    [customFood setServingDescription:servingSizeCell.textField.text];
    [customFood setBrandName:brandNameCell.textField.text];
    
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
    [self.navigationController popViewControllerAnimated:YES];
  }
}

-(void)deleteFood:(id)sender {
  
 MealController *controller = [MealController sharedInstance];
  [[controller managedObjectContext] deleteObject:customFood];
  NSError *error = nil; 
  if (![[controller managedObjectContext] save:&error]) {
    [controller showDetailedErrorInfo:error];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

@end
