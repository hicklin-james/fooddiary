//
//  ProfileViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-28.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileNameCell.h"
#import "NonEditableNameCell.h"
#import "ProfileAgeCell.h"
#import "NonEditableAgeCell.h"
#import "NonEditableHeightCell.h"
#import "UnitSelectionViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

BOOL unitType; // YES = metric, NO = english

// initiliaze these as 0
CGFloat feet = 0;
CGFloat inches = 0;
CGFloat cm = 0;

NSString* firstName;
NSString* lastName;
NSInteger age;

ActionSheetCustomPicker *heightPicker;

// Editable Cells
ProfileNameCell *firstNameCell;
ProfileNameCell *lastNameCell;
NonEditableHeightCell *noEditHeightCell;

// Non-Editable Cells
NonEditableNameCell *nameCell;
ProfileAgeCell *ageCell;
NonEditableAgeCell *noEditAgeCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
}

-(void)viewWillAppear:(BOOL)animated {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  // get all private variables from NSUserDefaults
  unitType = [profile boolForKey:@"unitType"];
  feet = [profile floatForKey:@"feet"];
  inches = [profile floatForKey:@"inches"];
  cm = [profile floatForKey:@"cm"];
  age = [profile integerForKey:@"age"];
  firstName = [profile stringForKey:@"firstName"];
  lastName = [profile stringForKey:@"lastName"];
  
  [self.tableView reloadData];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
  if (self.editing == YES) {
    if (section == 0)
      return 2;
    if (section == 1)
      return 1;
    if (section == 2)
      return 2;
  }
  else {
    if (section == 0)
      return 1;
    if (section == 1)
      return 1;
    if (section == 2)
      return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    // Configure the cell...
  if (self.editing == YES) {
    
    // section 1 is the name section - in editing mode there is a first and last name field
    if (indexPath.section == 0) {
      if (indexPath.row == 0) {
        firstNameCell = [tableView dequeueReusableCellWithIdentifier:@"profileNameCell"];
        
        // First Name Cell in editing mode
        firstNameCell.nameTextField.placeholder = @"First Name";
        firstNameCell.nameTextField.text = firstName;
        //firstNameCell.nameTextField.delegate = firstNameCell;
      
        return firstNameCell;
      
      }
      if (indexPath.row == 1) {
        lastNameCell = [tableView dequeueReusableCellWithIdentifier:@"profileNameCell"];
        
        // Last Name Cell in editing mode
        lastNameCell.nameTextField.placeholder = @"Last Name";
        lastNameCell.nameTextField.text = lastName;
        //lastNameCell.nameTextField.delegate = lastNameCell;
      
        return lastNameCell;
      }
    
    }
    // section 1 is the age section
     if (indexPath.section == 1) {
       ageCell = [tableView dequeueReusableCellWithIdentifier:@"profileAgeCell"];
       ageCell.ageTextBox.text = [NSString stringWithFormat:@"%d", age];
       return ageCell;
    }
    
    if (indexPath.section == 2) {
      if (indexPath.row == 0) {
        static NSString *standardIdentifier = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:standardIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:standardIdentifier];
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:11];
        cell.textLabel.text = @"Measurement Unit";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
        if (unitType == NO) {
          cell.detailTextLabel.text = @"English";
        }
        else {
          cell.detailTextLabel.text = @"Metric";
        }
      
        return cell;
        
      }
      if (indexPath.row == 1) {
        noEditHeightCell = [tableView dequeueReusableCellWithIdentifier:@"nonEditableHeightCell"];
        
        if (unitType == NO) {
          heightPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Height Picker" delegate:self showCancelButton:YES origin:self.tableView];
          NSString *englishHeight = [NSString stringWithFormat:@"%.00f\" %.00f'", feet, inches];
          noEditHeightCell.metricHeightTextField.text = englishHeight;
          [noEditHeightCell.metricHeightTextField setEnabled:NO];
          noEditHeightCell.cmLabel.hidden = YES;
        }
        else {
          noEditHeightCell.cmLabel.hidden = NO;
          [noEditHeightCell.metricHeightTextField setEnabled:YES];
          NSString *metricHeight = [NSString stringWithFormat:@"%.00f",cm];
          noEditHeightCell.metricHeightTextField.text = metricHeight;
          
        }
        return noEditHeightCell;
      }
    }
  }
  else {
    
    if (indexPath.section == 0) {
      if (indexPath.row == 0) {
        nameCell = [tableView dequeueReusableCellWithIdentifier:@"nonEditableNameCell"];
        // First Name Cell in non-editing mode
        nameCell.name.text = [firstName stringByAppendingFormat:@" %@", lastName];
      
        return nameCell;
      }
    }
    if (indexPath.section == 1) {
        noEditAgeCell = [tableView dequeueReusableCellWithIdentifier:@"nonEditableAgeCell"];
      if (age != 0)
        noEditAgeCell.ageLabel.text = [NSString stringWithFormat:@"%d", age];
      else
        noEditAgeCell.ageLabel.text = @"";
        
        return noEditAgeCell;
      
      
    }
    if (indexPath.section == 2) {
      noEditHeightCell = [tableView dequeueReusableCellWithIdentifier:@"nonEditableHeightCell"];
      heightPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Height Picker" delegate:self showCancelButton:YES origin:self.tableView];
      [noEditHeightCell.metricHeightTextField setEnabled:NO];
      if (unitType == NO) {
        noEditHeightCell.cmLabel.hidden = YES;
        NSString *englishHeight = [NSString stringWithFormat:@"%.00f\" %.00f'", feet, inches];
        noEditHeightCell.metricHeightTextField.text = englishHeight;
      }
      else {
        noEditHeightCell.cmLabel.hidden = NO;
        NSString *metricHeight = [NSString stringWithFormat:@"%.00f",cm];
        noEditHeightCell.metricHeightTextField.text = metricHeight;
      }
      
      return noEditHeightCell;
      
    }
    
  }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
  
  if (indexPath.section == 2 && self.editing == YES && indexPath.row == 0) {
    [self performSegueWithIdentifier:@"unitTypeSegue" sender:self];
  }
  if (indexPath.section == 2 && self.editing == YES && indexPath.row == 1 && unitType == NO) {
    [heightPicker showActionSheetPicker];
    
    [(UIPickerView*)heightPicker.pickerView selectRow:feet-1 inComponent:0 animated:NO];
    [(UIPickerView*)heightPicker.pickerView selectRow:inches inComponent:1 animated:NO];
  }
  
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{

  [super setEditing:editing animated:animated];
  [self.tableView setEditing:editing animated:animated];
  
  if(editing == YES)
  {
    
   // NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:0 inSection:2],nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];


  } else {
    // Your code for exiting edit mode goes here
    
    // Resign first responders so that profile information is updated
    [self textFieldShouldReturn:firstNameCell.nameTextField];
    [self textFieldShouldReturn:lastNameCell.nameTextField];
    [self textFieldShouldReturn:ageCell.ageTextBox];
  
    //[self.tableView reloadData];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:0 inSection:2],nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
   // [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    

   // [self.tableView reloadData];
   // [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationTop];
  }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  if (textField == firstNameCell.nameTextField){
    firstName = textField.text;
    [profile setObject:textField.text forKey:@"firstName"];
  }
  if (textField == lastNameCell.nameTextField){
    lastName = textField.text;
    [profile setObject:textField.text forKey:@"lastName"];
  }
  if (textField == ageCell.ageTextBox){
    age = [textField.text integerValue];
    [profile setInteger:[textField.text integerValue] forKey:@"age"];
  }
  if (textField == noEditHeightCell.metricHeightTextField) {
    cm = [textField.text floatValue];
    CGFloat totalinches = cm * 0.39370;
    inches = fmod(totalinches, 12);
    feet = totalinches / 12;
    
    [profile setFloat:inches forKey:@"inches"];
    [profile setFloat:feet forKey:@"feet"];
    [profile setFloat:[textField.text floatValue] forKey:@"cm"];
  }

  [textField resignFirstResponder];
  return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  if (textField == firstNameCell.nameTextField){
    firstName = textField.text;
    [profile setObject:textField.text forKey:@"firstName"];
  }
  if (textField == lastNameCell.nameTextField){
    lastName = textField.text;
    [profile setObject:textField.text forKey:@"lastName"];
  }
  if (textField == ageCell.ageTextBox){
    age = [textField.text integerValue];
    [profile setInteger:[textField.text integerValue] forKey:@"age"];
  }
  if (textField == noEditHeightCell.metricHeightTextField) {
    cm = [textField.text floatValue];
    [profile setFloat:[textField.text floatValue] forKey:@"cm"];
  }
  
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
  return UITableViewCellEditingStyleNone;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  
  return 2;
  
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  
  if (component == 0)
    return 7;
  else
    return 12;
  
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  if (component == 0) 
    return [NSString stringWithFormat:@"%d'", row+1];
  else
    return [NSString stringWithFormat:@"%d\"", row];

}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  if (component == 0) {
    feet = row+1;
    [profile setFloat:feet forKey:@"feet"];
  }
  else {
    inches = row;
    [profile setFloat:inches forKey:@"inches"];
  }
  
  cm = ((feet * 12) + inches) / 0.39370;
  [profile setFloat:cm forKey:@"cm"];
  
  [profile synchronize];
  
  NSString *englishHeight = [NSString stringWithFormat:@"%.00f\" %.00f'", feet, inches];
  noEditHeightCell.metricHeightTextField.text = englishHeight;
  
}

@end
