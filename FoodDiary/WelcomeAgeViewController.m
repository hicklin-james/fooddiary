//
//  WelcomeAgeViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-11.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "WelcomeAgeViewController.h"
#import "AgeCell.h"

@interface WelcomeAgeViewController ()

@end

@implementation WelcomeAgeViewController

AgeCell *ageCell;

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
  
  [ageCell.ageTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  NSLog(@"Memory Warning!");
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
    cell.textLabel.text = @"Enter Your Age";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    return cell;
  }
  else {
    ageCell = [tableView dequeueReusableCellWithIdentifier:@"ageCell"];
    return ageCell;
  }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 46;
}


- (IBAction)goToNextView:(id)sender {
  
  if ([ageCell.ageTextField.text isEqual: @""]) {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Enter a valid age!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
    
  }
  else {
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    [profile setInteger:[ageCell.ageTextField.text integerValue] forKey:@"age"];
    [profile synchronize];
    
    [ageCell.ageTextField resignFirstResponder];
    [self performSegueWithIdentifier:@"exerciseLevelSegue" sender:self];
  }
}
@end
