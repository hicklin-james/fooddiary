//
//  WelcomeUnitTypeViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-10.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "WelcomeUnitTypeViewController.h"

@interface WelcomeUnitTypeViewController ()

@end

@implementation WelcomeUnitTypeViewController

@synthesize unitControl;

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
  UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
  NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                         forKey:UITextAttributeFont];
  [unitControl setTitleTextAttributes:attributes
                                  forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToNextView:(id)sender {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  if (unitControl.selectedSegmentIndex == 0) {
    [profile setBool:YES forKey:@"unitType"];
  }
  if (unitControl.selectedSegmentIndex == 1) {
    [profile setBool:NO forKey:@"unitType"];
  }
  
  if (unitControl.selectedSegmentIndex == 0)
    [self performSegueWithIdentifier:@"metricHeightSegue" sender:self];
  else
    [self performSegueWithIdentifier:@"englishHeightSegue" sender:self];
  
}
@end
