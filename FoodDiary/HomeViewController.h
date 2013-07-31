//
//  HomeViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-13.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealController.h"

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate> {
  
  MealController *dataController;
  
}

@property (strong, nonatomic) MealController *dataController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITabBar *homeTabBar;
@property (strong, nonatomic) IBOutlet UITabBarItem *summaryItem;
@property (strong, nonatomic) IBOutlet UITabBarItem *todayItem;

@property (strong, nonatomic) IBOutlet UIButton *rightArrowButton;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

- (IBAction)changeToPreviousDay:(id)sender;
- (IBAction)changeToNextDay:(id)sender;
- (IBAction)createNewGoal:(id)sender;
- (IBAction)addFood:(id)sender;



@end
