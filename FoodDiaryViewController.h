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
#import "NoProfileNameViewController.h"

@class FoodDiaryMealDataController;

// implement NewMealViewControllerDelegate Protocol
@interface FoodDiaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NoProfileNameViewControllerDelegate> {
  
  NSManagedObjectContext *managedObjectContext;
  NSMutableArray *mealsToday;
  NSMutableArray *breakfastFoods;
  NSMutableArray *lunchFoods;
  NSMutableArray *dinnerFoods;
  NSMutableArray *snacksFoods;
  NSDate *dateToShow;
  
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *mealsToday;
@property (nonatomic, strong) NSMutableArray *breakfastFoods;
@property (nonatomic, strong) NSMutableArray *lunchFoods;
@property (nonatomic, strong) NSMutableArray *dinnerFoods;
@property (nonatomic, strong) NSMutableArray *snacksFoods;
@property (nonatomic, strong) NSDate *dateToShow;

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)changeToPreviousDay:(id)sender;
- (IBAction)changeToNextDay:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *rightArrowButton;


@end
