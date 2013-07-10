//
//  AgeViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-09.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "AgeViewController.h"
#import "AgeCell.h"

@interface AgeViewController ()

@end

@implementation AgeViewController

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
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAge:)];
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  
  [ageCell.ageTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveAge:(id)sender {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  [profile setInteger:[ageCell.ageTextField.text integerValue] forKey:@"age"];
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
    cell.textLabel.text = @"Enter Your Age";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    return cell;
  }
  else {
    ageCell = [tableView dequeueReusableCellWithIdentifier:@"ageCell"];
    
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    NSString *age = [NSString stringWithFormat:@"%d", [profile integerForKey:@"age"]];
    ageCell.ageTextField.text = age;
    
    return ageCell;
    
  }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 46;
}


@end
