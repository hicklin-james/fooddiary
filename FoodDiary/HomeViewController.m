//
//  HomeViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-13.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "HomeViewController.h"
#import "MyMeal.h"
#import "SummaryCell.h"
#import "NoGoalSummaryCell.h"
#import "MealController.h"
#import "DateManipulator.h"
#import "MyMeal.h"
#import "MyFood.h"
#import "MyServing.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize dataController;
@synthesize dateLabel;

SummaryCell* summaryCell;
NoGoalSummaryCell* noGoalSummaryCell;
DateManipulator *dateManipulator;

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
  
  dateManipulator = [[DateManipulator alloc] initWithDateFormatter];
  dataController = [MealController sharedInstance];
  self.homeTabBar.selectedItem = self.summaryItem;
  CGRect viewFrame=self.homeTabBar.frame;
  //change these parameters according to you.
  //viewFrame.origin.y -=50;
  //viewFrame.origin.x -=20;
  viewFrame.size.height=47;
  //viewFrame.size.width=300;
  self.homeTabBar.frame=viewFrame;
  
  #define RADIANS(degrees) ((degrees * M_PI) / 180.0)
  CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                              RADIANS(180.0));
  self.rightArrowButton.transform = rotateTransform;
  
  [self.summaryItem setTitlePositionAdjustment:UIOffsetMake(0, -17)];
  [self.todayItem setTitlePositionAdjustment:UIOffsetMake(0, -17)];

}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  // If there is no profile, present modal view to create a profile!
 /* NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  if ([profile boolForKey:@"profileSet"] == NO) {
    
    [self performSegueWithIdentifier:@"noProfileNameSegue" sender:self];
    
  }
  */
}

-(void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  
  NSString *todayString = [dateManipulator getStringOfDateWithoutTime:[NSDate date]];
  NSString *thisDateToShow = [dateManipulator getStringOfDateWithoutTime:dataController.dateToShow];
  UIColor *dateColor = [dateManipulator createDateColor:todayString dateToShowString:thisDateToShow];
  self.dateLabel.textColor = dateColor;
  self.dateLabel.text = thisDateToShow;
  
 // NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  /*
  if ([profile boolForKey:@"profileSet"] == NO) {
    
    //[self performSegueWithIdentifier:@"noProfileNameSegue" sender:self];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FDiPhone" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"noProfileNavController"];
    [self presentViewController:vc animated:YES completion:nil];
    
  }
  */
  [dataController refreshFoodData];
  
  [self.tableView reloadData];
  
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell;
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  
  if (indexPath.row == 0) {
    
    static NSString *CellIdentifier = @"Cell";
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
    if ([self.homeTabBar selectedItem] == self.summaryItem) {
      cell.textLabel.text = @"Summary";
    }
    else {
      cell.textLabel.text = @"Today's information";
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    UIColor * color = [UIColor colorWithRed:54/255.0f green:183/255.0f blue:191/255.0f alpha:1.0f];
    cell.backgroundColor = color;
    return cell;
    
  }
  else if ([self.homeTabBar selectedItem] == self.summaryItem) {
    
    if ([profile boolForKey:@"goalSet"]) {
      summaryCell = [tableView dequeueReusableCellWithIdentifier:@"summaryCell"];
     // summaryCell.calsRemainingLabel.text = [NSString stringWithFormat:@"%.00f", dataController.totalCalsNeeded-dataController.calorieCountTodayFloat];
      if (dataController.totalCalsNeeded-dataController.calorieCountTodayFloat <= 0) {
        summaryCell.calsRemainingLabel.textColor = [UIColor redColor];
        summaryCell.calsRemainingLabel.text = @"0";
      }
      else {
        summaryCell.calsRemainingLabel.textColor = [UIColor greenColor];
        summaryCell.calsRemainingLabel.text = [NSString stringWithFormat:@"%.00f", dataController.totalCalsNeeded-dataController.calorieCountTodayFloat];
      }
      
      NSString *goalFinishString = [dateManipulator getStringOfDateWithoutTime:(NSDate*)[profile objectForKey:@"goalFinishDate"]];
      summaryCell.goalDateLabel.text = goalFinishString;
      if ([profile boolForKey:@"unitType"]) {
        summaryCell.weightGoalLabel.text = [NSString stringWithFormat:@"%.00f kg",[profile floatForKey:@"goalWeightKg"]];
      }
      else {
        summaryCell.weightGoalLabel.text = [NSString stringWithFormat:@"%.00f lbs",[profile floatForKey:@"goalWeightLbs"]];
      }

      return summaryCell;
    }
    else {
      
      noGoalSummaryCell = [tableView dequeueReusableCellWithIdentifier:@"noGoalSummaryCell"];
      noGoalSummaryCell.remainingCalsToday.text = [NSString stringWithFormat:@"%.00f", dataController.totalCalsNeeded-dataController.calorieCountTodayFloat];
      
      return noGoalSummaryCell;
      
    }
  }
  else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"nutritionalInfo"];
    
    cell = [self dailyNutritionCell:cell];
  }
  
  return cell;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  
  [self.tableView reloadData];
  
}

