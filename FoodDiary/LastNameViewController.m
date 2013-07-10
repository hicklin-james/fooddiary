//
//  LastNameViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-09.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "LastNameViewController.h"
#import "LastNameCell.h"

@interface LastNameViewController ()

@end

@implementation LastNameViewController

LastNameCell *lastNameCell;

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
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveLastName:)];
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  
  [lastNameCell.lastNameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveLastName:(id)sender {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  [profile setObject:lastNameCell.lastNameTextField.text forKey:@"lastName"];
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
    cell.textLabel.text = @"Enter Your Last Name";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    return cell;
  }
  else {
    lastNameCell = [tableView dequeueReusableCellWithIdentifier:@"lastNameCell"];
    
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    NSString *lastName = [profile stringForKey:@"lastName"];
    lastNameCell.lastNameTextField.text = lastName;
    
    return lastNameCell;
    
  }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 46;
}

#pragma mark - TextField Delegate Methods
//-----------------------------TextField Delegate Methods-------------------------------//
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  [self saveLastName:self];
  return YES;
  
}

@end
