//
//  UpdateCustomFoodViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-29.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "UpdateCustomFoodViewController.h"
#import "NewFoodCell.h"

@interface UpdateCustomFoodViewController ()

@end

@implementation UpdateCustomFoodViewController

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
      return nameCell;
    }
    else {
      return brandNameCell;
    }
  }
  else if (indexPath.row == 2) {
    if (indexPath.section == 0) {
      //  caloriesCell = [tableView dequeueReusableCellWithIdentifier:@"caloriesCell"];
      return caloriesCell;
    }
    else {
      // carbohydratesCell = [tableView dequeueReusableCellWithIdentifier:@"carbohydratesCell"];
      return carbohydratesCell;
    }
  }
  else if (indexPath.row == 3) {
    if (indexPath.section== 0) {
      return servingSizeCell;
    }
    else {
      return proteinCell;
    }
  }
  else if (indexPath.row == 4) {
    // fatCell = [tableView dequeueReusableCellWithIdentifier:@"fatCell"];
    return fatCell;
  }
  else if (indexPath.row == 5) {
    //satFatCell = [tableView dequeueReusableCellWithIdentifier:@"saturatedFatCell"];
    return satFatCell;
  }
  else if (indexPath.row == 6) {
    //polyunsatFatCell = [tableView dequeueReusableCellWithIdentifier:@"polyunsaturatedFatCell"];
    return polyunsatFatCell;
  }
  else if (indexPath.row == 7) {
    // monounsatFatCell = [tableView dequeueReusableCellWithIdentifier:@"monounsaturatedFatCell"];
    return monounsatFatCell;
  }
  else if (indexPath.row == 8) {
    // transFatCell = [tableView dequeueReusableCellWithIdentifier:@"transFatCell"];
    return transFatCell;
  }
  else if (indexPath.row == 9) {
    // cholesterolCell = [tableView dequeueReusableCellWithIdentifier:@"cholesterolCell"];
    return cholesterolCell;
  }
  else if (indexPath.row == 10) {
    //sodiumCell = [tableView dequeueReusableCellWithIdentifier:@"sodiumCell"];
    return sodiumCell;
  }
  else if (indexPath.row == 11) {
    //potassiumCell = [tableView dequeueReusableCellWithIdentifier:@"potassiumCell"];
    return potassiumCell;
  }
  else if (indexPath.row == 12) {
    // fiberCell = [tableView dequeueReusableCellWithIdentifier:@"fiberCell"];
    return fiberCell;
  }
  else if (indexPath.row == 13) {
    //sugarCell = [tableView dequeueReusableCellWithIdentifier:@"sugarCell"];
    return sugarCell;
  }
  else if (indexPath.row == 14) {
    //vitaminCCell = [tableView dequeueReusableCellWithIdentifier:@"vitaminCCell"];
    return vitaminCCell;
  }
  else if (indexPath.row == 15) {
    // vitaminACell = [tableView dequeueReusableCellWithIdentifier:@"vitaminACell"];
    return vitaminACell;
  }
  else if (indexPath.row == 16) {
    // calciumCell = [tableView dequeueReusableCellWithIdentifier:@"calciumCell"];
    return calciumCell;
  }
  // if (indexPath.row == 17
  else  if (indexPath.row == 17){
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


@end
