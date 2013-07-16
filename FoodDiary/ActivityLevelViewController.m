//
//  ActivityLevelViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "ActivityLevelViewController.h"
#import "ActivityLevelCell.h"

@interface ActivityLevelViewController ()

@end

@implementation ActivityLevelViewController

ActivityLevelCell *activityLevelCell;

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveActivityLevel:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveActivityLevel:(id)sender {
    
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    [profile setInteger:activityLevelCell.activitySegControl.selectedSegmentIndex forKey:@"activityLevel"];
    [profile synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
        cell.textLabel.text = @"Choose your activity level";
        cell.textLabel.textColor = [UIColor whiteColor];
        UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
        cell.backgroundColor = color;
        return cell;
    }
    else {
        
         NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
        activityLevelCell = [tableView dequeueReusableCellWithIdentifier:@"activityLevelCell"];
        activityLevelCell.activitySegControl.selectedSegmentIndex = [profile integerForKey:@"activityLevel"];
        return activityLevelCell;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 30;
    else
        return 277;
}

@end
