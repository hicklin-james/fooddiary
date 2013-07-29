//
//  ManageFoodsViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-28.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealController.h"

@interface ManageFoodsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  MealController *controller;
  NSMutableArray *customFoodsArray;
}

@property (strong, nonatomic) NSMutableArray *customFoodsArray;
@property (strong, nonatomic) MealController *controller;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
