//
//  WelcomeGenderViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-11.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "WelcomeGenderViewController.h"
#import "GenderCell.h"

@interface WelcomeGenderViewController ()

@end

@implementation WelcomeGenderViewController

GenderCell *genderCell;

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
    cell.textLabel.text = @"Choose your gender";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    return cell;
  }
  else {
    
    genderCell = [tableView dequeueReusableCellWithIdentifier:@"genderCell"];
    return genderCell;
    
  }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 87;
}

- (IBAction)goToNextView:(id)sender {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  // MALE == 0, FEMALE == 1
  if (genderCell.genderSegControl.selectedSegmentIndex == 0) {
    [profile setInteger:0 forKey:@"gender"];
  }
  else {
    [profile setInteger:1 forKey:@"gender"];
  }
  
[self performSegueWithIdentifier:@"completedSetupSegue" sender:self];

}
@end
