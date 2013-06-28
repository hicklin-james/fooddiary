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

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize firstName;
@synthesize lastName;
@synthesize age;

ProfileNameCell *firstNameCell;
ProfileNameCell *lastNameCell;
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
  
  self.editing = NO;
  
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
  if (self.editing == YES) {
    if (section == 0)
      return 2;
    if (section == 1)
      return 1;
  }
  else {
    if (section == 0)
      return 1;
    if (section == 1)
      return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    // Configure the cell...
  if (self.editing == YES) {
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
     if (indexPath.section == 1) {
       ageCell = [tableView dequeueReusableCellWithIdentifier:@"profileAgeCell"];
       return ageCell;
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
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{

  [super setEditing:editing animated:animated];
  [self.tableView setEditing:editing animated:animated];
  
  if(editing == YES)
  {
    
   //   [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
     [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableView reloadData];
   // [self.tableView endUpdates];
  } else {
    // Your code for exiting edit mode goes here
    
    // Resign first responders so that profile information is updated
    [self textFieldShouldReturn:firstNameCell.nameTextField];
    [self textFieldShouldReturn:lastNameCell.nameTextField];
    [self textFieldShouldReturn:ageCell.ageTextBox];
    
     [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
  }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  if (textField == firstNameCell.nameTextField){
    firstName = textField.text;
  }
  if (textField == lastNameCell.nameTextField){
    lastName = textField.text;
  }
  if (textField == ageCell.ageTextBox){
    age = [textField.text integerValue];
  }
  [textField resignFirstResponder];
  return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
  
  if (textField == firstNameCell.nameTextField){
    firstName = textField.text;
  }
  if (textField == lastNameCell.nameTextField){
    lastName = textField.text;
  }
  if (textField == ageCell.ageTextBox){
    age = [textField.text integerValue];
  }
  
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
  return UITableViewCellEditingStyleNone;
}


@end
