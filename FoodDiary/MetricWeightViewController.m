//
//  MetricWeightViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-09.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "MetricWeightViewController.h"
#import "MetricWeightCell.h"

@interface MetricWeightViewController ()

@end

@implementation MetricWeightViewController

MetricWeightCell *weightCell;

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWeight:)];
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

-(void)saveWeight:(id)sender {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  CGFloat weightInKg = [weightCell.weightTextField.text floatValue];
  CGFloat weightInLbs = weightInKg*2.2046;
  
  [profile setFloat:weightInLbs forKey:@"lbs"];
  [profile setFloat:weightInKg forKey:@"kg"];
  
  [profile synchronize];
  
  [self.navigationController popViewControllerAnimated:YES];
  
}

#pragma mark - TableView Methods
//------------------------------TableView Methods---------------------------//

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 1;
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return 2;
  
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
  if (indexPath.row == 0) {
    cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
    cell.textLabel.text = @"Enter Your weight (kg)";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    return cell;
  }
  else {
    
    weightCell = [tableView dequeueReusableCellWithIdentifier:@"weightCell"];
    
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    NSString *weight = [NSString stringWithFormat:@"%.00f", [profile floatForKey:@"kg"]];
    weightCell.weightTextField.text = weight;
    
    return weightCell;
    
  }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 46;
}

@end