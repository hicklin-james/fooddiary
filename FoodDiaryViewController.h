//
//  FoodDiaryViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFoodViewController.h"
#import "MealController.h"

@class FoodDiaryMealDataController;

// implement NewMealViewControllerDelegate Protocol
@interface FoodDiaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  
  MealController *controller;
  MyFood *foodToPassToDetailView;
  MyServing *servingToPassToDetailView;
  
}

@property (nonatomic, retain) MyFood *foodToPassToDetailView;
@property (nonatomic, retain) MyServing *servingToPassToDetailView;
@property (nonatomic, strong) MealController *controller;

@property (weak, nonatomic) IBOutlet UILabel *todaysCals;
@property (weak, nonatomic) IBOutlet UILabel *goalCals;
@property (weak, nonatomic) IBOutlet UILabel *remainingCals;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *rightArrowButton;

- (IBAction)changeToPreviousDay:(id)sender;
- (IBAction)changeToNextDay:(id)sender;

@end
