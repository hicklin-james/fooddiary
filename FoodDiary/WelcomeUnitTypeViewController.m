//
//  WelcomeUnitTypeViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-10.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "WelcomeUnitTypeViewController.h"
#import "UnitSelectionCell.h"

@interface WelcomeUnitTypeViewController ()

@end

@implementation WelcomeUnitTypeViewController

UnitSelectionCell *unitSelectionCell;

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
    unitSelectionCell = [self.tableView dequeueReusableCellWithIdentifier:@"unitSelectionCell"];
  UIFont *font = [UIFont boldSystemFontOfSize:11.0f];
  NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                         forKey:UITextAttributeFont];
  [unitSelectionCell.unitSelectionSegControl setTitleTextAttributes:attributes
                                  forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.textLabel.text = @"Select your unit";
        cell.textLabel.textColor = [UIColor whiteColor];
        UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
        cell.backgroundColor = color;
        return cell;
    }
    else {
        return unitSelectionCell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 30;
    else
        return 64;
}


- (IBAction)goToNextView:(id)sender {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  if (unitSelectionCell.unitSelectionSegControl.selectedSegmentIndex == 0) {
    [profile setBool:YES forKey:@"unitType"];
  }
  if (unitSelectionCell.unitSelectionSegControl.selectedSegmentIndex == 1) {
    [profile setBool:NO forKey:@"unitType"];
  }
  
  if (unitSelectionCell.unitSelectionSegControl.selectedSegmentIndex == 0)
    [self performSegueWithIdentifier:@"metricHeightSegue" sender:self];
  else
    [self performSegueWithIdentifier:@"englishHeightSegue" sender:self];
  
}
@end
