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
#import <CoreLocation/CoreLocation.h>

@class FoodDiaryDayController;

// implement NewMealViewControllerDelegate Protocol
@interface FoodDiaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
