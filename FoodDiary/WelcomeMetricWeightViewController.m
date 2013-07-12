//
//  WelcomeMetricWeightViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-10.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "WelcomeMetricWeightViewController.h"
#import "MetricWeightCell.h"
#import "TimeToReachGoalCell.h"

@interface WelcomeMetricWeightViewController ()

@end

@implementation WelcomeMetricWeightViewController

MetricWeightCell *weightCell;
MetricWeightCell *goalCell;
TimeToReachGoalCell *timeCell;

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
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  
  [weightCell.weightTextField becomeFirstResponder];
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
    cell.textLabel.text = @"Weight (kg)";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    return cell;
  }
  else if (indexPath.row == 1) {
    weightCell = [tableView dequeueReusableCellWithIdentifier:@"weightCell"];
    weightCell.weightLabel.text = @"Current Weight";
    return weightCell;
  }
  else if (indexPath.row == 2){
    goalCell = [tableView dequeueReusableCellWithIdentifier:@"weightCell"];
    goalCell.weightLabel.text = @"Weight Goal";
    return goalCell;
  }
  else {
    timeCell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
    timeCell.timeTextField.text = @"1";
    return timeCell;
  }
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

- (IBAction)goToNextView:(id)sender {
  
  if ([weightCell.weightTextField.text isEqual: @""] || [goalCell.weightTextField.text isEqual: @""] || [weightCell.weightTextField.text isEqual: @"0"] || [goalCell.weightTextField.text isEqual: @"0"]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Enter valid weights and time!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
  }
  else {
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
    // convert weights to kg
    CGFloat weightInKg = [weightCell.weightTextField.text floatValue];
    CGFloat weightInLbs = weightInKg*2.2046;
    
    CGFloat goalWeightInKg = [goalCell.weightTextField.text floatValue];
    CGFloat goalWeightInLbs = goalWeightInKg*2.2046;
  
    // save current weight and goal weight
    [profile setFloat:weightInLbs forKey:@"lbs"];
    [profile setFloat:weightInKg forKey:@"kg"];
    
    [profile setFloat:goalWeightInLbs forKey:@"goalWeightLbs"];
    [profile setFloat:goalWeightInKg forKey:@"goalWeightKg"];
  
    // save time for goal
    [profile setInteger:[timeCell.timeTextField.text integerValue] forKey:@"timeForGoal"];
    
    [profile synchronize];
    
    [weightCell.weightTextField resignFirstResponder];
    [goalCell.weightTextField resignFirstResponder];
    [timeCell.timeTextField resignFirstResponder];
    
    [self performSegueWithIdentifier:@"ageViewSegue" sender:self];
  }
}
@end
