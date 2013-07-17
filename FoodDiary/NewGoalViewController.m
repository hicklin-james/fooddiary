//
//  NewGoalViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-15.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "NewGoalViewController.h"

@interface NewGoalViewController ()

@end

@implementation NewGoalViewController

EnglishWeightCell *englishWeightCell;
EnglishWeightCell *englishGoalCell;
MetricWeightCell *metricWeightCell;
MetricWeightCell *metricGoalCell;
TimeToReachGoalCell *timeCell;
NSUserDefaults *profile;

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
  profile = [NSUserDefaults standardUserDefaults];
  
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  
  if ([profile boolForKey:@"unitType"]) {
    [metricWeightCell.weightTextField becomeFirstResponder];
  }
  else {
    [englishWeightCell.weightTextField becomeFirstResponder];
  }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 1;
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return 4;
  
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
  if (indexPath.row == 0) {
    cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
    if ([profile boolForKey:@"unitType"])
      cell.textLabel.text = @"Weight (kg)";
    else
      cell.textLabel.text = @"Weight (lbs)";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
  }
  else {
    if ([profile boolForKey:@"unitType"]) {
      if (indexPath.row == 1) {
    metricWeightCell = [tableView dequeueReusableCellWithIdentifier:@"metricWeightCell"];
    metricWeightCell.weightLabel.text = @"Current Weight";
    return metricWeightCell;
  }
     else if (indexPath.row == 2 ){ 
      metricGoalCell = [tableView dequeueReusableCellWithIdentifier:@"metricWeightCell"];
      metricGoalCell.weightLabel.text = @"Weight Goal";
      return metricGoalCell;
    }
  }
    else {
      if (indexPath.row == 1) {
        englishWeightCell = [tableView dequeueReusableCellWithIdentifier:@"englishWeightCell"];
        englishWeightCell.weightLabel.text = @"Current Weight";
        return englishWeightCell;
      }
      else if (indexPath.row == 2 ) {
        englishGoalCell = [tableView dequeueReusableCellWithIdentifier:@"englishWeightCell"];
        englishGoalCell.weightLabel.text = @"Weight Goal";
        return englishGoalCell;
      }
    }
    if (indexPath.row == 3) {
    timeCell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
    timeCell.timeTextField.text = @"1";
    return timeCell;
    }
  }
  
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 46;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  
   if (textField == timeCell.timeTextField) {
   // create a UIPicker view as a custom keyboard view
   UIPickerView* pickerView = [[UIPickerView alloc] init];
   [pickerView sizeToFit];
   pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
   pickerView.delegate = self;
   pickerView.dataSource = self;
   pickerView.showsSelectionIndicator = YES;
   //yourPickerView = pickerView;  //UIPickerView
   
   timeCell.timeTextField.inputView = pickerView;
   }
   
  return YES;
  
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  
  return 1;
  
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 36;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  timeCell.timeTextField.text = [NSString stringWithFormat:@"%d", row+1];
  
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
  
  return 120;
  
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 37)];
  label.text = [NSString stringWithFormat:@"%d", row+1];
  label.textAlignment = NSTextAlignmentCenter;
  label.backgroundColor = [UIColor clearColor];
  return label;
}

- (IBAction)cancelNewGoal:(id)sender {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (IBAction)goToNextView:(id)sender {
  
  if ([metricWeightCell.weightTextField.text isEqual: @""] || [metricWeightCell.weightTextField.text isEqual: @"0"] || [metricGoalCell.weightTextField.text isEqual: @""] || [metricGoalCell.weightTextField.text isEqual: @"0"] || [englishWeightCell.weightTextField.text isEqual: @""] || [englishWeightCell.weightTextField.text isEqual: @"0"] || [englishGoalCell.weightTextField.text isEqual: @""] || [englishGoalCell.weightTextField.text isEqual: @"0"]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Enter valid weights and time!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
  }
  else {
    
    if ([profile boolForKey:@"unitType"]) {
      // convert weights to kg
      CGFloat weightInKg = [metricWeightCell.weightTextField.text floatValue];
      CGFloat weightInLbs = weightInKg*2.2046;
      
      CGFloat goalWeightInKg = [metricGoalCell.weightTextField.text floatValue];
      CGFloat goalWeightInLbs = goalWeightInKg*2.2046;
      
      // save current weight and goal weight
      [profile setFloat:weightInLbs forKey:@"lbs"];
      [profile setFloat:weightInKg forKey:@"kg"];
      
      [profile setFloat:goalWeightInLbs forKey:@"goalWeightLbs"];
      [profile setFloat:goalWeightInKg forKey:@"goalWeightKg"];
      
      // save time for goal
      [profile setInteger:[timeCell.timeTextField.text integerValue] forKey:@"timeForGoal"];
      
      [profile synchronize];
      
      [metricWeightCell.weightTextField resignFirstResponder];
      [metricGoalCell.weightTextField resignFirstResponder];
      [timeCell.timeTextField resignFirstResponder];
    }
    else {
      // convert weights to lbs
      CGFloat weightInLbs = [englishWeightCell.weightTextField.text floatValue];
      CGFloat weightInKg = weightInLbs/2.2046;
      
      CGFloat goalWeightInLbs = [englishWeightCell.weightTextField.text floatValue];
      CGFloat goalWeightInKg = goalWeightInLbs/2.2046;
      
      // save current weight and goal weight
      [profile setFloat:weightInLbs forKey:@"lbs"];
      [profile setFloat:weightInKg forKey:@"kg"];
      
      [profile setFloat:goalWeightInLbs forKey:@"goalWeightLbs"];
      [profile setFloat:goalWeightInKg forKey:@"goalWeightKg"];
      
      // save time for goal
      [profile setInteger:[timeCell.timeTextField.text integerValue] forKey:@"timeForGoal"];
      
      [profile synchronize];
      
      [englishWeightCell.weightTextField resignFirstResponder];
      [englishGoalCell.weightTextField resignFirstResponder];
      [timeCell.timeTextField resignFirstResponder];
    }
    [self performSegueWithIdentifier:@"goalCompleteSegue" sender:self];
  }
}
@end