-(UITableViewCell*)dailyNutritionCell:(UITableViewCell*)cell {
  
  CGFloat totalCals = 0.0f;
  CGFloat totalCarbs = 0.0f;
  CGFloat totalProtein = 0.0f;
  CGFloat totalFat = 0.0f;
  CGFloat totalSatFat = 0.0f;
  CGFloat totalPolyUnsatFat = 0.0f;
  CGFloat totalMonoUnsatFat = 0.0f;
  CGFloat totalTransFat = 0.0f;
  CGFloat totalCholesterol = 0.0f;
  CGFloat totalSodium = 0.0f;
  CGFloat totalPotassium = 0.0f;
  CGFloat totalFiber = 0.0f;
  CGFloat totalSugar = 0.0f;
  CGFloat totalVitC = 0.0f;
  CGFloat totalVitA = 0.0f;
  CGFloat totalCalcium = 0.0f;
  CGFloat totalIron = 0.0f;
  
  
  for (int i = 0; i < [[dataController mealsToday] count]; i++) {
     
    MyMeal *meal = [[dataController mealsToday] objectAtIndex:i];
    NSArray *foods = [[meal toMyFood] allObjects];
    
    for (int s = 0; s < [foods count]; s++) {
      
      MyFood *food = [foods objectAtIndex:s];
      MyServing *serving = [dataController fetchServingFromFood:food];
      
      totalCals += [[serving calories] floatValue] * [[food servingSize] floatValue];
      totalCarbs += [[serving carbohydrates] floatValue] * [[food servingSize] floatValue];
      totalProtein += [[serving protein] floatValue] * [[food servingSize] floatValue];
      totalFat += [[serving fat] floatValue] * [[food servingSize] floatValue];
      totalSatFat += [[serving saturatedFat] floatValue] * [[food servingSize] floatValue];
      totalPolyUnsatFat += [[serving polyunsaturatedFat] floatValue] * [[food servingSize] floatValue];
      totalMonoUnsatFat += [[serving monounsaturatedFat] floatValue] * [[food servingSize] floatValue];
      totalTransFat += [[serving transFat] floatValue] * [[food servingSize] floatValue];
      totalCholesterol += [[serving cholesterol] floatValue] * [[food servingSize] floatValue];
      totalSodium += [[serving cholesterol] floatValue] * [[food servingSize] floatValue];
      totalPotassium += [[serving potassium] floatValue] * [[food servingSize] floatValue];
      totalFiber += [[serving fiber] floatValue] * [[food servingSize] floatValue];
      totalSugar += [[serving sugar] floatValue] * [[food servingSize] floatValue];
      totalVitC += [[serving vitaminC] floatValue] * [[food servingSize] floatValue];
      totalVitA += [[serving vitaminA] floatValue] * [[food servingSize] floatValue];
      totalCalcium += [[serving calcium] floatValue] * [[food servingSize] floatValue];
      totalIron += [[serving iron] floatValue] * [[food servingSize] floatValue];
    }
  }
  
  // calories
  UILabel *calsAmountLabel = (UILabel *)[cell.contentView viewWithTag:1];
  NSString *calsInfoString = [NSString stringWithFormat:@"%.01f cals", totalCals];
  calsAmountLabel.font = [UIFont systemFontOfSize:10];
  [calsAmountLabel setText:calsInfoString];
  // carbs
  UILabel *carbsAmountLabel = (UILabel *)[cell.contentView viewWithTag:2];
  NSString *carbsInfoString = [NSString stringWithFormat:@"%.01f g", totalCarbs];
  carbsAmountLabel.font = [UIFont systemFontOfSize:10];
  [carbsAmountLabel setText:carbsInfoString];
  // protein
  UILabel *proteinAmountLabel = (UILabel *)[cell.contentView viewWithTag:3];
  NSString *proteinInfoString = [NSString stringWithFormat:@"%.01f g", totalProtein];
  proteinAmountLabel.font = [UIFont systemFontOfSize:10];
  [proteinAmountLabel setText:proteinInfoString];
  // fat
  UILabel *fatAmountLabel = (UILabel *)[cell.contentView viewWithTag:4];
  NSString *fatInfoString = [NSString stringWithFormat:@"%.01f g", totalFat];
  fatAmountLabel.font = [UIFont systemFontOfSize:10];
  [fatAmountLabel setText:fatInfoString];
  // saturated fat
  UILabel *satFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:5];
  NSString *satFatInfoString = [NSString stringWithFormat:@"%.01f g", totalSatFat];
  satFatAmountLabel.font = [UIFont systemFontOfSize:10];
  [satFatAmountLabel setText:satFatInfoString];
  // polyunsaturated fat
  UILabel *polyUnsatFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:6];
  NSString *polyUnsatFatInfoString = [NSString stringWithFormat:@"%.01f g", totalPolyUnsatFat];
  polyUnsatFatAmountLabel.font = [UIFont systemFontOfSize:10];
  [polyUnsatFatAmountLabel setText:polyUnsatFatInfoString];
  // monounsaturated fat
  UILabel *monoUnsatFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:7];
  NSString *monoUnsatFatInfoString = [NSString stringWithFormat:@"%.01f g", totalMonoUnsatFat];
  monoUnsatFatAmountLabel.font = [UIFont systemFontOfSize:10];
  [monoUnsatFatAmountLabel setText:monoUnsatFatInfoString];
  // transfat
  UILabel *transFatAmountLabel = (UILabel *)[cell.contentView viewWithTag:8];
  NSString *transFatInfoString = [NSString stringWithFormat:@"%.01f g", totalTransFat];
  transFatAmountLabel.font = [UIFont systemFontOfSize:10];
  [transFatAmountLabel setText:transFatInfoString];
  // cholesterol
  UILabel *cholesterolAmountLabel = (UILabel *)[cell.contentView viewWithTag:9];
  NSString *cholesterolInfoString = [NSString stringWithFormat:@"%.01f mg", totalCholesterol];
  cholesterolAmountLabel.font = [UIFont systemFontOfSize:10];
  [cholesterolAmountLabel setText:cholesterolInfoString];
  // sodium
  UILabel *sodiumAmountLabel = (UILabel *)[cell.contentView viewWithTag:10];
  NSString *sodiumInfoString = [NSString stringWithFormat:@"%.01f mg", totalSodium];
  sodiumAmountLabel.font = [UIFont systemFontOfSize:10];
  [sodiumAmountLabel setText:sodiumInfoString];
  // potassium
  UILabel *potassiumAmountLabel = (UILabel *)[cell.contentView viewWithTag:11];
  NSString *potassiumInfoString = [NSString stringWithFormat:@"%.01f mg", totalPotassium];
  potassiumAmountLabel.font = [UIFont systemFontOfSize:10];
  [potassiumAmountLabel setText:potassiumInfoString];
  // fiber
  UILabel *fiberAmountLabel = (UILabel *)[cell.contentView viewWithTag:12];
  NSString *fiberInfoString = [NSString stringWithFormat:@"%.01f g", totalFiber];
  fiberAmountLabel.font = [UIFont systemFontOfSize:10];
  [fiberAmountLabel setText:fiberInfoString];
  // sugar
  UILabel *sugarAmountLabel = (UILabel *)[cell.contentView viewWithTag:13];
  NSString *sugarInfoString = [NSString stringWithFormat:@"%.01f g", totalSugar];
  sugarAmountLabel.font = [UIFont systemFontOfSize:10];
  [sugarAmountLabel setText:sugarInfoString];
  // vitamin C
  UILabel *vitaminCAmountLabel = (UILabel *)[cell.contentView viewWithTag:14];
  NSString *vitaminCInfoString = [NSString stringWithFormat:@"%.01f%%", totalVitC];
  vitaminCAmountLabel.font = [UIFont systemFontOfSize:10];
  [vitaminCAmountLabel setText:vitaminCInfoString];
  // vitamin A
  UILabel *vitaminAAmountLabel = (UILabel *)[cell.contentView viewWithTag:15];
  NSString *vitaminAInfoString = [NSString stringWithFormat:@"%.01f%%", totalVitA];
  vitaminAAmountLabel.font = [UIFont systemFontOfSize:10];
  [vitaminAAmountLabel setText:vitaminAInfoString];
  // calcium
  UILabel *calciumAmountLabel = (UILabel *)[cell.contentView viewWithTag:16];
  NSString *calciumInfoString = [NSString stringWithFormat:@"%.01f%%", totalCalcium];
  calciumAmountLabel.font = [UIFont systemFontOfSize:10];
  [calciumAmountLabel setText:calciumInfoString];
  // iron
  UILabel *ironAmountLabel = (UILabel *)[cell.contentView viewWithTag:17];
  NSString *ironInfoString = [NSString stringWithFormat:@"%.01f%%", totalIron];
  ironAmountLabel.font = [UIFont systemFontOfSize:10];
  [ironAmountLabel setText:ironInfoString];

  
  cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"golden-parchment-paper-texture.png"]];
  cell.backgroundView.layer.cornerRadius = 5;
  cell.backgroundView.layer.masksToBounds = YES;
  
  return cell;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 30;
  else if ([self.homeTabBar selectedItem] == self.summaryItem)
    return 159;
  else
    return 426;
}

