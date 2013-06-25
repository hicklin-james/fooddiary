//
//  ProfileViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-24.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize firstName;
@synthesize lastName;
@synthesize age;

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

- (IBAction)saveProfileInfo:(id)sender {
  if (([self.firstNameTextField.text isEqual:@""]) || ([self.lastNameTextField.text isEqual:@""]) || ([self.ageTextField.text isEqual:@""])) {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"This is an example alert!" delegate:self cancelButtonTitle:@"Hide" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
  }
  else {
    firstName = self.firstNameTextField.text;
    lastName = self.lastNameTextField.text;
    age = [self.ageTextField.text intValue];
    
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    [profile setObject:firstName forKey:@"firstName"];
    [profile setObject:lastName  forKey:@"lastName"];
    [profile setInteger:age forKey:@"age"];
    [profile setBool:YES forKey:@"profileSet"];
    [profile synchronize];
    NSLog(@"Profile Data Saved");
    
    
  }
}


// ----------------- TextField Delegate Methods -----------------//

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  if (textField == self.firstNameTextField) {
    
  }
  
  
  [textField resignFirstResponder];
  
  return YES;
}




-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
  
  
  [super setEditing:editing animated:animated];
  if (editing == YES){
    
  }
  else {
    
  }
  
}

- (IBAction)startEditing:(id)sender {
  
  [self setEditing:YES animated:YES];
  
}
@end
