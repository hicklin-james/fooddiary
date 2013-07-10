//
//  NoProfileNameViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-09.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "NoProfileNameViewController.h"
#import "FoodDiaryViewController.h"

@interface NoProfileNameViewController ()

@end

@implementation NoProfileNameViewController

@synthesize managedObjectContext;
@synthesize mealsToday;
@synthesize dateToShow;

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
  
  // sets background color
  self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"noisy-texture-100x100-o51-d36-c-3783bd-t0"]];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testButtonPushed:(id)sender {
  
  //[self.delegate closeProfileWindow:self];
  [self dismissViewControllerAnimated:YES completion:nil];
  
}
@end
