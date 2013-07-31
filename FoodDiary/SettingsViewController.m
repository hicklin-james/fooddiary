//
//  SettingsViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-26.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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

//---------------------------TableView Methods-----------------------------//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *standardIdentifier = @"cellId";
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:standardIdentifier];
  cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.font = [UIFont systemFontOfSize:11];
  cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
  
  if (indexPath.row == 0) {
    cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
    cell.textLabel.text = @"Settings";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  else if (indexPath.row == 1) {
    //cell = [tableView dequeueReusableCellWithIdentifier:@"manageFoodsCell"];
    cell.textLabel.text = @"Manage Custom Foods";
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
  }
  else {
    //cell = [tableView dequeueReusableCellWithIdentifier:@"calibrateProfileCell"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = @"Calibrate Profile";
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  }
  
  return cell;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 49;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == 1) {
    [self performSegueWithIdentifier:@"manageFoodsSegue" sender:self];
  }
  if (indexPath.row == 2) {
    [self performSegueWithIdentifier:@"calibrateProfileSegue" sender:self];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
