//
//  GoalViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-15.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "GoalViewController.h"
#import "NoGoalCell.h"

@interface GoalViewController ()

@end

@implementation GoalViewController

NoGoalCell *noGoalCell;

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


-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.tableView reloadData];
  
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//-----------------------------TableView Methods-------------------------------//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  //if (![profile boolForKey:@"goalSet"])
    return 1;
 // return 2;
  
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  //if (![profile boolForKey:@"goalSet"])
  return 1;
  
//  if (section == 0)
 //   return 3;
 // else
 //   return 1;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *standardIdentifier = @"cellId";
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:standardIdentifier];
  cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.font = [UIFont systemFontOfSize:11];
  cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  if (![profile boolForKey:@"goalSet"]) {
    noGoalCell = [tableView dequeueReusableCellWithIdentifier:@"noGoalSet"];
    noGoalCell.nameLabel.text = [NSString stringWithFormat:@"Hi %@! You currently weigh:", [profile stringForKey:@"firstName"]];
    if ([profile boolForKey:@"unitType"]) {
      noGoalCell.weightLabel.text = [NSString stringWithFormat:@"%.00f kg", [profile floatForKey:@"kg"]];
    }
    else {
          noGoalCell.weightLabel.text = [NSString stringWithFormat:@"%.00f lbs", [profile floatForKey:@"lbs"]];
    }
  
    return noGoalCell;
  }
  else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"goalCell"];
    return cell;
  }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  if (![profile boolForKey:@"goalSet"]) {
    return 167;
  }
  else {
    return 182;
  }
}

- (IBAction)setNewGoal:(id)sender {
  
  [self performSegueWithIdentifier:@"newGoalSegue" sender:self];
  
}
@end
