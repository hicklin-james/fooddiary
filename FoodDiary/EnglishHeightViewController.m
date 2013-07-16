//
//  EnglishHeightViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-09.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "EnglishHeightViewController.h"
#import "EnglishHeightCell.h"

@interface EnglishHeightViewController ()

@end

@implementation EnglishHeightViewController

EnglishHeightCell *heightCell;
UIPickerView *heightPicker;
CGFloat feet;
CGFloat inches;


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
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  feet = [profile floatForKey:@"feet"];
  inches = [profile floatForKey:@"inches"];
  
  [self.pickerView selectRow:feet inComponent:0 animated:NO];
  [self.pickerView selectRow:inches inComponent:1 animated:NO];
}

-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveHeight:(id)sender {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  CGFloat totalInches = (feet*12)+inches;
  CGFloat cm = totalInches / 0.39370;
  
  [profile setFloat:cm forKey:@"cm"];
  [profile setFloat:inches forKey:@"inches"];
  [profile setFloat:feet forKey:@"feet"];
  
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
    cell.textLabel.text = @"Enter Your height (feet and inches)";
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    return cell;
  }
  else {
    
    heightCell = [tableView dequeueReusableCellWithIdentifier:@"heightCell"];
    
    NSString *height = [NSString stringWithFormat:@"%.00f′ %.00f″", feet, inches];
    heightCell.heightLabel.text = height;
    
    return heightCell;
    
  }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else
    return 74;
}

#pragma mark - ActionSheetCustomPicker Delegate Methods
//---------------- ActionSheetCustomPicker Delegate Methods------------------//
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  
  return 2;
  
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  
  if (component == 0) 
    return 9;
  else
    return 12;
  
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  if (component == 0)
    return [NSString stringWithFormat:@"%d′", row];
  else
    return [NSString stringWithFormat:@"%d″", row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  if (component == 0) {
    feet = row;
  }
  else {
    inches = row;
  }
  
  [self.tableView reloadData];
  
}

@end
