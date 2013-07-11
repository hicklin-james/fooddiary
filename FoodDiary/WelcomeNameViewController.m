//
//  WelcomeNameViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-10.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "WelcomeNameViewController.h"
#import "FirstNameCell.h"
#import "LastNameCell.h"

@interface WelcomeNameViewController ()

@end

@implementation WelcomeNameViewController

FirstNameCell *firstNameCell;
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
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [firstNameCell.firstNameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView methods
//------------------------------TableView Delegate Methods----------------------------//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
        cell.textLabel.text = @"Enter Your First and Last Name";
        cell.textLabel.textColor = [UIColor whiteColor];
        UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
        cell.backgroundColor = color;
        return cell;
    }
    else if (indexPath.row == 1) {
        
        firstNameCell = [tableView dequeueReusableCellWithIdentifier:@"firstNameCell"];
        return firstNameCell;
        
    }
    else {
       
        lastNameCell = [tableView dequeueReusableCellWithIdentifier:@"lastNameCell"];
        return lastNameCell;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 30;
    else
        return 46;
}

- (IBAction)goToNextView:(id)sender {
    
    if ([firstNameCell.firstNameTextField.text isEqual: @""] || [lastNameCell.lastNameTextField.text isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Make sure all information has been entered into the fields" delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        // add to profile information
        NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
        [profile setObject:firstNameCell.firstNameTextField.text forKey:@"firstName"];
        [profile setObject:lastNameCell.lastNameTextField.text forKey:@"lastName"];
        [profile synchronize];
        
        // segue to next view
        [self performSegueWithIdentifier:@"ageWeightHeightSegue" sender:self];
    }
    
}


@end
