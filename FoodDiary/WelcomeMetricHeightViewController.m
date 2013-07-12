//
//  WelcomeMetricHeightViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-10.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "WelcomeMetricHeightViewController.h"
#import "MetricHeightCell.h"

@interface WelcomeMetricHeightViewController ()

@end

@implementation WelcomeMetricHeightViewController

MetricHeightCell *heightCell;

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
  
  [heightCell.heightTextField becomeFirstResponder];
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
  
  return 2;
  
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
  if (indexPath.row == 0) {
    cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
    cell.textLabel.text = @"Enter Your Height (cm)";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    return cell;
  }
  else {
    
    heightCell = [tableView dequeueReusableCellWithIdentifier:@"heightCell"];
    return heightCell;
    
  }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 46;
}

- (IBAction)goToNextView:(id)sender {
  
  if ([heightCell.heightTextField.text isEqual: @""]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Enter a valid height!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
  }
  else {
    // add to profile information
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    
    CGFloat heightInCm = [heightCell.heightTextField.text floatValue];
    NSArray *feetAndInches = [self feetAndInchesFromCm:heightInCm];
    
    CGFloat inches = [[feetAndInches objectAtIndex:0] floatValue];
    CGFloat feet = [[feetAndInches objectAtIndex:1] floatValue];
    
    [profile setFloat:heightInCm forKey:@"cm"];
    [profile setFloat:inches forKey:@"inches"];
    [profile setFloat:feet forKey:@"feet"];
    
    [profile synchronize];
    
    // segue to next view
    [self performSegueWithIdentifier:@"metricWeightSegue" sender:self];
  }
}

-(NSArray*)feetAndInchesFromCm:(CGFloat)cm {
  CGFloat totalInches = cm * 0.39370;
  NSArray *feetAndInches = [NSArray arrayWithObjects:[NSNumber numberWithFloat:fmod(totalInches, 12)], [NSNumber numberWithFloat:totalInches/12], nil];
  return feetAndInches;
}

@end