//-----------------Methods used when changing dates-------------------//
- (IBAction)changeToPreviousDay:(id)sender {
  
  NSDate *yesterday = [dateManipulator findDateWithOffset:-1 date:dataController.dateToShow];
  
  dataController.dateToShow = yesterday;
  NSDate *today = [NSDate date];
  NSString *todayString = [dateManipulator getStringOfDateWithoutTime:today];
  NSString *thisDateToShow = [dateManipulator getStringOfDateWithoutTime:dataController.dateToShow];
  UIColor *dateColor = [dateManipulator createDateColor:todayString dateToShowString:thisDateToShow];
  self.dateLabel.textColor = dateColor;
  self.dateLabel.text = thisDateToShow;
  
  [dataController refreshFoodData];
  //[self refreshFoodData];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)] withRowAnimation:UITableViewRowAnimationRight];
  //[self.tableView reloadData];
}

- (IBAction)changeToNextDay:(id)sender {
  
  NSDate *nextDay = [dateManipulator findDateWithOffset:1 date:dataController.dateToShow];
  dataController.dateToShow = nextDay;
  
  NSDate *today = [NSDate date];
  NSString *todayString = [dateManipulator getStringOfDateWithoutTime:today];
  NSString *thisDateToShow = [dateManipulator getStringOfDateWithoutTime:dataController.dateToShow];
  UIColor *dateColor = [dateManipulator createDateColor:todayString dateToShowString:thisDateToShow];
  self.dateLabel.textColor = dateColor;
  self.dateLabel.text = thisDateToShow;
  
  [dataController refreshFoodData];
 // [self updateCalorieCount];
  //[self refreshFoodData];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)] withRowAnimation:UITableViewRowAnimationLeft];
  //[self.tableView reloadData];
   
}

- (IBAction)createNewGoal:(id)sender {
  
  [self performSegueWithIdentifier:@"newGoalSegue" sender:self];
  
}
@end
