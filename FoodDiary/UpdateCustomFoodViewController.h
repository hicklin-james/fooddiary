//
//  UpdateCustomFoodViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-29.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomFood.h"

@interface UpdateCustomFoodViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  
  CustomFood *customFood;
  
}

@property (strong, nonatomic) CustomFood *customFood;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)saveCustomFood:(id)sender;

@end
