//
//  FoodDiaryViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFoodViewController.h"
#import "DetailFoodBeforeSelectionViewController.h"
#import "WelcomeViewController.h"

@class FoodDiaryMealDataController;

// implement NewMealViewControllerDelegate Protocol
@interface FoodDiaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  
  NSManagedObjectContext *managedObjectContext;
  NSMutableArray *mealsToday;
  NSMutableArray *breakfastFoods;
  NSMutableArray *lunchFoods;
  NSMutableArray *dinnerFoods;
  NSMutableArray *snacksFoods;
  NSDate *dateToShow;
  MyFood *foodToPassToDetailView;
  MyServing *servingToPassToDetailView;
  
}

@property (nonatomic, retain) MyFood *foodToPassToDetailView;
@property (nonatomic, retain) MyServing *servingToPassToDetailView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *mealsToday;
@property (nonatomic, retain) NSMutableArray *breakfastFoods;
@property (nonatomic, retain) NSMutableArray *lunchFoods;
@property (nonatomic, retain) NSMutableArray *dinnerFoods;
@property (nonatomic, retain) NSMutableArray *snacksFoods;
@property (nonatomic, strong) NSDate *dateToShow;

//@property (strong, nonatomic) IBOutlet UILabel *calorieCountToday;
@property (weak, nonatomic) IBOutlet UILabel *todaysCals;
@property (weak, nonatomic) IBOutlet UILabel *goalCals;
@property (weak, nonatomic) IBOutlet UILabel *remainingCals;

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)changeToPreviousDay:(id)sender;
- (IBAction)changeToNextDay:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *rightArrowButton;


@end
