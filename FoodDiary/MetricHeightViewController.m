//
//  MetricHeightViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-09.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "MetricHeightViewController.h"
#import "MetricHeightCell.h"

@interface MetricHeightViewController ()

@end

@implementation MetricHeightViewController

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
          self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveHeight:)];
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

-(void)saveHeight:(id)sender {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  CGFloat heightInCm = [heightCell.heightTextField.text floatValue];
  NSArray *feetAndInches = [self feetAndInchesFromCm:heightInCm];
  
  CGFloat inches = [[feetAndInches objectAtIndex:0] floatValue];
  CGFloat feet = [[feetAndInches objectAtIndex:1] floatValue];
  
  [profile setFloat:heightInCm forKey:@"cm"];
  [profile setFloat:inches forKey:@"inches"];
  [profile setFloat:feet forKey:@"feet"];
  
  [profile synchronize];
  
  [self.navigationController popViewControllerAnimated:YES];
  
}

-(NSArray*)feetAndInchesFromCm:(CGFloat)cm {
  CGFloat totalInches = cm * 0.39370;
  NSArray *feetAndInches = [NSArray arrayWithObjects:[NSNumber numberWithFloat:fmod(totalInches, 12)], [NSNumber numberWithFloat:totalInches/12], nil];
  return feetAndInches;
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
    cell.textLabel.text = @"Enter Your height (cm)";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    return cell;
  }
  else {
    
    heightCell = [tableView dequeueReusableCellWithIdentifier:@"heightCell"];
    
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    NSString *height = [NSString stringWithFormat:@"%.00f", [profile floatForKey:@"cm"]];
    heightCell.heightTextField.text = height;
    
    return heightCell;
    
  }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 74;
}

@end
